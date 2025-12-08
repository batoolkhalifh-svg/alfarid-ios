import 'package:flutter/material.dart';

class StudentLivestreamDetailPage extends StatelessWidget {
  final int id;
  final String name;
  final String date;
  final String time;
  final String? url; // أصبح اختياري

  const StudentLivestreamDetailPage({
    super.key,
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("اسم البث: $name", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("التاريخ: $date", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("الوقت: $time", style: const TextStyle(fontSize: 16)),
            if (url != null) ...[
              const SizedBox(height: 16),
              Text("رابط البث: $url", style: const TextStyle(fontSize: 16, color: Colors.blue)),
            ],
          ],
        ),
      ),
    );
  }
}
