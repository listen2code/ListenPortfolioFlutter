class BaseResponseModel<T> {
  final String? result;
  final String? messageId;
  final String? message;
  final T? body;

  const BaseResponseModel({
    this.result,
    this.messageId,
    this.message,
    this.body,
  });

  factory BaseResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return BaseResponseModel<T>(
      result: json['result'] as String?,
      messageId: json['messageId'] as String?,
      message: json['message'] as String?,
      body: json['body'] == null ? null : fromJsonT(json['body']),
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    return {
      'result': result,
      'messageId': messageId,
      'message': message,
      'body': body == null ? null : toJsonT(body as T),
    };
  }
}
