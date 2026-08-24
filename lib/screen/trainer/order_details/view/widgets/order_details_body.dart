import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:alfarid/screen/trainer/home_teacher/view/widgets/custom_blue_btn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../controller/order_details_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';


class OrderDetailsBody extends StatelessWidget {
  final int id;

  const OrderDetailsBody({super.key, required this.id});

  Future<void> openLink(String url, BuildContext context) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن فتح الرابط')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: BlocProvider(
        create: (context) => OrderDetailsCubit()..fetchOrderDetails(id: id),
        child: BlocBuilder<OrderDetailsCubit, BaseStates>(
          builder: (context, state) {
            var cubit = OrderDetailsCubit.get(context);

            if (state is BaseStatesLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BaseStatesErrorState) {
              return Center(child: Text(state.msg));
            }

            final data = cubit.orderDetailsModel!.data!;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    /// 🔥 CARD الرئيسي
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.9),
                            Colors.white.withOpacity(0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        children: [

                          /// 👤 صورة + اسم
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                                data.student!.image ?? ''),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            data.student!.name ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            data.student!.classroom ?? '',
                            style: const TextStyle(
                                color: Colors.grey),
                          ),

                          const SizedBox(height: 15),

                          /// 🟢 الحالة
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: data.paymentStatus == "paid"
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              data.paymentStatus == "paid"
                                  ? "مقبول"
                                  : "قيد الانتظار",
                              style: TextStyle(
                                color: data.paymentStatus == "paid"
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// 📅 التاريخ والوقت
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              _infoItem(Icons.date_range, data.date ?? ''),
                              _infoItem(Icons.access_time,
                                  "${data.slots.first.timeFrom} - ${data.slots.first.timeTo}"),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// 📌 الأيام (chips)
                          Wrap(
                            spacing: 8,
                            children: cubit.daysList
                                .map((e) => Chip(
                              label: Text(e.day),
                              backgroundColor:
                              Colors.blue.withOpacity(0.1),
                            ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 📂 الملفات
                    if (data.uploadedFiles.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 15,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              "📂 الملفات المرفوعة",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),

                            const SizedBox(height: 10),

                            ...data.uploadedFiles.entries.map((entry) {
                              return Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    entry.key,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),

                                  ...entry.value.map((file) {
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(Icons.insert_drive_file),
                                      title: Text(file.split('/').last),
                                      trailing: const Icon(Icons.open_in_new),
                                      onTap: () => openLink(
                                          'https://app.alfarid.info/$file',
                                          context),
                                    );
                                  }),

                                  const Divider(),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blue),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}