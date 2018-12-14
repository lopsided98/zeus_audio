# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: audio_recorder/protos/audio_server.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


from google.protobuf import empty_pb2 as google_dot_protobuf_dot_empty__pb2
from google.protobuf import timestamp_pb2 as google_dot_protobuf_dot_timestamp__pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='audio_recorder/protos/audio_server.proto',
  package='audio_recorder.protos',
  syntax='proto3',
  serialized_pb=_b('\n(audio_recorder/protos/audio_server.proto\x12\x15\x61udio_recorder.protos\x1a\x1bgoogle/protobuf/empty.proto\x1a\x1fgoogle/protobuf/timestamp.proto\"\x1b\n\x06Status\x12\x11\n\trecording\x18\x01 \x01(\x08\" \n\rLevelsRequest\x12\x0f\n\x07\x61verage\x18\x01 \x01(\x08\"\x1f\n\x0b\x41udioLevels\x12\x10\n\x08\x63hannels\x18\x01 \x03(\x02\x32\x8a\x04\n\x0b\x41udioServer\x12\x42\n\x0eStartRecording\x12\x16.google.protobuf.Empty\x1a\x16.google.protobuf.Empty\"\x00\x12\x41\n\rStopRecording\x12\x16.google.protobuf.Empty\x1a\x16.google.protobuf.Empty\"\x00\x12\x44\n\tGetStatus\x12\x16.google.protobuf.Empty\x1a\x1d.audio_recorder.protos.Status\"\x00\x12Y\n\tGetLevels\x12$.audio_recorder.protos.LevelsRequest\x1a\".audio_recorder.protos.AudioLevels\"\x00\x30\x01\x12H\n\x08SetMixer\x12\".audio_recorder.protos.AudioLevels\x1a\x16.google.protobuf.Empty\"\x00\x12H\n\x08GetMixer\x12\x16.google.protobuf.Empty\x1a\".audio_recorder.protos.AudioLevels\"\x00\x12?\n\x07SetTime\x12\x1a.google.protobuf.Timestamp\x1a\x16.google.protobuf.Empty\"\x00\x62\x06proto3')
  ,
  dependencies=[google_dot_protobuf_dot_empty__pb2.DESCRIPTOR,google_dot_protobuf_dot_timestamp__pb2.DESCRIPTOR,])




_STATUS = _descriptor.Descriptor(
  name='Status',
  full_name='audio_recorder.protos.Status',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='recording', full_name='audio_recorder.protos.Status.recording', index=0,
      number=1, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=129,
  serialized_end=156,
)


_LEVELSREQUEST = _descriptor.Descriptor(
  name='LevelsRequest',
  full_name='audio_recorder.protos.LevelsRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='average', full_name='audio_recorder.protos.LevelsRequest.average', index=0,
      number=1, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=158,
  serialized_end=190,
)


_AUDIOLEVELS = _descriptor.Descriptor(
  name='AudioLevels',
  full_name='audio_recorder.protos.AudioLevels',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='channels', full_name='audio_recorder.protos.AudioLevels.channels', index=0,
      number=1, type=2, cpp_type=6, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=192,
  serialized_end=223,
)

DESCRIPTOR.message_types_by_name['Status'] = _STATUS
DESCRIPTOR.message_types_by_name['LevelsRequest'] = _LEVELSREQUEST
DESCRIPTOR.message_types_by_name['AudioLevels'] = _AUDIOLEVELS
_sym_db.RegisterFileDescriptor(DESCRIPTOR)

Status = _reflection.GeneratedProtocolMessageType('Status', (_message.Message,), dict(
  DESCRIPTOR = _STATUS,
  __module__ = 'audio_recorder.protos.audio_server_pb2'
  # @@protoc_insertion_point(class_scope:audio_recorder.protos.Status)
  ))
_sym_db.RegisterMessage(Status)

LevelsRequest = _reflection.GeneratedProtocolMessageType('LevelsRequest', (_message.Message,), dict(
  DESCRIPTOR = _LEVELSREQUEST,
  __module__ = 'audio_recorder.protos.audio_server_pb2'
  # @@protoc_insertion_point(class_scope:audio_recorder.protos.LevelsRequest)
  ))
_sym_db.RegisterMessage(LevelsRequest)

AudioLevels = _reflection.GeneratedProtocolMessageType('AudioLevels', (_message.Message,), dict(
  DESCRIPTOR = _AUDIOLEVELS,
  __module__ = 'audio_recorder.protos.audio_server_pb2'
  # @@protoc_insertion_point(class_scope:audio_recorder.protos.AudioLevels)
  ))
_sym_db.RegisterMessage(AudioLevels)



_AUDIOSERVER = _descriptor.ServiceDescriptor(
  name='AudioServer',
  full_name='audio_recorder.protos.AudioServer',
  file=DESCRIPTOR,
  index=0,
  options=None,
  serialized_start=226,
  serialized_end=748,
  methods=[
  _descriptor.MethodDescriptor(
    name='StartRecording',
    full_name='audio_recorder.protos.AudioServer.StartRecording',
    index=0,
    containing_service=None,
    input_type=google_dot_protobuf_dot_empty__pb2._EMPTY,
    output_type=google_dot_protobuf_dot_empty__pb2._EMPTY,
    options=None,
  ),
  _descriptor.MethodDescriptor(
    name='StopRecording',
    full_name='audio_recorder.protos.AudioServer.StopRecording',
    index=1,
    containing_service=None,
    input_type=google_dot_protobuf_dot_empty__pb2._EMPTY,
    output_type=google_dot_protobuf_dot_empty__pb2._EMPTY,
    options=None,
  ),
  _descriptor.MethodDescriptor(
    name='GetStatus',
    full_name='audio_recorder.protos.AudioServer.GetStatus',
    index=2,
    containing_service=None,
    input_type=google_dot_protobuf_dot_empty__pb2._EMPTY,
    output_type=_STATUS,
    options=None,
  ),
  _descriptor.MethodDescriptor(
    name='GetLevels',
    full_name='audio_recorder.protos.AudioServer.GetLevels',
    index=3,
    containing_service=None,
    input_type=_LEVELSREQUEST,
    output_type=_AUDIOLEVELS,
    options=None,
  ),
  _descriptor.MethodDescriptor(
    name='SetMixer',
    full_name='audio_recorder.protos.AudioServer.SetMixer',
    index=4,
    containing_service=None,
    input_type=_AUDIOLEVELS,
    output_type=google_dot_protobuf_dot_empty__pb2._EMPTY,
    options=None,
  ),
  _descriptor.MethodDescriptor(
    name='GetMixer',
    full_name='audio_recorder.protos.AudioServer.GetMixer',
    index=5,
    containing_service=None,
    input_type=google_dot_protobuf_dot_empty__pb2._EMPTY,
    output_type=_AUDIOLEVELS,
    options=None,
  ),
  _descriptor.MethodDescriptor(
    name='SetTime',
    full_name='audio_recorder.protos.AudioServer.SetTime',
    index=6,
    containing_service=None,
    input_type=google_dot_protobuf_dot_timestamp__pb2._TIMESTAMP,
    output_type=google_dot_protobuf_dot_empty__pb2._EMPTY,
    options=None,
  ),
])
_sym_db.RegisterServiceDescriptor(_AUDIOSERVER)

DESCRIPTOR.services_by_name['AudioServer'] = _AUDIOSERVER

# @@protoc_insertion_point(module_scope)