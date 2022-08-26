import argparse
import asyncio
import json
import logging
import os
import subprocess
import threading
import time

import aiohttp_cors
import aiohttp_jinja2
import audio_recorder.protos.audio_server_pb2 as audio_server_pb2
import audio_recorder.protos.audio_server_pb2_grpc as audio_server_pb2_grpc
import grpc
import jinja2
from aiohttp import web
from google.protobuf.empty_pb2 import Empty
from google.protobuf.timestamp_pb2 import Timestamp

_log = logging.getLogger(__name__)

routes = web.RouteTableDef()


@routes.get("/")
@aiohttp_jinja2.template("index.html")
async def root(request: web.Request):
    return {"devices": request.app["DEVICES"]}


@routes.post("/start")
async def start(request: web.Request) -> web.Response:
    audio_server = request.app["audio_server"]
    body = await request.json()
    response = await audio_server.StartRecording(
        audio_server_pb2.StartRecordingRequest(time=int(body["time"] * 1_000_000_000))
    )
    return web.json_response({"synced": response.synced})


@routes.post("/stop")
async def stop(request: web.Request) -> web.Response:
    audio_server = request.app["audio_server"]
    audio_server.StopRecording(Empty())
    return web.Response(status=204)


@routes.get("/status")
async def status(request: web.Request) -> web.Response:
    audio_server = request.app["audio_server"]
    status = await audio_server.GetStatus(Empty())
    return web.json_response(
        {
            "recorder_state": audio_server_pb2.Status.RecorderState.Name(
                status.recorder_state
            )
        }
    )


@routes.get("/levels")
async def get_levels(request: web.Request) -> web.Response:
    average = request.rel_url.query.get("average", "false") == "true"
    response = web.StreamResponse()
    response.content_type = "text/event-stream"
    # Disable NGINX response buffering
    response.headers["X-Accel-Buffering"] = "no"
    await response.prepare(request)

    async for audio_levels in request.app["audio_server"].GetLevels(
        audio_server_pb2.LevelsRequest(average=average)
    ):
        await response.write(
            f"data: {json.dumps(tuple(audio_levels.channels))}\n\n".encode("utf-8")
        )

    return response


@routes.get("/mixer")
async def get_mixer(request: web.Request) -> web.Response:
    audio_server = request.app["audio_server"]
    levels = await audio_server.GetMixer(Empty())
    return web.json_response(tuple(levels.channels))


@routes.post("/mixer")
async def set_mixer(request: web.Request) -> web.Response:
    audio_server = request.app["audio_server"]
    levels = audio_server_pb2.AudioLevels()
    levels.channels.extend(await request.json())
    await audio_server.SetMixer(levels)
    web.Response(status=204)


@routes.post("/time")
async def set_time(request: web.Request) -> web.Response:
    audio_server = request.app["audio_server"]
    time = await request.json()
    await audio_server.SetTime(Timestamp(seconds=time["seconds"], nanos=time["nanos"]))
    web.Response(status=204)


@routes.post("/start_time_sync")
async def start_time_sync(request: web.Request) -> web.Response:
    audio_server = request.app["audio_server"]
    await audio_server.StartTimeSync(Empty())
    web.Response(status=204)


@routes.post("/shutdown")
async def shutdown(request: web.Request) -> web.Response:
    def shutdown_thread():
        _log.info("Shutting down system")
        time.sleep(3)
        try:
            subprocess.run(
                ("/usr/bin/env", "sudo", "-n", "poweroff"),
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=True,
            )
        except subprocess.CalledProcessError as e:
            _log.error(
                "Failed to shutdown system: %s", e.stderr.decode("utf-8").strip()
            )

    _log.info("Shutting down system in 3 seconds")
    threading.Thread(target=shutdown_thread).start()
    web.Response(status=204)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--socket", help="Unix domain socket to bind to")
    parser.add_argument("--host", help="Host to bind to")
    parser.add_argument("--port", help="TCP port number to listen on")
    parser.add_argument("--audio-server", default="localhost:34876")
    parser.add_argument("--device", action="append")
    args = parser.parse_args()

    app_dir = os.path.dirname(__file__)

    # Make sure everything runs on the same event loop
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)

    print(args.device)
    app = web.Application()
    app.update(
        {
            "static_root_url": "/static",
            "AUDIO_SERVER_HOST": args.audio_server,
            "DEVICES": args.device or [""],
        }
    )

    # Serve static files
    routes.static(app["static_root_url"], os.path.join(app_dir, "static"))

    grpc_channel = grpc.aio.insecure_channel(app["AUDIO_SERVER_HOST"])
    app["audio_server"] = audio_server_pb2_grpc.AudioServerStub(grpc_channel)

    resources = app.add_routes(routes)

    # Allow cross-origin requests
    cors = aiohttp_cors.setup(
        app,
        defaults={
            "*": aiohttp_cors.ResourceOptions(
                allow_credentials=True,
                expose_headers="*",
                allow_headers="*",
            )
        },
    )
    for resource in resources:
        cors.add(resource)

    # Setup template rendering
    aiohttp_jinja2.setup(
        app, loader=jinja2.FileSystemLoader(os.path.join(app_dir, "templates"))
    )

    web.run_app(app, loop=loop, path=args.socket, host=args.host, port=args.port)

if __name__ == "__main__":
    main()
