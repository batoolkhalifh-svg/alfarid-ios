import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'TeachersScreen.dart';

class ClassroomsScreen extends StatefulWidget {
  final List<String> types;
  final String title;

  const ClassroomsScreen({super.key, required this.types, required this.title});

  @override
  State<ClassroomsScreen> createState() => _ClassroomsScreenState();
}

class _ClassroomsScreenState extends State<ClassroomsScreen> {
  List classrooms = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchClassrooms();
  }

  Future<void> fetchClassrooms() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final response = await http.get(Uri.parse('https://app.alfarid.info/api/classrooms'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List allClassrooms = data['data'];

        // تعيين نوع كل صف حسب الـ ID إذا الـ API لا يُرجع type
        for (var item in allClassrooms) {
          if (item["id"] >= 1 && item["id"] <= 10) {
            item["type"] = "primary";
          } else if (item["id"] == 11 || item["id"] == 12) {
            item["type"] = "secondary";
          } else if (item["id"] == 13 || item["id"] == 14) {
            item["type"] = "preparatory";
          } else if (item["id"] >= 16 && item["id"] <= 27) {
            item["type"] = "private";
          } else if (item["id"] >= 28 && item["id"] <= 33) {
            item["type"] = "uni";
          } else {
            item["type"] = null; // أي صف آخر
          }
        }

        // تصفية الصفوف حسب الـ types المرسلة
        List filtered = allClassrooms
            .where((item) => item["type"] != null && widget.types.contains(item["type"]))
            .toList();

        setState(() {
          classrooms = filtered;
          isLoading = false;
        });

        debugPrint('All classrooms: $allClassrooms');
        debugPrint('Filtered classrooms: $filtered');
      } else {
        setState(() {
          error = 'Failed to load classrooms: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching classrooms: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : classrooms.isEmpty
          ? const Center(child: Text('لا يوجد صفوف'))
          : ListView.builder(
        itemCount: classrooms.length,
        itemBuilder: (context, index) {
          final classroom = classrooms[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(classroom['name'] ?? 'صف غير معروف'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TeachersScreen(classroom: classroom),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
