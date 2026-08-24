import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/local/app_cached.dart';
import '../../../../../../core/local/cache_helper.dart';
import '../../../../../../core/widgets/custom_alert_dialogue.dart';
import '../../../../teacher_profile/view/teacher_profile_screen.dart';
import '../../controller/home_cubit.dart';
import '../../controller/home_states.dart';

class ExcellentTeacherItem extends StatelessWidget {
  final int index;
  const ExcellentTeacherItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        final teacher = cubit.dataTeacher[index];

        return GestureDetector(
          onTap: () {
            CacheHelper.getData(key: AppCached.token) == null
                ? showDialog(
              context: context,
              builder: (context) =>
              const CustomAlertDialog(),
            )
                : navigateTo(
              widget: TeacherProfileScreen(
                id: teacher.id!,
              ),
            );
          },
          child: Container(
            width: 165,
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                /// 👩‍🏫 صورة المعلم
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.08),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 38,
                      backgroundImage: NetworkImage(
                        teacher.image.toString(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                /// 👤 الاسم
                Text(
                  teacher.name.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                /// 📘 subtitle
                const Text(
                  "مدرس متميز",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const Spacer(),

                /// ⭐ التقييم
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.12),
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        teacher.rate.toString(),
                        style: const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}