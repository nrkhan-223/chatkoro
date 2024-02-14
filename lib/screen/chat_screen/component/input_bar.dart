import 'package:chat_koro/models/chat_users_model.dart';
import 'package:chat_koro/services/chat_apis.dart';
import 'package:chat_koro/models/message_model.dart';
import 'package:chat_koro/services/fiirestore_services.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../consts/consts.dart';
import '../../widgets/snackbar_common.dart';
import '../chat_screen.dart';

class InputField extends StatefulWidget {
  final ChatUser user;

  const InputField({super.key, required this.user});

  @override
  State<InputField> createState() => _InputFieldState();
}

bool showEmoji = false;

class _InputFieldState extends State<InputField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: context.screenHeight * 0.098,
          padding: EdgeInsets.symmetric(
            horizontal: context.screenWidth * 0.02,
            vertical: context.screenHeight * 0.01,
          ),
          child: Card(
            color: lightGrey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        showEmoji = !showEmoji;
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: fontGrey,
                    )),
                Expanded(
                    child: TextField(

                  controller: controller,
                  onTap: () {
                    if (showEmoji) {
                      setState(() {
                        showEmoji = !showEmoji;
                      });
                    }
                  },
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      hintText: "type something...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                )),
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);
                      for (var i in images) {
                        Dialogs.showProgressBar(context);
                        await ChatApis.sendChatImage(widget.user, File(i.path)).then((value) => Get.back());
                      }
                    },
                    icon: const Icon(
                      Icons.image_outlined,
                      color: fontGrey,
                    )),
                IconButton(
                    onPressed: ()  async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        Dialogs.showProgressBar(context);
                        await ChatApis.sendChatImage(
                            widget.user, File(image.path)).then((value) => Get.back());
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: fontGrey,
                    )),
                IconButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        if(list.isEmpty){
                          ChatApis.sendFirstMsg(widget.user, controller.text, Type.text);
                        }
                        ChatApis.sendMessage(
                            widget.user, controller.text, Type.text);
                        controller.text = '';
                      }
                    },
                    icon: const Icon(
                      Icons.send_rounded,
                      color: fontGrey,
                    )),
              ],
            ),
          ),
        ),
        if (showEmoji)
          SizedBox(
            height: context.screenHeight * .30,
            child: EmojiPicker(
              textEditingController: controller,
              config: Config(
                bgColor: lightGrey,
                columns: 8,
                emojiSizeMax: 30 * (Platform.isIOS ? 1.20 : 1.0),
              ),
            ),
          )
      ],
    );
  }
}
