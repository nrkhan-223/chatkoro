import 'package:chat_koro/screen/splash_screen/splash_screen.dart';
import 'package:chat_koro/services/notification_apis.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chat_koro/consts/consts.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    NotificationApi.notificationChannel();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chat Koro",
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: fontGrey),
            backgroundColor: fontGrey,
            elevation: 0.0,
            centerTitle: true,
            titleTextStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400, fontSize: 19),
            iconTheme: IconThemeData(color: Colors.white)),
      ),
      home: const SplashScreen(),
    );
  }
}
