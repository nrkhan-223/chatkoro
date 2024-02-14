import '../../consts/consts.dart';

Widget commonButton({onPress, color, textColor, String? title,double? height,double?  width}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    onPressed: onPress,
    child: title!.text.size(15).color(textColor).bold.make(),
  ).box.width(width!).height(height!).rounded.make();
}
