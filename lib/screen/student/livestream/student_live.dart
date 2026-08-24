import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/local/app_cached.dart';
import '../../../core/local/cache_helper.dart';
import '../../common/auth/register_as/view/register_as_screen.dart';
import 'components/student_live_item.dart';
import 'controller/student_live_cubit.dart';

class StudentLive extends StatelessWidget {
  const StudentLive({super.key});

  // ⭐ البوكس الأزرق لتسجيل الدخول (تصميم فخم)
  Widget _buildLoginBox(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock, size: 50, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "يجب عليك تسجيل الدخول أولاً",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterASScreen()),
                  );
                },
                child: const Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    color: Color(0xFF357ABD),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentId = CacheHelper.getData(key: AppCached.id);

    // إذا الطالب غير مسجل → نعرض البوكس الأزرق
    if (studentId == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFEFEFF4),
        body: _buildLoginBox(context),
      );
    }

    // إذا مسجل → نستخدم Cubit كما هو مع تصميم فخم للقائمة
    return BlocProvider(
      create: (_) => StudentLiveCubit()..fetchStudentLives(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          title: const Text('البث المباشر'),
          backgroundColor: const Color(0xFF357ABD),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: BlocBuilder<StudentLiveCubit, StudentLiveStates>(
          builder: (context, state) {
            final cubit = BlocProvider.of<StudentLiveCubit>(context);
            if (state is GetStudentLivesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetStudentLivesError) {
              return Center(
                child: Text(
                  state.error,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (state is GetStudentLivesSuccess) {
              if (cubit.lives.isEmpty) {
                return const Center(
                  child: Text(
                    'لا يوجد بث مباشر الآن',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cubit.lives.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: StudentLiveItem(cubit: cubit, index: index),
                  );
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}