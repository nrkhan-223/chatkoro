import 'dart:developer';

import 'package:chat_koro/services/fiirestore_services.dart';
import 'package:flutter/services.dart';

import '../../consts/consts.dart';
import '../auth_screen/login_screen.dart';
import '../home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    changeScreen();

  }

  changeScreen() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black));
      if(FireStoreServices.auth.currentUser!=null){
        log('\nuser: ${FireStoreServices.auth.currentUser}');
        Get.off(()=>const HomeScreen(),transition:Transition.rightToLeft );
      }else{
        Get.off(()=>const LoginScreen(),transition: Transition.rightToLeft);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: textfieldGrey));
    return Scaffold(
      backgroundColor: textfieldGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      ),
      body: Stack(
        children: [
          Positioned(
              top: context.screenHeight * .15,
              width: context.screenWidth * .5,
              right: context.screenWidth * .25,
              child: Image.asset(icAppLogo)),
          Positioned(
              bottom: context.screenHeight * .15,
              left: context.screenWidth * .15,
              right: context.screenWidth * .15,
              height: context.screenHeight * .075,
              child: "Hello"
                  .text
                  .color(darkFontGrey)
                  .fontFamily(semibold)
                  .size(25)
                  .makeCentered())
        ],
      ),
    );
  }
}
