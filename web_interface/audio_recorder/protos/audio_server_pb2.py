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
  serialized_pb=_b('\n(audio_recorder/protos/audio_server.proto\x12\x15\x61udio_recorder.protos\x1a\x1bgoogle/protobuf/empty.proto\x1a\x1fgoogle/protobuf/timestamp.proto\"%\n\x15StartRecordingRequest\x12\x0c\n\x04time\x18\x01 \x01(\x04\"(\n\x16StartRecordingResponse\x12\x0e\n\x06synced\x18\x01 \x01(\x08\"\x9d\x01\n\x06Status\x12\x43\n\x0erecorder_state\x18\x01 \x01(\x0e\x32+.audio_recorder.protos.Status.RecorderState\"N\n\rRecorderState\x12\x0b\n\x07STOPPED\x10\x00\x12\x0b\n\x07WAITING\x10\x01\x12\r\n\tRECORDING\x10\x02\x12\x14\n\x10RECORDING_SYNCED\x10\x03\" \n\rLevelsRequest\x12\x0f\n\x07\x61verage\x18\x01 \x01(\x08\"\x1f\n\x0b\x41udioLevels\x12\x10\n\x08\x63hannels\x18\x01 \x03(\x02\x32\xfa\x04\n\x0b\x41udioServer\x12o\n\x0eStartRecording\x12,.audio_recorder.protos.StartRecordingRequest\x1a-.audio_recorder.protos.StartRecordingResponse\"\x00\x12\x41\n\rStopRecording\x12\x16.google.protobuf.Empty\x1a\x16.google.protobuf.Empty\"\x00\x12\x44\n\tGetStatus\x12\x16.google.protobuf.Empty\x1a\x1d.audio_recorder.protos.Status\"\x00\x12Y\n\tGetLevels\x12$.audio_recorder.protos.LevelsRequest\x1a\".audio_recorder.protos.AudioLevels\"\x00\x30\x01\x12H\n\x08SetMixer\x12\".audio_recorder.protos.AudioLevels\x1a\x16.google.protobuf.Empty\"\x00\x12H\n\x08GetMixer\x12\x16.google.protobuf.Empty\x1a\".audio_recorder.protos.AudioLevels\"\x00\x12?\n\x07SetTime\x12\x1a.google.protobuf.Timestamp\x1a\x16.google.protobuf.Empty\"\x00\x12\x41\n\rStartTimeSync\x12\x16.google.protobuf.Empty\x1a\x16.google.protobuf.Empty\"\x00\x62\x06proto3')
  ,
  dependencies=[google_dot_protobuf_dot_empty__pb2.DESCRIPTOR,google_dot_protobuf_dot_timestamp__pb2.DESCRIPTOR,])



_STATUS_RECORDERSTATE = _descriptor.EnumDescriptor(
  name='RecorderState',
  full_name='audio_recorder.protos.Status.RecorderState',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='STOPPED', index=0, number=0,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='WAITING', index=1, number=1,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='RECORDING', index=2, number=2,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='RECORDING_SYNCED', index=3, number=3,
      options=None,
      type=None),
  ],
  containing_type=None,
  options=None,
  serialized_start=290,
  serialized_end=368,
)
_sym_db.RegisterEnumDescriptor(_STATUS_RECORDERSTATE)


_STARTRECORDINGREQUEST = _descriptor.Descriptor(
  name='StartRecordingRequest',
  full_name='audio_recorder.protos.StartRecordingRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='time', full_name='audio_recorder.protos.StartRecordingRequest.time', index=0,
      number=1, type=4, cpp_type=4, label=1,
      has_default_value=False, default_value=0,
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
  serialized_end=166,
)


_STARTRECORDINGRESPONSE = _descriptor.Descriptor(
  name='StartRecordingResponse',
  full_name='audio_recorder.protos.StartRecordingResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='synced', full_name='audio_recorder.protos.StartRecordingResponse.synced', index=0,
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
  serialized_start=168,
  serialized_end=208,
)


_STATUS = _descriptor.Descriptor(
  name='Status',
  full_name='audio_recorder.protos.Status',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='recorder_state', full_name='audio_recorder.protos.Status.recorder_state', index=0,
      number=1, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
    _STATUS_RECORDERSTATE,
  ],
  options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=211,
  serialized_end=368,
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
  serialized_start=370,
  serialized_end=402,
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
  serialized_start=404,
  serialized_end=435,
)

_STATUS.fields_by_name['recorder_state'].enum_type = _STATUS_RECORDERSTATE
_STATUS_RECORDERSTATE.containing_type = _STATUS
DESCRIPTOR.message_types_by_name['StartRecordingRequest'] = _STARTRECORDINGREQUEST
DESCRIPTOR.message_types_by_name['StartRecordingResponse'] = _STARTRECORDINGRESPONSE
DESCRIPTOR.message_types_by_name['Status'] = _STATUS
DESCRIPTOR.message_types_by_name['LevelsRequest'] = _LEVELSREQUEST
DESCRIPTOR.message_types_by_name['AudioLevels'] = _AUDIOLEVELS
_sym_db.RegisterFileDescriptor(DESCRIPTOR)

StartRecordingRequest = _reflection.GeneratedProtocolMessageType('StartRecordingRequest', (_message.Message,), dict(
  DESCRIPTOR = _STARTRECORDINGREQUEST,
  __module__ = 'audio_recorder.protos.audio_server_pb2'
  # @@protoc_insertion_point(class_scope:audio_recorder.protos.StartRecordingRequest)
  ))
_sym_db.RegisterMessage(StartRecordingRequest)

StartRecordingResponse = _reflection.GeneratedProtocolMessageType('StartRecordingResponse', (_message.Message,), dict(
  DESCRIPTOR = _STARTRECORDINGRESPONSE,
  __module__ = 'audio_recorder.protos.audio_server_pb2'
  # @@protoc_insertion_point(class_scope:audio_recorder.protos.StartRecordingResponse)
  ))
_sym_db.RegisterMessage(StartRecordingResponse)

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
  serialized_start=438,
  serialized_end=1072,
  methods=[
  _descriptor.MethodDescriptor(
    name='StartRecording',
    full_name='audio_recorder.protos.AudioServer.StartRecording',
    index=0,
    containing_service=None,
    input_type=_STARTRECORDINGREQUEST,
    output_type=_STARTRECORDINGRESPONSE,
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
  _descriptor.MethodDescriptor(
    name='StartTimeSync',
    full_name='audio_recorder.protos.AudioServer.StartTimeSync',
    index=7,
    containing_service=None,
    input_type=google_dot_protobuf_dot_empty__pb2._EMPTY,
    output_type=google_dot_protobuf_dot_empty__pb2._EMPTY,
    options=None,
  ),
])
_sym_db.RegisterServiceDescriptor(_AUDIOSERVER)

DESCRIPTOR.services_by_name['AudioServer'] = _AUDIOSERVER

# @@protoc_insertion_point(module_scope)
