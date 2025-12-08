import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/local/app_cached.dart';
import '../../../core/local/cache_helper.dart';
import '../../common/auth/register_as/view/register_as_screen.dart';
import 'components/student_live_item.dart';
import 'controller/student_live_cubit.dart';


class StudentLive extends StatelessWidget {
  const StudentLive({super.key});

  // ⭐ البوكس الأزرق لتسجيل الدخول
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
            const SizedBox(height: 20),
            const Text(
              "يجب عليك تسجيل الدخول أولاً",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
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
                    MaterialPageRoute(builder: (_) => const RegisterASScreen()),
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

  @override
  Widget build(BuildContext context) {
    final studentId = CacheHelper.getData(key: AppCached.id);

    // إذا الطالب غير مسجل → نعرض البوكس الأزرق
    if (studentId == null) {
      return Scaffold(
        body: _buildLoginBox(context),
      );
    }

    // إذا مسجل → نستخدم Cubit كما هو
    return BlocProvider(
      create: (_) => StudentLiveCubit()..fetchStudentLives(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('البث المباشر')),
        body: BlocBuilder<StudentLiveCubit, StudentLiveStates>(
          builder: (context, state) {
            final cubit = BlocProvider.of<StudentLiveCubit>(context);
            if (state is GetStudentLivesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetStudentLivesError) {
              return Center(child: Text(state.error));
            } else if (state is GetStudentLivesSuccess) {
              if (cubit.lives.isEmpty) {
                return const Center(child: Text('لا يوجد بث مباشر الآن'));
              }
              return ListView.builder(
                itemCount: cubit.lives.length,
                itemBuilder: (context, index) =>
                    StudentLiveItem(cubit: cubit, index: index),
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
