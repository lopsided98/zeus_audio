import setuptools
from setuptools import setup, find_packages


class BuildPackageProtos(setuptools.Command):
    """Command to generate project *_pb2.py modules from proto files."""

    user_options = []

    def initialize_options(self):
        pass

    def finalize_options(self):
        pass

    def run(self):
        from grpc_tools import command
        command.build_package_protos('.')


setup(
    name="audio_recorder",
    version="0.1",
    packages=find_packages(),
    setup_requires=['grpcio-tools'],
    include_package_data=True,
    install_requires=['flask', 'grpcio', 'numpy', 'pyyaml', 'pyalsaaudio'],
    cmdclass={
        'build_proto_modules': BuildPackageProtos
    }
)
