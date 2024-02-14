import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_koro/models/message_model.dart';
import 'package:chat_koro/screen/widgets/item.dart';
import 'package:chat_koro/services/chat_apis.dart';
import 'package:chat_koro/services/fiirestore_services.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../../../consts/consts.dart';
import '../../../services/time.dart';
import '../../widgets/common_button.dart';
import '../../widgets/snackbar_common.dart';

class ChatBubble extends StatefulWidget {
  final Message message;

  const ChatBubble({super.key, required this.message});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    bool isMe = FireStoreServices.cuser.uid == widget.message.fromId;
    return InkWell(
      child: isMe ? _greenBubble() : _blueBubble(),
      onLongPress: () {
        _showBottomSheet(context, isMe);
      },
    );
  }

  Widget _blueBubble() {
    if (widget.message.read.isEmpty) {
      ChatApis.updateMessageStatus(widget.message);
    }

    return Padding(
      padding: EdgeInsets.only(right: context.screenWidth * .04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              padding: widget.message.type == Type.text
                  ? EdgeInsets.symmetric(
                  horizontal: context.width * .038,
                  vertical: context.screenHeight * .009)
                  : EdgeInsets.all(context.screenWidth * .03),
              margin: EdgeInsets.symmetric(
                  horizontal: context.width * 0.03,
                  vertical: context.screenHeight * .013),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(27),
                    topRight: Radius.circular(27),
                    bottomRight: Radius.circular(27)),
                border: Border.all(color: Colors.blue.shade800),
                color: lightBlue,
              ),
              child: widget.message.type == Type.text
                  ? widget.message.msg.text.black.size(17).make()
                  : CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.message.msg,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator().box.makeCentered(),
                  errorWidget: (context, url, error) =>
                  const Icon(
                    Icons.image_outlined,
                    size: 90,
                  )).box
                  .clip(Clip.antiAlias)
                  .rounded
                  .make(),
            ),
          ),
          Time
              .getTime(context, widget.message.send)
              .text
              .size(13)
              .color(Colors.white70)
              .make()
        ],
      ),
    );
  }

  Widget _greenBubble() {
    return Padding(
      padding: EdgeInsets.only(left: context.screenWidth * .04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (widget.message.read.isNotEmpty)
                const Icon(
                  Icons.done_all_rounded,
                  color: Colors.black,
                  size: 20,
                ),
              5.widthBox,
              Time
                  .getTime(context, widget.message.send)
                  .text
                  .size(13)
                  .color(Colors.white70)
                  .make()
            ],
          ),
          Flexible(
            child: Container(
              padding: widget.message.type == Type.text
                  ? EdgeInsets.symmetric(
                  horizontal: context.width * .038,
                  vertical: context.screenHeight * .009)
                  : EdgeInsets.all(context.screenWidth * .03),
              margin: EdgeInsets.symmetric(
                  horizontal: context.width * 0.03,
                  vertical: context.screenHeight * .013),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(27),
                    topRight: Radius.circular(27),
                    bottomLeft: Radius.circular(27)),
                border: Border.all(color: Colors.green.shade800, width: 1.5),
                color: lightGreen,
              ),
              child: widget.message.type == Type.text
                  ? widget.message.msg.text.black.size(17).make()
                  : CachedNetworkImage(
                  imageUrl: widget.message.msg,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator().box.makeCentered(),
                  errorWidget: (context, url, error) =>
                  const Icon(
                    Icons.image_outlined,
                    size: 90,
                  )).box
                  .clip(Clip.antiAlias)
                  .rounded
                  .make(),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, isME) {
    Get.bottomSheet(Container(
        width: context.screenWidth,
        padding: const EdgeInsets.only(top: 2),
        height: isME
            ? widget.message.type == Type.text
            ? context.screenHeight * 0.46
            : context.screenHeight * 0.38
            : context.screenHeight * 0.28,
        decoration: const BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          children: [
            10.heightBox,
            Container(
              width: 150,
              height: 4.3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: fontGrey),
            ),
            widget.message.type == Type.text
                ? Container(
                color: lightGrey,
                width: context.screenWidth,
                child: item(
                    const Icon(
                      Icons.copy_all,
                      color: Colors.black,
                    ),
                    "Copy Text",
                    context))
                .onTap(
                  () async {
                await Clipboard.setData(
                    ClipboardData(text: widget.message.msg))
                    .then((value) {
                  Get.back();
                  Dialogs.showSnackBar(
                      "Successfully", "Text copied", Icons.copy_all);
                });
              },
            )
                : Container(
              color: lightGrey,
              width: context.screenWidth,
              child: item(
                  const Icon(
                    Icons.download_rounded,
                    color: Colors.black,
                  ),
                  "Save Image",
                  context),
            ).onTap(() async {
              try {
                await GallerySaver.saveImage(
                    widget.message.msg, albumName: 'Chat Koro').then((value) {
                  Get.back();
                  if (value != null) {
                    Dialogs.showSnackBar(
                        'Image saved', 'Successfully', Icons.done);
                  }
                });
              } catch (e) {
                log('\nerror$e');
              }
            }),
            Divider(
              color: darkFontGrey,
              thickness: 1.2,
              endIndent: context.screenWidth * .04,
              indent: context.screenWidth * .04,
            ),
            if (widget.message.type == Type.text && isME)
              Container(
                color: lightGrey,
                width: context.screenWidth,
                child: item(
                    const Icon(
                      Icons.edit,
                      color: Colors.green,
                    ),
                    "Edit Message",
                    context),
              ).onTap(() {
                Get.back();
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => _showMsgUpdateDialog(context));
                return;
              }),
            if (isME)
              Container(
                color: lightGrey,
                width: context.screenWidth,
                child: item(
                    const Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.red,
                    ),
                    widget.message.type == Type.text
                        ? "Delete Message"
                        : "Delete Image",
                    context),
              ).onTap(() async {
                Dialogs.showProgressBar(context);
                await ChatApis.deleteMessage(widget.message).then((value) {
                  Get.back();
                  Get.back();
                });
              }),
            if (isME)
              Divider(
                color: darkFontGrey,
                thickness: 1.2,
                endIndent: context.screenWidth * .04,
                indent: context.screenWidth * .04,
              ),
            Container(
              color: lightGrey,
              width: context.screenWidth,
              child: item(
                  const Icon(
                    Icons.remove_red_eye_rounded,
                    color: Colors.blue,
                  ),
                  "Send At: ${Time.getReadTime(context, widget.message.send)}",
                  context),
            ),
            Container(
              color: lightGrey,
              width: context.screenWidth,
              child: item(
                  const Icon(
                    Icons.remove_red_eye_rounded,
                    color: Colors.green,
                  ),
                  widget.message.read.isEmpty
                      ? "Not seen yet"
                      : "ReaD At: ${Time.getReadTime(
                      context, widget.message.read)}",
                  context),
            ),
          ],
        )));
  }

  Widget _showMsgUpdateDialog(context) {
    String updateMsg = widget.message.msg;
    return Dialog(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              "Update Message".text.bold.size(18).color(darkFontGrey).make(),
              const Divider(
                thickness: 2,
              ),
              Flexible(
                child: TextFormField(
                  autofocus: true,
                  initialValue: updateMsg,
                  onChanged: (value)=>updateMsg=value,
                  maxLines: null,
                  style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w400,),
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: const BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: const BorderSide(color: Colors.black,width: 1.2)),
                  ),
                ),
              ),
              10.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  commonButton(
                      color: fontGrey,
                      textColor: whiteColor,
                      title: "Cancel",
                      height: 35,
                      width: 100,
                      onPress: () {
                        Get.back();
                      }),
                  commonButton(
                      color: fontGrey,
                      textColor: whiteColor,
                      height: 35,
                      width: 100,
                      title: "Update",
                      onPress: () {
                        Get.back();
                        ChatApis.updateMessage(widget.message, updateMsg);
                      }),
                ],
              )
            ],
          )

      ).box
          .color(textfieldGrey)
          .padding(const EdgeInsets.all(10))
          .rounded
          .make(),
    );
  }
}
