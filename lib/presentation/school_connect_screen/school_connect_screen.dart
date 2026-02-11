import 'package:flutter/material.dart';
import '../../core/app_export.dart';

import 'provider/school_connect_provider.dart';

class SchoolConnectScreen extends StatefulWidget {
  const SchoolConnectScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SchoolConnectProvider(),
      child: const SchoolConnectScreen(),
    );
  }

  @override
  State<SchoolConnectScreen> createState() => _SchoolConnectScreenState();
}

class _SchoolConnectScreenState extends State<SchoolConnectScreen> {
  bool _isRequestMode = false;
  String? _selectedRequestType;

  final List<String> _requestTypes = [
    "Leave application request",
    "Update my details",
    "Teacher Meeting Request",
    "Transition- Pick up/Drop Request",
    "Lost & Found",
    "Other communication",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: SizeUtils.height,
        decoration: BoxDecoration(
          color: appTheme.whiteCustom,
          image: DecorationImage(
            image: AssetImage(ImageConstant.imgUpdatesBg),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_isRequestMode)
                        _buildCreateRequestButton()
                      else
                        _buildSelectRequestType(),
                      SizedBox(height: 32.v),
                      _buildServiceHistorySection(),
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
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Text(
            "School Connect",
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
      onTap: () {
        setState(() {
          _isRequestMode = true;
        });
      },
      child: Container(
        width: double.infinity,
        height: 48.v,
        decoration: BoxDecoration(
          color: const Color(0xFF32B6F3),
          borderRadius: BorderRadius.circular(8.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: Colors.white, size: 24.adaptSize),
            SizedBox(width: 8.h),
            Text(
              'Create Request',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.fSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectRequestType() {
    if (_selectedRequestType == null) {
      return GestureDetector(
        onTap: _showRequestTypeModal,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 16.v),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.h),
            boxShadow: [
              BoxShadow(
                color: const Color(0x26000000),
                blurRadius: 24,
                offset: Offset(0, 8),
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select your request type',
                style: TextStyle(
                  color: const Color(0xFF808080),
                  fontSize: 14.fSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.keyboard_arrow_down, size: 24.adaptSize, color: const Color(0xFF808080)),
            ],
          ),
        ),
      );
    } else {
      return _buildForm();
    }
  }

  Widget _buildForm() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: const Color(0x26000000),
            blurRadius: 24,
            offset: Offset(0, 8),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Request Type"),
          GestureDetector(
            onTap: _showRequestTypeModal,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.v),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8.h),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedRequestType!,
                    style: TextStyle(
                      color: Colors.black, // Selected text color
                      fontSize: 14.fSize,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Dynamic content based on type
          if (_selectedRequestType == "Leave application request")
            _buildLeaveApplicationForm()
          else if (_selectedRequestType == "Teacher Meeting Request")
            _buildTeacherMeetingForm()
          else if (_selectedRequestType == "Transition- Pick up/Drop Request")
            _buildPickupDropForm()
          else if (_selectedRequestType == "Lost & Found")
            _buildLostFoundForm()
          else
            _buildGenericForm(), // Fallback for Update Details & Other
        ],
      ),
    );
  }

  Widget _buildLeaveApplicationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("From"),
        _buildDateField("Select Date"),
        const SizedBox(height: 16),
        _buildLabel("To"),
        _buildDateField("Select Date"),
        const SizedBox(height: 16),
        _buildLabel("Leave Reason"),
        _buildDropdownField("Select Reason", ["Sick Leave", "Family Function", "Emergency", "Other"]),
        const SizedBox(height: 16),
        _buildLabel("Message"),
        _buildTextField("Enter message", maxLines: 3),
        const SizedBox(height: 16),
        _buildLabel("Attach"),
        _buildAttachmentField(),
        const SizedBox(height: 24),
        _buildSendButton(),
      ],
    );
  }

  Widget _buildTeacherMeetingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Preferred Date"),
        _buildDateField("Select Date"),
        const SizedBox(height: 16),
        _buildLabel("Preferred Time"),
        _buildDropdownField("Select Time Slot", ["Morning (9-11 AM)", "Afternoon (1-3 PM)", "Evening (3-5 PM)"]),
        const SizedBox(height: 16),
        _buildLabel("Topic"),
        _buildTextField("Enter topic of discussion"),
        const SizedBox(height: 16),
        _buildLabel("Message"),
        _buildTextField("Enter message", maxLines: 3),
        const SizedBox(height: 24),
        _buildSendButton(),
      ],
    );
  }

  Widget _buildPickupDropForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Request Type"),
        _buildDropdownField("Select Type", ["Pickup Change", "Drop-off Change", "Both"]),
        const SizedBox(height: 16),
        _buildLabel("Effective Date"),
        _buildDateField("Select Date"),
        const SizedBox(height: 16),
        _buildLabel("Authorized Person Name"),
        _buildTextField("Enter person's name"),
        const SizedBox(height: 16),
        _buildLabel("Contact Number"),
        _buildTextField("Enter contact number"),
        const SizedBox(height: 16),
        _buildLabel("Message"),
        _buildTextField("Enter message", maxLines: 3),
        const SizedBox(height: 24),
        _buildSendButton(),
      ],
    );
  }

  Widget _buildLostFoundForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Item Description"),
        _buildTextField("Enter item details (color, brand, etc.)"),
        const SizedBox(height: 16),
        _buildLabel("Date Lost"),
        _buildDateField("Select Date"),
        const SizedBox(height: 16),
        _buildLabel("Possible Location"),
        _buildTextField("Enter location (e.g. Playground, Class)"),
        const SizedBox(height: 16),
        _buildLabel("Attach Image (Optional)"),
        _buildAttachmentField(),
        const SizedBox(height: 24),
        _buildSendButton(),
      ],
    );
  }


  Widget _buildGenericForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Message"),
        _buildTextField("Enter details...", maxLines: 4),
        const SizedBox(height: 24),
        _buildSendButton(),
      ],
    );
  }

  // --- Helper Widgets ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.v),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF333333),
          fontSize: 14.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDateField(String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.v),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hint,
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 14.fSize,
              fontFamily: 'Poppins',
            ),
          ),
          Icon(Icons.calendar_today_outlined, size: 20.adaptSize, color: const Color(0xFF9CA3AF)),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String hint, List<String> items) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 0.v), // Vertical padding handled by DropdownButton
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 14.fSize,
              fontFamily: 'Poppins',
            ),
          ),
          icon: Icon(Icons.arrow_drop_down, color: const Color(0xFF9CA3AF)),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 14.fSize, fontFamily: 'Poppins')),
            );
          }).toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color(0xFF9CA3AF),
          fontSize: 14.fSize,
          fontFamily: 'Poppins',
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.v),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(color: const Color(0xFF32B6F3)),
        ),
      ),
    );
  }

  Widget _buildAttachmentField() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.v),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(
          color: const Color(0xFF32B6F3),
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: const Color(0xFF32B6F3), size: 20.adaptSize),
              SizedBox(width: 4.h),
              Text(
                "Add",
                style: TextStyle(
                  color: const Color(0xFF32B6F3),
                  fontSize: 14.fSize,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

    Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.v,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF32B6F3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.h)),
          elevation: 0,
        ),
        child: Text(
          "Send",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.fSize,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
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
            children: _requestTypes.map((type) {
              return ListTile(
                title: Text(
                  type,
                  style: TextStyle(
                    fontSize: 14.fSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedRequestType = type;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildServiceHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        SizedBox(height: 12.v),
        Container(
          width: double.infinity,
          height: 48.v,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.h),
            border: Border.all(
              width: 2,
              color: const Color(0xFF32B6F3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No record found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF32B6F3),
                  fontSize: 15.fSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
