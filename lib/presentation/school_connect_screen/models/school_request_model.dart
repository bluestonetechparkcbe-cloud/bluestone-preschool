class SchoolRequestModel {
  int? id;
  String? requestType;
  DateTime? fromDate;
  DateTime? toDate;
  String? reason;
  String? message;
  String? attachmentPath;
  String? status;
  DateTime? createdAt;

  SchoolRequestModel({
    this.id,
    this.requestType,
    this.fromDate,
    this.toDate,
    this.reason,
    this.message,
    this.attachmentPath,
    this.status,
    this.createdAt,
  });

  factory SchoolRequestModel.fromMap(Map<String, dynamic> map) {
    return SchoolRequestModel(
      id: map['id'],
      requestType: map['request_type'],
      fromDate: map['from_date'], // handled as DateTime? by map usually if parsed
      toDate: map['to_date'],
      reason: map['reason'],
      message: map['message'],
      attachmentPath: map['attachment_path'],
      status: map['status'],
      createdAt: map['created_at'],
    );
  }
}
