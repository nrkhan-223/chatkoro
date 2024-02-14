import 'package:flutter/services.dart';

import '../../consts/consts.dart';
import '../../services/chat_apis.dart';
import 'common_button.dart';

Widget exitDialog(context) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "CONFIRM".text.bold.size(18).color(darkFontGrey).make(),
        const Divider(
          thickness: 2,
        ),
        "Do you want to Exit?".text.bold.size(16).color(darkFontGrey).make(),
        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            commonButton(
                color: fontGrey,
                textColor: whiteColor,
                title: "Yes",
                height: 35,
                width: 70,
                onPress: () {
                  ChatApis.updateActiveStatus(false);
                  SystemNavigator.pop();
                }),
            commonButton(
                color: fontGrey,
                textColor: whiteColor,
                height: 35,
                width: 70,
                title: "no",
                onPress: () {
                  Navigator.pop(context);
                }),
          ],
        )
      ],
    )
        .box
        .color(textfieldGrey)
        .padding(const EdgeInsets.all(10))
        .roundedSM
        .make(),
  );
}
