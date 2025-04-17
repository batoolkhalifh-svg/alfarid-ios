import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PDFViewerScreen extends StatefulWidget {
  final String url;
  final String name;
  final String img;

  const PDFViewerScreen({super.key, required this.url, required this.name, required this.img});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? filePath;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    downloadAndOpenPDF();
  }

  Future<void> downloadAndOpenPDF() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/temp_book.pdf');

      final request = http.Request('GET', Uri.parse(widget.url));
      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        final contentLength = response.contentLength ?? 0;
        List<int> bytes = [];
        int downloaded = 0;

        response.stream.listen((List<int> newBytes) {
          bytes.addAll(newBytes);
          downloaded += newBytes.length;

          setState(() {
            progress = contentLength > 0 ? downloaded / contentLength : 0;
          });
        }, onDone: () async {
          await file.writeAsBytes(bytes);
          setState(() {
            filePath = file.path;
          });
        }, onError: (error) {
          print("❌ خطأ أثناء التحميل: $error");
        });
      } else {
        print("❌ فشل تحميل الملف");
      }
    } catch (e) {
      print("❌ خطأ: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (filePath != null) {
      final file = File(filePath!);
      if (file.existsSync()) {
        file.delete();
        print("✅ تم حذف الملف بنجاح");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: filePath == null
          ? Stack(
        children: [
          Positioned.fill(
            child: Image.network(widget.img, fit: BoxFit.cover),
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: LinearProgressIndicator(value: progress),
          ),
        ],
      )
          : PDFView(filePath: filePath!),
    );
  }
}
