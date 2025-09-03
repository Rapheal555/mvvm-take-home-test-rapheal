import 'package:equatable/equatable.dart';

class ApiException extends Equatable implements Exception {
  final String message;
  final String? code;
  final dynamic data;

  const ApiException({required this.message, this.code, this.data});

  @override
  List<Object?> get props => [message, code, data];

  @override
  String toString() => 'ApiException(message: $message, code: $code)';

  factory ApiException.fromJson(Map<String, dynamic> json) {
    return ApiException(
      message: json['message'] as String? ?? 'Unknown error occurred',
      code: json['code'] as String?,
      data: json['data'],
    );
  }
}

class NetworkException extends ApiException {
  const NetworkException({String message = 'Network error occurred'})
    : super(message: message, code: 'NETWORK_ERROR');
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({String message = 'Unauthorized'})
    : super(message: message, code: 'UNAUTHORIZED');
}

class ValidationException extends ApiException {
  const ValidationException({
    String message = 'Validation failed',
    dynamic data,
  }) : super(message: message, code: 'VALIDATION_ERROR', data: data);
}
