import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _CourseDetailsVideoState extends State<CourseDetailsVideo>  with TickerProviderStateMixin {
  late final PodPlayerController controller;


  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(widget.path),
      podPlayerConfig: const PodPlayerConfig(
        videoQualityPriority: [720, 360],
        autoPlay: false,
      ),
    )..initialise().then((_) {
      setState(() {});
    });
    controller.addListener(() {
      if(controller.currentVideoPosition.inSeconds==5){
        widget.cubit.finishCourse(lessonId: widget.lessonId);
        print(controller.totalVideoLength);
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDetailsCubit, CourseDetailsStates>(
        builder: (context, state) {
          final cubit = BlocProvider.of<CourseDetailsCubit>(context);
          return  PodVideoPlayer(
            moveWidget: const SizedBox(),
            controller: controller,
            podProgressBarConfig:  PodProgressBarConfig(
              padding: kIsWeb
                  ? EdgeInsets.zero
                  : EdgeInsets.only(
                bottom: width*0.04,
                left: 20,
                right: 20,
              ),
              playingBarColor: Colors.blue,
              circleHandlerColor: Colors.blue,
              backgroundColor: Colors.blueGrey,
            ),

          );
        });
  }
}
