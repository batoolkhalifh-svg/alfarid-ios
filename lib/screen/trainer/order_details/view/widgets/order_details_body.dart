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

class OrderDetailsBody extends StatelessWidget {
  final int id;

  const OrderDetailsBody({super.key, required this.id});

  // 🌟 دالة فتح الرابط في المتصفح الخارجي
  Future<void> openLink(String url, BuildContext context) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.platformDefault, // يفتح المتصفح الافتراضي
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن فتح الرابط')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<OrderDetailsCubit>(
        create: (context) => OrderDetailsCubit()..fetchOrderDetails(id: id),
        child: BlocBuilder<OrderDetailsCubit, BaseStates>(
          builder: (context, state) {
            var cubit = OrderDetailsCubit.get(context);

            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomArrow(text: LocaleKeys.requestDetails.tr()),
                  state is BaseStatesLoadingState
                      ? Padding(
                    padding: EdgeInsets.only(top: width * 0.35),
                    child: const CustomLoading(fullScreen: true),
                  )
                      : state is BaseStatesErrorState
                      ? CustomError(
                    title: state.msg,
                    onPressed: () {
                      cubit.fetchOrderDetails(id: id);
                    },
                  )
                      : Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.07,
                        vertical: width * 0.03,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: width * 0.06),
                        width: width * 0.86,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // صورة واسم الطالب
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                cubit.orderDetailsModel!.data!.student!.image ?? '',
                              ),
                            ),
                            SizedBox(height: width * 0.01),
                            Text(
                              cubit.orderDetailsModel!.data!.student!.name ?? '',
                              style: Styles.textStyle14.copyWith(color: AppColors.mainColor),
                            ),
                            SizedBox(height: width * 0.01),
                            Text(
                              cubit.orderDetailsModel!.data!.student!.classroom ?? '',
                              style: Styles.textStyle12.copyWith(
                                color: AppColors.blackColor2,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: width * 0.02),

                            // التاريخ
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.date_range, color: AppColors.mainColor2),
                                SizedBox(width: 5),
                                Text(
                                  cubit.orderDetailsModel!.data!.date ?? '',
                                  style: Styles.textStyle12.copyWith(fontFamily: 'Mulish'),
                                ),
                              ],
                            ),
                            SizedBox(height: width * 0.02),

                            // الوقت
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 9.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      '${LocaleKeys.from.tr()}  ${cubit.orderDetailsModel!.data!.slots.isNotEmpty ? cubit.orderDetailsModel!.data!.slots.first.timeFrom ?? '-' : '-'}'),
                                  Text(
                                      '${LocaleKeys.to.tr()}  ${cubit.orderDetailsModel!.data!.slots.isNotEmpty ? cubit.orderDetailsModel!.data!.slots.first.timeTo ?? '-' : '-'}'),
                                ],
                              ),
                            ),

                            // الأيام
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: cubit.daysList.isNotEmpty
                                  ? cubit.daysList.map((e) => Text(e.day)).toList()
                                  : [],
                            ),
                            SizedBox(height: width * 0.04),

                            // حالة الدفع
                            Text(
                              cubit.orderDetailsModel!.data!.paymentStatus == "paid"
                                  ? "مقبول"
                                  : "قيد الانتظار",
                              style: Styles.textStyle14.copyWith(
                                color: cubit.orderDetailsModel!.data!.paymentStatus == "paid"
                                    ? AppColors.mainColor2
                                    : AppColors.mainColor,
                              ),
                            ),
                            SizedBox(height: width * 0.04),

                            // عرض الملفات المرفوعة لكل يوم
                            if (cubit.orderDetailsModel!.data!.uploadedFiles.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: cubit.orderDetailsModel!.data!.uploadedFiles.entries.map((entry) {
                                  String day = entry.key;
                                  List<String> files = entry.value;

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$day : المواد المرفوعة',
                                        style: Styles.textStyle14.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: files.map<Widget>((file) {
                                          return InkWell(
                                            onTap: () => openLink('https://app.alfarid.info/$file', context),
                                            child: Text(
                                              "📎 ${file.split('/').last}",
                                              style: const TextStyle(color: Colors.blue),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      SizedBox(height: width * 0.03),
                                    ],
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
