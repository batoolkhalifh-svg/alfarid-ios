import 'dart:convert';
import 'package:alfarid/screen/common/auth/login/controller/login_cubit.dart';
import 'package:alfarid/screen/common/auth/register_as/view/register_as_screen.dart';
import 'package:alfarid/screen/common/on_boarding/view/widgets/on_boarding_body.dart';
import 'package:flutter/material.dart';
import 'package:alfarid/core/local/cache_helper.dart';
import 'package:alfarid/core/local/app_cached.dart';
import 'package:alfarid/core/utils/images.dart';
import 'package:http/http.dart' as http;
import '../../../../../common/auth/login/view/login_screen.dart';
import '../../../../teacher_profile/view/teacher_profile_screen.dart';

class TeachersScreen extends StatelessWidget {
  final Map classroom; // بيانات الصف المختار

  const TeachersScreen({super.key, required this.classroom});

  // دالة لجلب المعلمين من API
  Future<List<Map<String, dynamic>>> fetchTeachers() async {
    final classroomId = classroom["id"];
    final classType = classroom['type'];
    final url =
        "https://app.alfarid.info/api/teachers/by-classroom/$classroomId?type=$classType";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Map<String, dynamic>> fetchedTeachers =
          (data['data'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
              [];
      return fetchedTeachers;
    } else {
      throw Exception("خطأ في جلب المعلمين: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = CacheHelper.getData(key: AppCached.token);

    return Scaffold(
      appBar: AppBar(
        title: Text(classroom['name'] ?? 'صف غير معروف'),
      ),

      // ⛔ إذا المستخدم غير مسجل دخول → أظهر مربع تسجيل الدخول
      body: token == null
          ? _buildLoginBox(context)
          : FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTeachers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("لا يوجد معلمين لهذا الصف"));
          } else {
            final teachers = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 16),
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                final t = teachers[index];

                final courses = t['subject'] as List<dynamic>? ?? [];
                final courseNames = courses
                    .map((c) => c['subject']?['name_ar'] ?? '')
                    .where((name) => name.isNotEmpty)
                    .toSet()
                    .toList();

                ImageProvider teacherImage;
                if (t["image"] != null &&
                    t["image"].toString().isNotEmpty) {
                  final imgStr = t["image"].toString();
                  if (imgStr.startsWith("http")) {
                    teacherImage = NetworkImage(imgStr);
                  } else {
                    teacherImage = NetworkImage(
                        "https://app.alfarid.info/storage/$imgStr");
                  }
                } else {
                  teacherImage =
                  const AssetImage("assets/images/no_image.png");
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TeacherProfileScreen(id: t["id"],classroomType: classroom['type'],),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: teacherImage,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t["name"] ?? "",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              courseNames.isNotEmpty
                                  ? Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: courseNames.map((name) {
                                  return Container(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius:
                                      BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors
                                              .blue.shade800),
                                    ),
                                  );
                                }).toList(),
                              )
                                  : const Text(
                                "لا توجد مواد",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          children: [
                            Text(t["rate"]?.toString() ?? "0"),
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),

      backgroundColor: Colors.grey[200],
    );
  }

  // ⭐ مربع تسجيل الدخول القديم (نفس التصميم)
  Widget _buildLoginBox(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(22),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
      //      Image.asset(AppImages.logo, width: 160),
            const SizedBox(height: 20),
            const Text(
              "يجب عليك تسجيل الدخول أولاً",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            // زر تسجيل الدخول
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterASScreen()), // ← غيري الاسم حسب صفحتك
                  );

                },
                child: const Text(
                  "تسجيل الدخول",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
