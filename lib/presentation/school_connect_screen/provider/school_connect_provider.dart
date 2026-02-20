import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/app_export.dart';
import '../models/school_connect_model.dart';
import '../models/school_request_model.dart';
import '../../../db_helper.dart';
import 'package:intl/intl.dart';

class SchoolConnectProvider extends ChangeNotifier {
  SchoolConnectModel schoolConnectModel = SchoolConnectModel();
  List<SchoolRequestModel> requests = [];
  bool isLoading = false;
  bool isSubmitting = false;

  // Form Data
  String? selectedAttachmentPath;
  String? selectedAttachmentName;

  // Fetch School Info (Existing)
  Future<void> fetchSchoolDetails() async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await DBHelper.getSchoolConnectDetails();
      if (data != null) {
        schoolConnectModel = SchoolConnectModel.fromMap(data);
      }
    } catch (e) {
      print("Provider Error fetching school details: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch Service Requests
  Future<void> fetchRequests() async {
    // isLoading = true; 
    notifyListeners();

    try {
      String email = "parent@example.com"; 
      
      final data = await DBHelper.getSchoolRequests(email);
      requests = data.map((e) => SchoolRequestModel.fromMap(e)).toList();
    } catch (e) {
      print("Provider Error fetching requests: $e");
    } finally {
      // isLoading = false;
      notifyListeners();
    }
  }

  // Pick Attachment
  Future<void> pickAttachment() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf'],
      );

      if (result != null) {
        selectedAttachmentPath = result.files.single.path;
        selectedAttachmentName = result.files.single.name;
        notifyListeners();
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  void clearAttachment() {
    selectedAttachmentPath = null;
    selectedAttachmentName = null;
    notifyListeners();
  }

  // Submit Request
  Future<bool> submitRequest({
    required String requestType,
    required String message,
    DateTime? fromDate,
    DateTime? toDate,
    String? reason,
  }) async {
    isSubmitting = true;
    notifyListeners();

    try {
      String email = "parent@example.com"; // TODO: Get actual logged in user email
      String studentName = "John Doe"; // TODO: Get actual student name
      
      // 1. Save to Database
      bool dbSuccess = await DBHelper.submitSchoolRequest(
        parentEmail: email,
        requestType: requestType,
        message: message,
        fromDate: fromDate,
        toDate: toDate,
        reason: reason,
        attachmentPath: selectedAttachmentPath,
      );

      if (dbSuccess) {
        await fetchRequests(); // Refresh list

        // 2. Draft Email
        await _draftEmail(
          requestType: requestType,
          message: message,
          fromDate: fromDate,
          toDate: toDate,
          reason: reason,
          childName: studentName, // Placeholder
          attachmentPath: selectedAttachmentPath,
        );
      }
      return dbSuccess;
    } catch (e) {
      print("Provider Error submitting request: $e");
      return false;
    } finally {
      isSubmitting = false;
      clearAttachment(); // Clear attachment after submit attempt
      notifyListeners();
    }
  }

  Future<void> _draftEmail({
    required String requestType,
    required String message,
    required String childName,
    DateTime? fromDate,
    DateTime? toDate,
    String? reason,
    String? attachmentPath,
  }) async {
    final Email email = Email(
      body: _buildEmailBody(message, fromDate, toDate, reason),
      subject: '[Request] $requestType - $childName',
      recipients: ['bluestonetechparkwebdeveloper@gmail.com'],
      attachmentPaths: attachmentPath != null ? [attachmentPath] : null,
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      print("Error sending email: $e");
      // Don't fail the whole submission if email drafting fails, 
      // but maybe show a separate toast in UI?
    }
  }

  String _buildEmailBody(String message, DateTime? from, DateTime? to, String? reason) {
    StringBuffer body = StringBuffer();
    body.writeln("Request Details:\n");
    if (reason != null) body.writeln("Reason: $reason");
    if (from != null) body.writeln("From: ${DateFormat('dd MMM yyyy').format(from)}");
    if (to != null) body.writeln("To: ${DateFormat('dd MMM yyyy').format(to)}");
    body.writeln("\nMessage:\n$message");
    return body.toString();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
