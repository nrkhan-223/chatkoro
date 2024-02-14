import 'package:chat_koro/consts/consts.dart';

class Dialogs {
  static void showSnackBar(String msg, String title,icon ) {
    Get.snackbar(title, msg,
        colorText: Colors.deepPurpleAccent,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white70,
        barBlur: 2,
        icon: Icon(
         icon,
          color: Colors.red,
        ));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurpleAccent,
            ),
          );
        });
  }
}
