import 'dart:developer';
import 'dart:io';

import 'package:chat_koro/consts/consts.dart';
import '../../services/fiirestore_services.dart';
import '../home_screen/home_screen.dart';
import '../widgets/snackbar_common.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool animated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        animated = true;
      });
    });
  }

  _handleGoogleButton() {
    _signInWithGoogle().then((user) async {
      if (user != null) {
        // log('\nuser: ${user.user}');
        // log('\nuserAdditionalinfo${user.additionalUserInfo}');
        // log('\nuid:${FirebaseAuth.instance.currentUser!.uid}');

        if((await FireStoreServices.userExist())){
          Get.off(const HomeScreen(), transition: Transition.rightToLeft);
        }else{
          FireStoreServices.createUser().then((value) {
            Get.off(const HomeScreen(), transition: Transition.rightToLeft);
          });
        }

      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log(e.toString());
      Get.back();
      Dialogs.showSnackBar('Check internet', 'Error Connection',Icons.warning_amber_rounded);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: textfieldGrey,
      appBar: AppBar(
        title: "Welcome To Chat Koro".text.make(),
      ),
      // floatingActionButton: FloatingActionButton(onPressed: (){
      // log('\n 1uid:${currentUser!.uid}');
      //   log('\n 2uid:${FirebaseAuth.instance.currentUser!.uid}');
      // },child: "uid".text.make(),),
      body: Stack(
        children: [
          AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              top: context.screenHeight * .15,
              width: context.screenWidth * .5,
              right: animated
                  ? context.screenWidth * .25
                  : -context.screenWidth * 0.5,
              child: Image.asset(icLogin)),
          AnimatedPositioned(
              duration: const Duration(milliseconds: 750),
              top: context.screenHeight * .50,
              width: context.screenWidth * .5,
              right: animated
                  ? context.screenWidth * .25
                  : -context.screenWidth * 0.5,
              child: "To Continue"
                  .text
                  .color(darkFontGrey)
                  .fontFamily(semibold)
                  .size(20)
                  .makeCentered()),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1250),
            bottom: context.screenHeight * .15,
            left:
                animated ? context.screenWidth * .15 : context.screenWidth * 1,
            right: animated
                ? context.screenWidth * .15
                : -context.screenWidth * 0.5,
            height: context.screenHeight * .075,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: fontGrey, elevation: 2),
                onPressed: () {
                  _handleGoogleButton();
                   Dialogs.showProgressBar(context);
                },
                icon: Image.asset(
                  icGoogle,
                  height: context.screenHeight * 0.048,
                ),
                label: RichText(
                    text: const TextSpan(children: [
                  TextSpan(text: "LogIn With "),
                  TextSpan(
                      text: "Google",
                      style:
                          TextStyle(color: Colors.greenAccent, fontSize: 18)),
                ]))),
          ),
        ],
      ),
    );
  }
}
