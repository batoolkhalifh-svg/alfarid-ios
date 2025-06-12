import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pod_player/pod_player.dart';

import '../../../../../core/utils/size.dart';
import '../../controller/course_details_cubit.dart';

class CourseDetailsVideo extends StatefulWidget {
  final String path;
  final CourseDetailsCubit cubit;
  final int lessonId;

  const CourseDetailsVideo({super.key, required this.path, required this.cubit, required this.lessonId});

  @override
  State<CourseDetailsVideo> createState() => _CourseDetailsVideoState();
}

class _CourseDetailsVideoState extends State<CourseDetailsVideo> with TickerProviderStateMixin {
  PodPlayerController? controller;
  bool callApi = false;

  @override
  void initState() {
    super.initState();
    initController();
  }

  Future<void> initController() async {
    setState(() {
      callApi = true;
    });
    if (controller != null) {
      controller!.dispose();
    }

    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(widget.path),
      podPlayerConfig: const PodPlayerConfig(
        videoQualityPriority: [720, 360],
        autoPlay: true,
      ),
    );

    try {
      await controller!.initialise();
      if (mounted) {
        setState(() {});
      }

      controller!.addListener(() {
        if (controller == null) return;
        if (controller!.isVideoPlaying && controller!.currentVideoPosition.inSeconds >= 5 && callApi) {
          widget.cubit.finishCourse(lessonId: widget.lessonId).then(
                (value) => setState(() {
                  callApi = false;
                }),
              );
        }
      });
    } catch (e) {
      debugPrint("Failed to load video: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("فشل تحميل الفيديو، تأكد من الاتصال أو سلامة الرابط")),
        );
      }
    }
  }

  @override
  void didUpdateWidget(covariant CourseDetailsVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      controller?.dispose();
      initController();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controller == null || !controller!.isInitialised
        ? SizedBox(
            height: 130.h,
            child: const Center(child: CircularProgressIndicator()),
          )
        : PodVideoPlayer(
            controller: controller!,
            podProgressBarConfig: PodProgressBarConfig(
              padding: kIsWeb
                  ? EdgeInsets.zero
                  : EdgeInsets.only(
                      bottom: width * 0.04,
                      left: 20,
                      right: 20,
                    ),
              playingBarColor: Colors.blue,
              circleHandlerColor: Colors.blue,
              backgroundColor: Colors.blueGrey,
            ),
          );
  }
}
