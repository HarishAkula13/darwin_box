
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'request_error.g.dart';

@JsonSerializable(createToJson: false)
class FieldErrorModel {
  final String? field;
  final String? message;

  FieldErrorModel({this.field, this.message});

  factory FieldErrorModel.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorModelFromJson(json);
}
@JsonSerializable()
class RequestError {
  final int? statusCode;

  String? _error;

  List<FieldErrorModel>? _errors;

  String? get error => _error;

  List<FieldErrorModel>? get errors => _errors;

  RequestError({this.statusCode, data}) {
    if (data != null){


    }
  }

  factory RequestError.singleMessage(String message) {

    final e = RequestError();
    e._error = message;
    return e;
  }

  factory RequestError.noUser() {
    return RequestError().._error = "No User";
  }

  factory RequestError.noToken() {
    return RequestError().._error = "Empty Token";
  }

  _parseError(Map d) {
    print(d);

    //_error = d['error'];
    if (d['errors'] != null) {
      _errors = List<FieldErrorModel>.from(d['errors'].map((e) => FieldErrorModel.fromJson(e)));
    }


  }
}