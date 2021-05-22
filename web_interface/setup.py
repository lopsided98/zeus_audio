import os
import sys

import pkg_resources
import setuptools
from grpc_tools import protoc
from setuptools import setup, find_packages


def build_package_protos(proto_root, python_root):
    proto_files = []
    inclusion_root = os.path.abspath(proto_root)
    for root, _, files in os.walk(inclusion_root):
        for filename in files:
            if filename.endswith(".proto"):
                proto_files.append(os.path.abspath(os.path.join(root, filename)))

    well_known_protos_include = pkg_resources.resource_filename("grpc_tools", "_proto")

    command = [
        "grpc_tools.protoc",
        "--proto_path={}".format(inclusion_root),
        "--proto_path={}".format(well_known_protos_include),
        "--python_out={}".format(python_root),
        "--grpc_python_out={}".format(python_root),
    ] + proto_files
    if protoc.main(command) != 0:
        sys.stderr.write("warning: {} failed".format(command))


class BuildPackageProtos(setuptools.Command):
    """Command to generate project *_pb2.py modules from proto files."""

    description = "build grpc protobuf modules"
    user_options = []

    def initialize_options(self):
        pass

    def finalize_options(self):
        pass

    def run(self):
        build_package_protos("../protos", ".")


setup(
    name="audio_recorder",
    version="0.5.0",
    packages=find_packages(),
    setup_requires=["grpcio-tools"],
    include_package_data=True,
    install_requires=["aiohttp", "aiohttp-cors", "aiohttp-jinja2", "grpcio"],
    cmdclass={"build_proto_modules": BuildPackageProtos},
)
