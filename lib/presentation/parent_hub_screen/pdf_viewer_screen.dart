import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../core/app_export.dart';

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;
  final String title;

  const PDFViewerScreen({Key? key, required this.pdfPath, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.adaptSize, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20.fSize,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SfPdfViewer.asset(
        pdfPath,
        canShowScrollHead: false, 
        canShowScrollStatus: false,
      ),
    );
  }
}
