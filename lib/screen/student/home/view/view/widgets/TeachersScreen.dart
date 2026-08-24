import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:alfarid/core/local/cache_helper.dart';
import 'package:alfarid/core/local/app_cached.dart';
import 'package:alfarid/screen/common/auth/register_as/view/register_as_screen.dart';
import '../../../../teacher_profile/view/teacher_profile_screen.dart';

class TeachersScreen extends StatelessWidget {
  final Map classroom;

  const TeachersScreen({
    super.key,
    required this.classroom,
  });

  Future<List<Map<String, dynamic>>> fetchTeachers() async {
    final classroomId = classroom["id"];
    final classType = classroom['type'];

    final url =
        "https://app.alfarid.info/api/teachers/by-classroom/$classroomId?type=$classType";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return (data['data'] as List<dynamic>?)
          ?.map((e) => Map<String, dynamic>.from(e))
          .toList() ??
          [];
    } else {
      throw Exception("خطأ في جلب المعلمين");
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = CacheHelper.getData(key: AppCached.token);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          classroom['name'] ?? 'المعلمين',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      body: token == null
          ? _buildLoginBox(context)
          : FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTeachers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("حدث خطأ"),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text("لا يوجد معلمين"),
            );
          }

          final teachers = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final t = teachers[index];

              final courses =
                  t['subject'] as List<dynamic>? ?? [];

              final List<String> courseNames = courses
                  .map<String>((c) => c['subject']?['name_ar']?.toString() ?? '')
                  .where((name) => name.isNotEmpty)
                  .toSet()
                  .toList();

              ImageProvider teacherImage;

              if (t["image"] != null &&
                  t["image"]
                      .toString()
                      .isNotEmpty) {
                final imgStr =
                t["image"].toString();

                if (imgStr.startsWith("http")) {
                  teacherImage =
                      NetworkImage(imgStr);
                } else {
                  teacherImage = NetworkImage(
                    "https://app.alfarid.info/storage/$imgStr",
                  );
                }
              } else {
                teacherImage = const AssetImage(
                  "assets/images/no_image.png",
                );
              }

              return _teacherCard(
                t: t,
                courseNames: courseNames,
                image: teacherImage,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TeacherProfileScreen(
                            id: t["id"],
                            classroomType:
                            classroom['type'],
                          ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  /// 💎 الكرت الفخم
  Widget _teacherCard({
    required Map<String, dynamic> t,
    required List<String> courseNames,
    required ImageProvider image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Colors.white,
              Color(0xFFF9FCFD),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.black.withOpacity(0.04),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [

            /// 👩‍🏫 صورة مع Glow
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0089A6)
                        .withOpacity(0.25),
                    blurRadius: 15,
                  )
                ],
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundImage: image,
              ),
            ),

            const SizedBox(width: 14),

            /// 📚 المعلومات
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    t["name"] ?? "",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "مدرس معتمد",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (courseNames.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: courseNames
                          .take(2)
                          .map((name) {
                        return Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(
                                  0xFF0089A6,
                                ).withOpacity(0.12),
                                const Color(
                                  0xFF0089A6,
                                ).withOpacity(0.05),
                              ],
                            ),
                            borderRadius:
                            BorderRadius.circular(
                                12),
                          ),
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 12,
                              color:
                              Color(0xFF0089A6),
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),

            /// ➜ سهم
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0089A6)
                    .withOpacity(0.08),
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFF0089A6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔐 تسجيل الدخول
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
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "يجب عليك تسجيل الدخول أولاً",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF0089A6),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const RegisterASScreen(),
                  ),
                );
              },
              child: const Text(
                "تسجيل الدخول",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}