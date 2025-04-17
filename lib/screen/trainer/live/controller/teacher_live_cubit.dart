import 'package:alfarid/core/widgets/custom_toast.dart';
import 'package:alfarid/screen/trainer/live/controller/teacher_live_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

import '../../../../core/local/app_cached.dart';
import '../../../../core/local/cache_helper.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../start_live/model/live_model.dart';

class TeacherLiveCubit extends Cubit<TeacherLiveStates> {
  TeacherLiveCubit() : super(TeacherLiveInitialState());

  static TeacherLiveCubit get(context) => BlocProvider.of(context);

  Map<dynamic, dynamic>? getLivesResponse;

  LivesModel? livesModel;


    int? currentLiveIndex;
  List<LivesModel> lives = [] ;
  List liveStatus = [] ;
  Future<void> getLives({required BuildContext ? context}) async {
    emit(GetLivesLoading());
    currentLiveIndex=null;
    lives.clear();
    liveStatus.clear();
    await FirebaseFirestore.instance.collection('lives').orderBy('date',descending: true).get().then((value) {
      value.docs.forEach((element) {
       if(element["user_id"].toString()== CacheHelper.getData(key: AppCached.id).toString()){
         lives.add(LivesModel(
           docName: element.id,
             liveName: element['live_name'],
             roomStudent: element['slug'],
             date: element['date'],
             time: element['time'],
             details: element['details'],
             link: element['link'],
             active: element['active'],
             finish: element['finished']
         ));
       } else{
         print("not my user");
       }
      });
      print(lives);
    });
    emit(GetLivesSuccess());
  }

  /// live time ... time of day
  /// current time ... time of day
  /// current date ... date time
  /// live date ... date time

  DateTime? liveDate;
  DateTime? dateNow;
  TimeOfDay? liveTime ;
  TimeOfDay? timeNow ;

  void onClick({required BuildContext context,required int index})async{
    currentLiveIndex=index;
    DateTime now = DateTime.now();
    dateNow = DateTime(now.year,now.month,now.day);
    liveDate = DateTime.parse(lives[index].date);
    timeNow = TimeOfDay.now();
    liveTime = TimeOfDay(hour:int.parse(lives[index].time.split(":")[0]),minute: int.parse(lives[index].time.split(":")[1]));
    if((dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour>=liveTime!.hour)&&(timeNow!.minute>=liveTime!.minute))&&(lives[index].finish==false))
    ||
    (dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour>=liveTime!.hour)&&(timeNow!.minute<liveTime!.minute))&&(lives[index].finish==false))){
      joinMeeting(roomText: lives[index].roomStudent!,context: context);
    }else if ((lives[index].active==false)&&(lives[index].finish==true)){
      showToast(text: LocaleKeys.broadcastCompleted.tr(), state: ToastStates.success);
    }else if ((dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour<=liveTime!.hour))&&(lives[index].finish==false))
        ||
        (dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour<=liveTime!.hour)&&(timeNow!.minute<=liveTime!.minute))&&(lives[index].finish==false))){
      showToast(text: LocaleKeys.momentsBroadcast.tr(), state: ToastStates.success);
    }else if (dateNow!.isBefore(liveDate!)&&(lives[index].finish==false)){
      showToast(text: LocaleKeys.notDay.tr(), state: ToastStates.success);
    }else if (dateNow!.isAfter(liveDate!)&& (lives[index].active==false)&&(lives[index].finish==false)){
      showToast(text: LocaleKeys.timeEndLive.tr(), state: ToastStates.success);

    }
  }

  String? text({required int index}){
    DateTime now = DateTime.now();
    dateNow = DateTime(now.year,now.month,now.day);
    liveDate = DateTime.parse(lives[index].date);
    timeNow = TimeOfDay.now();
    liveTime = TimeOfDay(hour:int.parse(lives[index].time.split(":")[0]),minute: int.parse(lives[index].time.split(":")[1]));

    if((dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour>=liveTime!.hour)&&(timeNow!.minute>=liveTime!.minute))&&(lives[index].finish==false))
        ||
        (dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour>=liveTime!.hour)&&(timeNow!.minute<liveTime!.minute))&&(lives[index].finish==false))) {
      return LocaleKeys.broadcastNow.tr();
    }else if ((lives[index].active==false)&&(lives[index].finish==true)){
      return LocaleKeys.broadcastCompleted.tr();
    }else if ((dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour<=liveTime!.hour))&&(lives[index].finish==false))
        ||
        (dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour<=liveTime!.hour)&&(timeNow!.minute<=liveTime!.minute))&&(lives[index].finish==false))){
      return LocaleKeys.momentsBroadcast.tr();
    }else if (dateNow!.isBefore(liveDate!)&&(lives[index].finish==false)){
      return LocaleKeys.notDay.tr();
    }else if (dateNow!.isAfter(liveDate!)&& (lives[index].active==false)&&(lives[index].finish==false)){
      return LocaleKeys.timeEndLive.tr();
    }

    return text(index: index);
  }

 joinMeeting({required String roomText, required BuildContext context}) async {
    Map<String, bool> featureFlags = {
      'isWelcomePageEnabled': false,
      'isAddPeopleEnabled': false,
      'isCalendarEnabled': false,
      'isCallIntegrationEnabled': false,
      'isChatEnabled': true,
      'isOverflowMenuEnabled' : true ,
      'areSecurityOptionsEnabled' : false ,
      'isAndroidScreensharingEnabled' : false ,
      'isAudioMuteButtonEnabled' : true ,
      'isAudioOnlyButtonEnabled' : true ,
      'isVideoMuteButtonEnabled' : true ,
      'isFilmstripEnabled' : true ,
      'isPipEnabled' : false ,
      'isReactionsEnabled' : false ,
      'isHelpButtonEnabled' : false ,
      'isReplaceParticipantEnabled' : true ,
      'isInviteEnabled': true,
      'isLiveStreamingEnabled': false,
      'isMeetingNameEnabled': false,
      'isMeetingPasswordEnabled': false,
      'isToolboxAlwaysVisible': true,
      'isCloseCaptionsEnabled': false,
      'isRecordingEnabled': true,
      'isIosRecordingEnabled': false,
      'isRaiseHandEnabled': false,
      'isTileViewEnabled': true,
      'isVideoShareButtonEnabled': false,
      'isToolboxEnabled': true,
      'isConferenceTimerEnabled': true,
      'isServerUrlChangeEnabled': false,
      'isIosScreensharingEnabled': false,
      'isKickoutEnabled': true,
      'isAudioFocusDisabled': false,
      'isFullscreenEnabled': true,
      'isLobbyModeEnabled': false,
      'isNotificationsEnabled': true,
    };


    // Define meetings options here
    // var options =  JitsiMeetConferenceOptions(
    //       room: roomText,
    //     // userDisplayName: CacheHelper.getData(key: AppCached.name).toString(),
    //     // userAvatarUrl:CacheHelper.getData(key: AppCached.image).toString(),
    //     // userEmail : CacheHelper.getData(key: AppCached.email).toString(),
    //     // isAudioOnly : false,
    //     // isAudioMuted : false,
    //     // isVideoMuted : false,
    //     // overflowMenuEnabled :true,
    //     featureFlags: featureFlags,
    // );

    var options = JitsiMeetConferenceOptions(
      serverURL: "https://meet.jit.si",
      room: roomText,
      configOverrides: {
        "startWithAudioMuted": false,
        "startWithVideoMuted": false,
        "subject" : "Jitsi with Flutter",
      },
      featureFlags: {
        "unsaferoomwarning.enabled": false
      },
      userInfo: JitsiMeetUserInfo(
          displayName: CacheHelper.getData(key: AppCached.name).toString(),
          email: CacheHelper.getData(key: AppCached.email).toString(),
        avatar: CacheHelper.getData(key: AppCached.image).toString()
      ),
    );


    debugPrint("JitsiMeetingOptions: $options");
    var jitsiMeet = JitsiMeet();

    await jitsiMeet.join(
       options,
       JitsiMeetEventListener(
         conferenceTerminated: (url, error) async{
           FirebaseFirestore.instance.collection('lives').doc(lives[currentLiveIndex!].docName).update({
             'active': false,
             'finished': true
           });
           debugPrint("Finished Yaa Teacher مبرووووووووووووووك $error");
           await getLives(context: context);
         },
         conferenceJoined: onConferenceJoined,
         participantJoined: (email, name, role, participantId) {
           debugPrint("participantJoined: email: $email, name: $name, role: $role, "
                 "participantId: $participantId",
           );
         },
         readyToClose: () {
           debugPrint("readyToClose");
         },
         audioMutedChanged:(isMuted) {
           debugPrint("onAudioMutedChanged: isMuted: $isMuted");
         },
        videoMutedChanged: (isMuted) {
         debugPrint("onVideoMutedChanged: isMuted: $isMuted");
       },
         screenShareToggled: (participantId, isSharing) {
           debugPrint(
             "onScreenShareToggled: participantId: $participantId, "
                 "isSharing: $isSharing",
           );
         },

        participantLeft: (participantId) {
          debugPrint("onParticipantLeft: participantId: $participantId");
        },
      ),
    );
  }

  Future onConferenceJoined(message) async{
    await FirebaseFirestore.instance.collection('lives').doc(lives[currentLiveIndex!].docName).update({
      'active': true,
      'finished': false
    });
    debugPrint("Joined Yaa Teacher مبروووووووووووووك $message");
  }
}

