import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'provider/school_connect_provider.dart';
import 'models/school_request_model.dart';
import 'package:intl/intl.dart';
import 'package:dotted_border/dotted_border.dart';

class SchoolConnectScreen extends StatefulWidget {
  const SchoolConnectScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SchoolConnectProvider()..fetchRequests(),
      child: const SchoolConnectScreen(),
    );
  }

  @override
  State<SchoolConnectScreen> createState() => _SchoolConnectScreenState();
}

class _SchoolConnectScreenState extends State<SchoolConnectScreen> {
  // Form State
  bool _isRequestMode = false;
  String? _selectedRequestType;
  
  // Controllers
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController(); // For "Other" or text input if needed
  
  // Form Values
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedReason;
  String? _attachmentPath;

  final List<String> _requestTypes = [
    "Leave application request",
    "Update my details",
    "Teacher Meeting Request",
    "Transition- Pick up/Drop Request",
    "Lost & Found",
    "Other communication",
  ];

  final List<String> _leaveReasons = [
    "Sick Leave",
    "Family Function",
    "Emergency",
    "Vacation",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: appTheme.whiteA700,
      body: Container(
        width: double.infinity,
        height: SizeUtils.height,
        decoration: BoxDecoration(
          color: appTheme.whiteCustom,
          image: DecorationImage(
            image: AssetImage(ImageConstant.imgUpdatesBg), // Assuming same BG as before/requested
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.v),
                  child: Column(
                    children: [
                      if (!_isRequestMode) ...[
                        _buildCreateRequestButton(),
                        SizedBox(height: 32.v),
                        _buildServiceHistorySection(),
                      ] else ...[
                        _buildRequestForm(),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 20.adaptSize, color: Colors.black),
              onPressed: () {
                if (_isRequestMode) {
                  setState(() {
                    _isRequestMode = false;
                    _selectedRequestType = null;
                   _clearForm();
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          Text(
            _isRequestMode ? "Create Request" : "School Connect",
            style: TextStyle(
              fontSize: 20.fSize,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateRequestButton() {
    return GestureDetector(
      onTap: _showRequestTypeModal,
      child: Container(
        width: double.infinity,
        height: 60.v,
        decoration: BoxDecoration(
          color: appTheme.blue500, // Large blue button
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.blue500.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: 24.adaptSize),
            ),
            SizedBox(width: 12.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create Request',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.fSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Raise a new query or request',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12.fSize,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestTypeModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 24.v, horizontal: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Request Type",
                style: TextStyle(
                  fontSize: 18.fSize,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 16.v),
              ..._requestTypes.map((type) => ListTile(
                title: Text(type, style: TextStyle(fontFamily: 'Poppins', fontSize: 14.fSize)),
                trailing: Icon(Icons.arrow_forward_ios, size: 14.adaptSize, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedRequestType = type;
                    _isRequestMode = true;
                  });
                },
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceHistorySection() {
    return Consumer<SchoolConnectProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Service History',
                  style: TextStyle(
                    color: const Color(0xFF333333),
                    fontSize: 16.fSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.history, color: Colors.grey, size: 20.adaptSize),
              ],
            ),
            SizedBox(height: 16.v),
            if (provider.requests.isEmpty)
              _buildNoRecordPlaceholder()
            else
              _buildRequestList(provider.requests),
          ],
        );
      },
    );
  }

  Widget _buildNoRecordPlaceholder() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.v),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.assignment_outlined, size: 40.adaptSize, color: Colors.grey.shade300),
          SizedBox(height: 12.v),
          Text(
            'No record found',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestList(List<SchoolRequestModel> requests) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: requests.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.v),
      itemBuilder: (context, index) {
        final req = requests[index];
        return Container(
         padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.h),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      req.requestType ?? "Unknown Request",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.fSize,
                        fontFamily: 'Poppins',
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  _buildStatusChip(req.status ?? "Pending"),
                ],
              ),
              SizedBox(height: 8.v),
              Text(
                req.message ?? "No details provided",
                style: TextStyle(
                  fontSize: 12.fSize,
                  fontFamily: 'Poppins',
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.v),
              Text(
                req.createdAt != null 
                    ? DateFormat('dd MMM yyyy, hh:mm a').format(req.createdAt!)
                    : "",
                style: TextStyle(
                  fontSize: 10.fSize,
                  fontFamily: 'Poppins',
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.orange;
    if (status == 'Approved') color = Colors.green;
    if (status == 'Rejected') color = Colors.red;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.v),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.h),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10.fSize,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  // --- Form Section ---

  Widget _buildRequestForm() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormHeader(),
          Divider(height: 32.v),
          
          if (_selectedRequestType == "Leave application request") ...[
             _buildLabel("From Date"),
             _buildDatePicker(
               date: _fromDate,
               onTap: () => _pickDate(isFrom: true),
             ),
             SizedBox(height: 16.v),
             _buildLabel("To Date"),
             _buildDatePicker(
               date: _toDate,
               onTap: () => _pickDate(isFrom: false),
             ),
             SizedBox(height: 16.v),
             _buildLabel("Reason"),
             _buildDropdown(_leaveReasons, _selectedReason, (val) => setState(() => _selectedReason = val)),
          ],

          SizedBox(height: 16.v),
          _buildLabel("Message"),
          TextField(
            controller: _messageController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Enter your message details here...",
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14.fSize,
                fontFamily: 'Poppins',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.h),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.h),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.h),
                borderSide: BorderSide(color: appTheme.blue500),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          
          SizedBox(height: 16.v),
          _buildLabel("Attachment"),
          _buildAttachmentBox(),

          SizedBox(height: 24.v),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildFormHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            color: appTheme.blue50.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.edit_document, color: appTheme.blue500, size: 24.adaptSize),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedRequestType ?? "New Request",
                style: TextStyle(
                  fontSize: 16.fSize,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                ),
              ),
              Text(
                "Fill in the details below",
                style: TextStyle(
                  fontSize: 12.fSize,
                  fontFamily: 'Poppins',
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.v),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.fSize,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDatePicker({required DateTime? date, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null ? DateFormat('dd MMM yyyy').format(date) : "Select Date",
              style: TextStyle(
                color: date != null ? Colors.black87 : Colors.grey[400],
                fontSize: 14.fSize,
                fontFamily: 'Poppins',
              ),
            ),
            Icon(Icons.calendar_today, size: 18.adaptSize, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String? selectedItem, Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.h),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedItem,
          isExpanded: true,
          hint: Text(
            "Select Option",
            style: TextStyle(color: Colors.grey[400], fontSize: 14.fSize, fontFamily: 'Poppins'),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontFamily: 'Poppins', fontSize: 14.fSize)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildAttachmentBox() {
    return Consumer<SchoolConnectProvider>(
      builder: (context, provider, _) {
        bool hasFile = provider.selectedAttachmentPath != null;
        
        return GestureDetector(
          onTap: () => provider.pickAttachment(),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.v),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: hasFile ? appTheme.blue50 : appTheme.blue50.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8.h),
              border: Border.all(
                color: appTheme.blue500,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  hasFile ? Icons.check_circle : Icons.cloud_upload_outlined, 
                  color: appTheme.blue500, 
                  size: 32.adaptSize
                ),
                SizedBox(height: 8.v),
                Text(
                  hasFile ? provider.selectedAttachmentName! : "Click to upload file",
                  style: TextStyle(
                    color: appTheme.blue500,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.fSize,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!hasFile)
                  Text(
                    "Supports JPG, PNG, PDF",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 10.fSize,
                      fontFamily: 'Poppins',
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return Consumer<SchoolConnectProvider>(
      builder: (context, provider, _) { 
        return SizedBox(
          width: double.infinity,
          height: 50.v,
          child: ElevatedButton(
            onPressed: provider.isSubmitting ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.blue500,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.h)),
              disabledBackgroundColor: appTheme.blue500.withOpacity(0.6),
            ),
            child: provider.isSubmitting
                ? SizedBox(height: 24.adaptSize, width: 24.adaptSize, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(
                    "Submit Request",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.fSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
          ),
        );
      },
    );
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) _fromDate = picked; else _toDate = picked;
      });
    }
  }

  void _clearForm() {
    _fromDate = null;
    _toDate = null;
    _selectedReason = null;
    _messageController.clear();
    // Provider attachment clear is handled in provider
  }

  Future<void> _submitForm() async {
    if (_messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a message")));
      return;
    }

    final provider = Provider.of<SchoolConnectProvider>(context, listen: false);
    
    // Attachment path is already in provider
    bool success = await provider.submitRequest(
      requestType: _selectedRequestType!,
      message: _messageController.text,
      fromDate: _fromDate,
      toDate: _toDate,
      reason: _selectedReason,
    );

    if (success) {
      if (mounted) {
        setState(() {
          _isRequestMode = false;
          _selectedRequestType = null;
          _clearForm();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Request submitted successfully! Email draft opened."),
            backgroundColor: Colors.green,
          )
        );
      }
    } else {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text("Failed to submit request. Please try again."),
             backgroundColor: Colors.red,
           )
         );
      }
    }
  }
}
