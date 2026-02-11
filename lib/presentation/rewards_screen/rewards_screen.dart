import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return const RewardsScreen();
  }

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _selectedTab = 0; // 0: Offers, 1: Claimed Offers

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
              SizedBox(height: 12.v),
              _tabBar(),
              SizedBox(height: 24.v),
              Expanded(
                child: _selectedTab == 0 ? _buildOffersView() : _buildClaimedView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            "Rewards",
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

  Widget _tabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _tabItem("Offers", 0),
          _tabItem("Claimed offers", 1),
        ],
      ),
    );
  }

  Widget _tabItem(String text, int index) {
    bool selected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.v),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF32B6F3) : Colors.transparent,
            borderRadius: BorderRadius.circular(30.h),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 14.fSize,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOffersView() {
    return Column(
      children: [
        _categoryChips(),
        SizedBox(height: 16.v),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 48.v, top: 0),
            children: [
              RewardCard(
                title: "GIVA Jewellery",
                description: "Get ₹300 OFF on a minimum purchase of ₹999/-",
                imagePath: ImageConstant.imgRewardGiva, // Make sure these constants exist or use placeholders
              ),
              RewardCard(
                title: "St.Botanica",
                description: "40% off on St.Botanica",
                imagePath: ImageConstant.imgRewardStBotanica, // Make sure these constants exist or use placeholders
              ),
              RewardCard(
                title: "Moms Co",
                description: "Get 40% off on The Moms Co products",
                imagePath: ImageConstant.imgRewardMomsCo, // Make sure these constants exist or use placeholders
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClaimedView() {
    return ListView(
      padding: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 48.v, top: 0),
      children: [
        _buildClaimedCard(
          title: "Firstcry",
          description: "Flat 35% OFF on Order Above ₹1500",
          code: "FCRY35OFF",
          imagePath: ImageConstant.imgRewardMomsCo, // Using Moms Co as placeholder until Firstcry asset is added
          expiry: "Expires in 2 days",
        ),
        _buildClaimedCard(
          title: "Hopscotch",
          description: "Extra 10% OFF on Kids Wear",
          code: "HOP10",
          imagePath: ImageConstant.imgRewardMomsCo, // Reusing existing image for demo if needed
          expiry: "Expires on 30 Sep",
        ),
      ],
    );
  }

  Widget _categoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Row(
        children: [
          CategoryChip(text: "All", iconPath: ImageConstant.imgIconApps, selected: true),
          CategoryChip(text: "Shopping", iconPath: ImageConstant.imgIconShopping),
          CategoryChip(text: "Wellness", iconPath: ImageConstant.imgIconWellness),
        ],
      ),
    );
  }

  Widget _buildClaimedCard({
    required String title,
    required String description,
    required String code,
    required String imagePath,
    required String expiry,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.v),
      padding: EdgeInsets.all(12.h),
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.h),
                child: CustomImageView(
                  imagePath: imagePath,
                  height: 80.adaptSize, // Smaller for claimed list maybe? Or keep standard size. Let's keep distinct.
                  width: 80.adaptSize,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.fSize,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.v),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13.fSize,
                        fontFamily: 'Poppins',
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.v),
                    Text(
                      expiry,
                      style: TextStyle(
                        fontSize: 12.fSize,
                        fontFamily: 'Poppins',
                        color: Colors.redAccent, // Red for expiry urgency
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.v),
          // Code Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.v),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4), // Light green bg
              borderRadius: BorderRadius.circular(8.h),
              border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Coupon Code",
                      style: TextStyle(
                        fontSize: 10.fSize,
                        color: Colors.grey[600],
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      code,
                      style: TextStyle(
                        fontSize: 16.fSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF15803D), // Dark green text
                        fontFamily: 'Poppins',
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    // Implement copy logic if needed via Clipboard
                  },
                  icon: Icon(Icons.copy, size: 16.adaptSize, color: const Color(0xFF22C55E)),
                  label: Text(
                    "Copy",
                    style: TextStyle(
                      color: const Color(0xFF22C55E),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------ REUSABLE CARD ------------------

class RewardCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath; // Changed from imageUrl to imagePath

  const RewardCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.v),
      padding: EdgeInsets.all(12.h),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.h),
            child: CustomImageView( // Use CustomImageView for local assets
              imagePath: imagePath,
              height: 120.adaptSize,
              width: 120.adaptSize,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.fSize,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.v),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13.fSize,
                    fontFamily: 'Poppins',
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.v),
                SizedBox(
                  height: 28.v,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF32B6F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.h),
                      minimumSize: Size(0, 28.v), // Hug content width
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Claim",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.fSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------ CHIP ------------------

class CategoryChip extends StatelessWidget {
  final String text;
  final String? iconPath; // Changed from IconData to String path
  final bool selected;

  const CategoryChip({
    Key? key,
    required this.text,
    this.iconPath,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF32B6F3) : Colors.white,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPath != null) ...[
            CustomImageView(
              imagePath: iconPath,
              height: 16.adaptSize,
              width: 16.adaptSize,
              color: selected ? Colors.white : const Color(0xFFFF2D7A),
            ),
            SizedBox(width: 6.h),
          ],
          Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 13.fSize,
            ),
          ),
        ],
      ),
    );
  }
}
