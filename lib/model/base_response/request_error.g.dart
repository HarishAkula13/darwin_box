// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldErrorModel _$FieldErrorModelFromJson(Map<String, dynamic> json) =>
    FieldErrorModel(
      field: json['field'] as String?,
      message: json['message'] as String?,
    );

RequestError _$RequestErrorFromJson(Map<String, dynamic> json) => RequestError(
      statusCode: (json['statusCode'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RequestErrorToJson(RequestError instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
    };
