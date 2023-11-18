#!/usr/bin/env bash
# *****************************************************************#
# (C) Copyright IBM Corporation 2022.                             #
#                                                                 #
# The source code for this program is not published or otherwise  #
# divested of its trade secrets, irrespective of what has been    #
# deposited with the U.S. Copyright Office.                       #
# *****************************************************************#

from ast import Import
import sys
import importlib, os
from google.protobuf import descriptor_pool
from contextlib import contextmanager


@contextmanager
def local_desc_pool():
    local_pool = descriptor_pool.DescriptorPool()
    standard_default = descriptor_pool._DEFAULT
    message_default = None
    try:
        from google.protobuf.pyext import _message

        message_default = _message.default_pool
        _message.default_pool = local_pool
    except ImportError:
        pass
    descriptor_pool._DEFAULT = local_pool
    yield local_pool
    descriptor_pool._DEFAULT = standard_default
    if message_default is not None:
        _message.default_pool = message_default


@contextmanager
def local_import_path():
    sys.path.insert(0, os.path.realpath(os.path.dirname(__file__)))
    yield
    sys.path = sys.path[1:]


with local_desc_pool() as client_desc:
    _DESCRIPTOR_POOL = client_desc
    with local_import_path():
        for f_name in os.listdir(os.path.dirname(__file__)):
            name = os.path.splitext(f_name)[0]
            # we only want to import the service pb2 grpc files
            if name.endswith("_pb2") or name.endswith("service_pb2_grpc"):
                assert name not in globals()
                globals()[name] = importlib.import_module(name)