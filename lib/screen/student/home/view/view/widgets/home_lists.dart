import 'package:flutter/material.dart';
import '../../../../livestream/student_live.dart';
import '../../../../livestream/student_livestream_detail_page.dart';
import 'classrooms_screen.dart';

class HomeLists extends StatelessWidget {
  final int studentId;
  const HomeLists({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "title": "رياض الأطفال",
        "icon": Icons.child_friendly,
        "types": ["preparatory"],
      },
      {
        "title": "المدارس الحكومية",
        "icon": Icons.school,
        "types": ["primary", "secondary"],
      },
      {
        "title": "المدارس الخاصة",
        "icon": Icons.apartment,
        "types": ["private"],
      },
      {
        "title": "التعليم الجامعي",
        "icon": Icons.account_balance,
        "types": ["uni"],
      },
      {
        "title": "البث المباشر",
        "icon": Icons.live_tv,
        "isLive": true,
      },
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🏷️ عنوان
            const Text(
              "الأقسام",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// 💎 Grid فاخر
        GridView.builder(
          itemCount: items.length,
          shrinkWrap: true, // مهم لتجنب overflow
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.95, // أقل ارتفاع لتجنب overflow
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return _luxuryCard(
              context,
              title: item["title"],
              icon: item["icon"],
              isLive: item["isLive"] == true,
              onTap: () {
                if (item["isLive"] == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => StudentLive()),
                  );
                } else {
                  final types = item["types"] ?? [];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClassroomsScreen(
                        types: List<String>.from(types),
                        title: item["title"],
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
          ],
        ),
      ),
    );
  }

  /// 💎 Luxury Card
  Widget _luxuryCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required VoidCallback onTap,
        bool isLive = false,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 25,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔴 Live Badge
            if (isLive)
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "LIVE",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),

            const Spacer(),

            /// 🧠 Icon
            Icon(icon, size: 26, color: Colors.black87),

            const SizedBox(height: 8),

            /// 📝 Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}