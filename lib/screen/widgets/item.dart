import 'package:chat_koro/consts/consts.dart';

Widget item(
  icon,
  String name,
  BuildContext context,
) {
  return Padding(
    padding: EdgeInsets.only(
        left: context.screenWidth * .05,
        top: context.screenHeight * 0.015,
        bottom: context.screenHeight * 0.018),
    child: Row(
      children: [
        icon,
        10.widthBox,
        name.text.size(16).color(darkFontGrey).make(),
      ],
    )
  );
}
