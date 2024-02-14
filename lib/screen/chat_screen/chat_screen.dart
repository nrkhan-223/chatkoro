import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_koro/models/chat_users_model.dart';
import 'package:chat_koro/screen/chat_screen/component/chat_bouble.dart';
import 'package:chat_koro/screen/chat_screen/component/input_bar.dart';
import 'package:chat_koro/screen/profile_screen/view_profile_screen.dart';
import 'package:chat_koro/services/chat_apis.dart';
import '../../consts/consts.dart';
import '../../models/message_model.dart';
import '../../services/time.dart';
import '../widgets/loading_design.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
List<Message> list = [];
class _ChatScreenState extends State<ChatScreen> {


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (change) async {
        if (showEmoji) {
          setState(() {
            showEmoji = !showEmoji;
          });
          return;
        } else {
          Get.back();
        }
      },
      child: Scaffold(
        backgroundColor: chatBackColor,
        appBar: AppBar(
          toolbarHeight: context.screenHeight * 0.08,
          leadingWidth: context.screenWidth * .7,
          leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: StreamBuilder(
                  stream: ChatApis.getUserInfo(widget.user),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return loadingIndicator();
                    } else {
                      final data = snapshot.data!.docs;
                      final list =
                          data.map((e) => ChatUser.fromJson(e.data())).toList();
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.arrow_back_outlined,
                            color: whiteColor,
                          ).onTap(() {
                            Get.back();
                          }),
                          12.widthBox,
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: whiteColor,
                            child: CachedNetworkImage(
                              imageUrl: list.isNotEmpty
                                  ? list[0].image
                                  : widget.user.image,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ).box.roundedFull.clip(Clip.antiAlias).make(),
                          ),
                          5.widthBox,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              3.heightBox,
                              list.isNotEmpty
                                  ? list[0]
                                      .name
                                      .text
                                      .lineHeight(1)
                                      .bold
                                      .size(15)
                                      .white
                                      .makeCentered()
                                  : widget.user.name.text.bold
                                      .lineHeight(1)
                                      .size(15)
                                      .white
                                      .makeCentered(),
                              list.isNotEmpty
                                  ? list[0].isOnline
                                      ? "Online"
                                          .text
                                          .lineHeight(1)
                                          .semiBold
                                          .size(13)
                                          .color(Colors.white60)
                                          .make()
                                      : Time.getActiveLastTime(
                                              context, list[0].lastActive)
                                          .text
                                          .lineHeight(1)
                                          .semiBold
                                          .size(13)
                                          .color(Colors.white60)
                                          .make()
                                  : Time.getActiveLastTime(
                                          context, widget.user.lastActive)
                                      .text
                                      .lineHeight(1)
                                      .semiBold
                                      .size(13)
                                      .color(Colors.white60)
                                      .make()
                            ],
                          )
                        ],
                      );
                    }
                  })),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 17,
                    backgroundColor: whiteColor,
                    child: Icon(
                      Icons.call,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  10.widthBox,
                  const CircleAvatar(
                    radius: 17,
                    backgroundColor: whiteColor,
                    child: Icon(
                      Icons.video_call_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  10.widthBox,
                  const CircleAvatar(
                    radius: 17,
                    backgroundColor: whiteColor,
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                  ).onTap(() {
                    Get.to(ViewProfileScreen(user: widget.user));
                  }),
                  5.widthBox
                ],
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: ChatApis.getAllMessage(widget.user),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: loadingIndicator());
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "Hi👋"
                              .text
                              .semiBold
                              .size(20)
                              .color(darkFontGrey)
                              .make(),
                          "No Chat Yet With This User"
                              .text
                              .size(12)
                              .color(darkFontGrey)
                              .make()
                        ],
                      ));
                    } else {
                      final data1 = snapshot.data!.docs;
                      list =
                          data1.map((e) => Message.fromJson(e.data())).toList();
                      return ListView.builder(
                          reverse: true,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: list.length,
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 5, right: 5),
                          itemBuilder: (context, index) {
                            return ChatBubble(
                              message: list[index],
                            );
                          });
                    }
                  }),
            ),
            InputField(
              user: widget.user,
            ),
          ],
        ),
      ).onTap(() {
        FocusScope.of(context).unfocus();
      }),
    );
  }
}
