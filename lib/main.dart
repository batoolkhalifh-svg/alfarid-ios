import 'package:alfarid/screen/student/livestream/student_livestream_detail_page.dart';
import 'package:alfarid/screen/student/teacher_profile/view/widgets/student_selection_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/local/cache_helper.dart';
import 'core/utils/colors.dart';
import 'generated/codegen_loader.g.dart';
import 'screen/common/splash/splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as FireStore,
  // make   sure you call `initializeApp` before using other Firebase services.
  ///
  await Firebase.initializeApp();

  debugPrint("==================BackGround Message=======================  ");
  debugPrint("Handling a background message: ${message.messageId}");
  debugPrint("Handling a background message: ${message.notification!.body}");
}

 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.max,
);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  await CacheHelper.initCache();
  runApp(
    EasyLocalization(
      useOnlyLangCode: true,
      supportedLocales: const [Locale('en'), Locale('ar')],
      startLocale: const Locale('ar'),
      path: 'assets/translations',
      assetLoader: const CodegenLoader(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => StudentSelectionCubit()),
        ],
        child: const MyApp(),
      ),
    ),
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((event) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${event.notification!.body}');

    if (event.notification != null) {
      debugPrint('Message also contained a notification: ${event.notification!.body}');
    }
  });
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

}


final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///================================ request permission =========================//
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }
  ///================================ request permission =========================//
  ///================================ show local notification =========================//
  void initializeLocalNotification() {
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.

      if (android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification!.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                playSound: true,
                //  channelShowBadge: true,
                // other properties...
              ),
            )
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final data = message.data;
      print('Notification clicked, data: $data');

      String type = data['type']?.toString() ?? '';

      if (type == 'livestream') {
        // إشعار البث المباشر
        String livestreamId = data['livestream_id']?.toString() ?? '';
        String name = data['livestream_name']?.toString() ?? '';
        String date = data['livestream_date']?.toString() ?? '';
        String time = data['livestream_time']?.toString() ?? '';
        String? url = data['livestream_url']?.toString();

        // في حال كان url فارغ استخدم body كبديل مؤقت
        if (url == null || url.isEmpty) {
          url = data['body']?.toString();
        }

        print('Opening livestream: $livestreamId, url: $url');

        if (navigatorKey.currentContext != null) {
        //  Navigator.push(
           // navigatorKey.currentContext!,
         //   MaterialPageRoute(
             // builder: (_) => StudentLivestreamDetailPage(live: live),
          //  ),
       //   );
        }

      } else if (type == 'pay') {
        // إشعار الدفع
        String url = data['body']?.toString() ?? '';
        if (url.isNotEmpty) {
          launchUrl(Uri.parse(url));
        }

      } else {
        // إشعار عام
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null && navigatorKey.currentContext != null) {
          showDialog(
            context: navigatorKey.currentContext!,
            builder: (_) => AlertDialog(
              title: Text(notification.title ?? ''),
              content: Text(notification.body ?? ''),
            ),
          );
        }
      }
    });


  }
  ///================================ show local notification =========================//

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    initializeLocalNotification();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (_, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AlFarid',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        navigatorKey: navigatorKey,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(backgroundColor: AppColors.onBoardingBgColor),
            scaffoldBackgroundColor: AppColors.onBoardingBgColor
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
