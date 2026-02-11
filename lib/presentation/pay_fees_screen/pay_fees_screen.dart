import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class PayFeesScreen extends StatefulWidget {
  const PayFeesScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return const PayFeesScreen();
  }

  @override
  State<PayFeesScreen> createState() => _PayFeesScreenState();
}

class _PayFeesScreenState extends State<PayFeesScreen> {
  int _selectedTab = 0; // 0: Details, 1: History

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
              _header(context),
              SizedBox(height: 16.v),
              _summaryCard(),
              SizedBox(height: 16.v),
              Expanded(child: _paymentDetailsSection()), // Expanded to allow list scrolling
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- HEADER ----------------
  Widget _header(BuildContext context) {
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
            "Pay Fees",
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

  /// ---------------- SUMMARY CARD ----------------
  Widget _summaryCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(16.h),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total Fees", style: TextStyle(fontSize: 14.fSize, fontFamily: 'Poppins')),
          SizedBox(height: 4.v),
          Text("53,700",
              style: TextStyle(fontSize: 20.fSize, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
          SizedBox(height: 12.v),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.h),
                  child: LinearProgressIndicator(
                    value: 1,
                    minHeight: 8.v,
                    backgroundColor: const Color(0xFFE0E0E0),
                    valueColor: AlwaysStoppedAnimation(const Color(0xFF22C55E)),
                  ),
                ),
              ),
              SizedBox(width: 12.h),
              Text("100%", style: TextStyle(fontFamily: 'Poppins', color: Colors.grey[600])),
            ],
          ),
          Divider(height: 24.v, color: const Color(0xFFF0F0F0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: const Color(0xFF22C55E), size: 20.adaptSize),
                  SizedBox(width: 8.h),
                  Text("Paid", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.download_rounded, size: 18.adaptSize),
                label: Text("Download Invoice", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF32B6F3),
                  side: const BorderSide(color: Color(0xFF32B6F3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.h)),
                  padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  /// ---------------- PAYMENT DETAILS SECTION ----------------
  Widget _paymentDetailsSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.h, 0, 16.h, 16.v), // Removed top margin as handled by column
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Keep min so cards don't expand unnecessarily if content is small
        children: [
          /// Tabs
          Row(
            children: [
              _tabItem("Details", 0),
              SizedBox(width: 16.h),
              _tabItem("History", 1),
            ],
          ),

          SizedBox(height: 16.v),

          // Content Switcher
          if (_selectedTab == 0) _buildDetailsContent() else _buildHistoryList(),
        ],
      ),
    );
  }

  Widget _buildDetailsContent() {
    return Column(
      children: [
        /// Term Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Term 1",
              style: TextStyle(
                fontSize: 16.fSize,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                Text(
                  "₹ 53,700",
                  style: TextStyle(
                    fontSize: 16.fSize,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 8.h),
                _paidChip(),
              ],
            )
          ],
        ),

        SizedBox(height: 12.v),

        /// Items Card
        Container(
          padding: EdgeInsets.all(12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF6FBFF),
            borderRadius: BorderRadius.circular(12.h),
          ),
          child: Column(
            children: [
              _itemRow("Annual", "₹ 53,700"),
              _itemRow("Registration", "₹ 11,750", paid: true),
              _itemRow("Uniforms", "₹ 2,150", paid: true),
              _itemRow("Tuition", "₹ 16,900", paid: true),
            ],
          ),
        ),

        SizedBox(height: 14.v),

        /// No Payment Due
        Container(
          height: 44.v,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(22.h),
          ),
          child: Text(
            "No Payment Due",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        )
      ],
    );
  }

  Widget _buildHistoryList() {
    return ListView(
      shrinkWrap: true, // Necessary inside Column
      physics: const NeverScrollableScrollPhysics(), // Scroll handled by parent or just fit content
      padding: EdgeInsets.zero,
      children: [
        _historyItem("Tuition Fee - Term 1", "10 Aug 2025", "₹ 16,900", "Paid"),
        Divider(height: 16.v, color: const Color(0xFFF0F0F0)),
        _historyItem("Registration Fee", "01 Jun 2025", "₹ 11,750", "Paid"),
        Divider(height: 16.v, color: const Color(0xFFF0F0F0)),
        _historyItem("Uniforms", "25 May 2025", "₹ 2,150", "Paid"),
      ],
    );
  }

  Widget _historyItem(String title, String date, String amount, String status) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.v),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.fSize,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.v),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12.fSize,
                    fontFamily: 'Poppins',
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14.fSize,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.v),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12.fSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF22C55E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- COMPONENTS ----------------

  Widget _tabItem(String title, int index) {
    bool active = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.fSize,
              fontWeight: FontWeight.w500,
              color: active ? const Color(0xFF32B6F3) : Colors.grey, // Using sky blue
              fontFamily: 'Poppins',
            ),
          ),
          if (active) ...[
            SizedBox(height: 4.v),
            Container(
              height: 2.v,
              width: 20.h,
              color: const Color(0xFF32B6F3),
            )
          ]
        ],
      ),
    );
  }

  Widget _itemRow(String title, String amount, {bool paid = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.v),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: const Color(0xFF22C55E), size: 18.adaptSize),
          SizedBox(width: 8.h),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 14.fSize, fontFamily: 'Poppins', color: Colors.black),
            ),
          ),
          Text(
            amount,
            style: TextStyle(fontSize: 14.fSize, fontFamily: 'Poppins', color: Colors.black),
          ),
          if (paid) ...[
            SizedBox(width: 6.h),
            _paidChip(small: true),
          ]
        ],
      ),
    );
  }

  Widget _paidChip({bool small = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 10.h : 12.h,
        vertical: small ? 4.v : 6.v,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF22C55E),
        borderRadius: BorderRadius.circular(20.h),
      ),
      child: Text(
        "Paid",
        style: TextStyle(
          color: Colors.white,
          fontSize: small ? 12.fSize : 13.fSize,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.h),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4)),
      ],
    );
  }
}
