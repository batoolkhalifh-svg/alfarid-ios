import 'package:flutter/material.dart';
import '../../../../livestream/student_live.dart';
import '../../../../livestream/student_livestream_detail_page.dart';
import 'classrooms_screen.dart';

class HomeLists extends StatelessWidget {
  final int studentId;
  HomeLists({super.key,required this.studentId});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // رياض الأطفال → preparatory
            _buildStageCard(
              context,
              title: "رياض الأطفال",
              icon: Icons.child_friendly,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClassroomsScreen(
                      types: ["preparatory"],
                      title: "رياض الأطفال",
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // المدارس الحكومية → primary + secondary
            _buildStageCard(
              context,
              title: "المدارس الحكومية",
              icon: Icons.school,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClassroomsScreen(
                      types: ["primary", "secondary"],
                      title: "المدارس الحكومية",
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // المدارس الخاصة → private
            _buildStageCard(
              context,
              title: "المدارس الخاصة",
              icon: Icons.apartment,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClassroomsScreen(
                      types: ["private"],
                      title: "المدارس الخاصة",
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // الجامعات → university
            _buildStageCard(
              context,
              title: "التعليم الجامعي",
              icon: Icons.account_balance,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClassroomsScreen(
                      types: ["uni"],
                      title: "التعليم الجامعي",
                    ),
                  ),
                );
              },
            ),
// بعد بطاقة الجامعات، أضف SizedBox ثم بطاقة البث المباشر
            const SizedBox(height: 16),

        _buildStageCard(
          context,
          title: "تفاصيل البث المباشر",
          icon: Icons.live_tv,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudentLive(),
              ),
            );
          },
        ),


          ],
        ),
      ),
    );
  }

  Widget _buildStageCard(
      BuildContext context,
      {required String title,
        required IconData icon,
        required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 34, color: Colors.blueAccent),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
