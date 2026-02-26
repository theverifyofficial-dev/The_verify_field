import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfPreviewScreen extends StatefulWidget {
  final File pdfFile;
  const PdfPreviewScreen({super.key, required this.pdfFile});

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  late PdfControllerPinch _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfControllerPinch(
      document: PdfDocument.openFile(widget.pdfFile.path),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agreement Preview")),
      body: PdfViewPinch(
        controller: _pdfController,
      ),
    );
  }
}
