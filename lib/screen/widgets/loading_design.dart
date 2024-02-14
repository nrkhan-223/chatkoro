import 'package:chat_koro/consts/consts.dart';

Widget loadingIndicator(){
  return const Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(redColor),
    ),
  );
}