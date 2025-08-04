import 'package:alfarid/core/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/images.dart';
import '../../../../core/utils/size.dart';
import '../../../../core/widgets/custom_btn.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controller/teacher_live_cubit.dart';

class LiveItem extends StatefulWidget {
  final TeacherLiveCubit cubit;
  final int index;
  const LiveItem({Key? key, required this.cubit, required this.index})
      : super(key: key);

  @override
  State<LiveItem> createState() => _LiveItemState();
}

class _LiveItemState extends State<LiveItem> {
  @override
  void initState() {
    // TODO: implement initState
    // JitsiMeet.addListener(JitsiMeetingListener(
    //     onConferenceWillJoin: widget.cubit.onConferenceWillJoin,
    //     onConferenceJoined: widget.cubit.onConferenceJoined,
    //     onConferenceTerminated: widget.cubit.onConferenceTerminated,
    //     onError: widget.cubit.inError));
    // widget.cubit.text(index: widget.index);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: const Offset(0, 0.2),
                  )
                ]),
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: width * 0.04),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 9.h),
                    child: InkWell(
                      onTap: ()=>Clipboard.setData(ClipboardData(text: widget.cubit.lives[widget.index].link)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(LocaleKeys.copy.tr(),style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold,color: AppColors.mainColor)),
                          const Icon(Icons.copy,color: AppColors.mainColor,)
                        ],
                      ),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: width * 0.45,
                            child: Text(widget.cubit.lives[widget.index].liveName!)),
                        Row(children: [
                          SvgPicture.asset(AppImages.lives,width: width*0.07,),
                          SizedBox(width: width * 0.015),
                          Text(LocaleKeys.lives.tr())
                        ])
                      ]),
                  SizedBox(height: height * 0.03),
                  Text(widget.cubit.lives[widget.index].details),
                  SizedBox(height: height * 0.02),
                  Row(children: [
                    SvgPicture.asset(AppImages.clock),
                    SizedBox(width: width * 0.01),
                    Text(widget.cubit.lives[widget.index].date),
                    const Spacer(),
                    SvgPicture.asset(AppImages.clock),
                    SizedBox(width: width * 0.01),
                    Text(widget.cubit.lives[widget.index].time)
                  ]),
                  SizedBox(height: height * 0.02),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: width * 0.06),
                    child: CustomButton(
                      onPressed: () async {
                        widget.cubit.onClick(context: context, index: widget.index);
                      }, widthBtn: width*0.9, text:widget.cubit.text(index: widget.index).toString(),
                    ),
                  )
                ]))));
  }
}
