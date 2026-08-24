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

class _ClassroomsScreenState extends State<ClassroomsScreen>
    with SingleTickerProviderStateMixin {
  List classrooms = [];
  bool isLoading = true;
  String error = '';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    fetchClassrooms();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
            item["type"] = null;
          }
        }

        List filtered = allClassrooms
            .where((item) => item["type"] != null && widget.types.contains(item["type"]))
            .toList();

        setState(() {
          classrooms = filtered;
          isLoading = false;
        });

        _animationController.forward();
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

  // ألوان راقية وهادئة لكل نوع صف
  LinearGradient getGradient(String type) {
    switch (type) {
      case "primary":
        return const LinearGradient(
            colors: [Color(0xFFEDF7FA), Color(0xFF1ca3c1)]); // أزرق كريمي
      case "secondary":
        return const LinearGradient(
            colors: [Color(0xFFFFF9EC), Color(0xFF1ca3c1)]); // ذهبي فاتح ناعم
      case "preparatory":
        return const LinearGradient(
            colors: [Color(0xFFE8F7F8), Color(0xFFCFF0F2)]); // كريمي أزرق هادئ
      case "private":
        return const LinearGradient(
            colors: [Color(0xFFF5EDF9), Color(0xFFa4caec)]); // بنفسجي فاتح ناعم
      case "uni":
        return const LinearGradient(
            colors: [Color(0xFFF4F0FA), Color(0xFFd3e4f4)]); // أرجواني خفيف
      default:
        return LinearGradient(
            colors: [Colors.grey.shade200, Colors.grey.shade300]);
    }
  }

  Widget buildClassroomCard(Map classroom, LinearGradient gradient, int index) {
    final animation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval((index / classrooms.length), 1.0, curve: Curves.easeOut)));

    return SlideTransition(
      position: animation,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TeachersScreen(classroom: classroom),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // مهم لتجنب overflow
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school,
                size: 36,
                color: Colors.blueGrey.shade700,
              ),
              const SizedBox(height: 12),
              Text(
                classroom['name'] ?? 'صف غير معروف',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 2.2, // أقل ارتفاع لتجنب overflow
      ),
      itemCount: classrooms.length,
      itemBuilder: (context, index) {
        final classroom = classrooms[index];
        final gradient = getGradient(classroom['type']);
        return buildClassroomCard(classroom, gradient, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error.isNotEmpty
            ? Center(child: Text(error))
            : classrooms.isEmpty
            ? const Center(child: Text('لا يوجد صفوف'))
            : buildGridView(),
      ),
    );
  }
}