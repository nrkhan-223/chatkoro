import 'dart:developer';
import 'package:chat_koro/services/chat_apis.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_koro/consts/consts.dart';
import 'package:flutter/services.dart';
import '../../models/chat_users_model.dart';
import '../../services/fiirestore_services.dart';
import '../profile_screen/profile_screen.dart';
import '../widgets/card_widget.dart';
import '../widgets/common_button.dart';
import '../widgets/exit_dialog.dart';
import '../widgets/loading_design.dart';
import '../widgets/snackbar_common.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  initState() {
    super.initState();
    FireStoreServices.getSelf();
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('\n message $message');

      if (FireStoreServices.auth.currentUser != null) {
        if (message.toString().contains('pause')) {
          ChatApis.updateActiveStatus(false);
        }
        if (message.toString().contains('resume')) {
          ChatApis.updateActiveStatus(true);
        }
      }

      return Future.value(message);
    });
  }

  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (change) async {
        if (isSearching) {
          setState(() {
            isSearching = !isSearching;
          });
          return;
        } else {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => exitDialog(context));
          return;
        }
      },
      child: Scaffold(
          backgroundColor: textfieldGrey,
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.home),
            title: const Text("Messages"),
            actions: [
              IconButton(
                icon: Icon(isSearching
                    ? CupertinoIcons.clear_circled
                    : CupertinoIcons.search),
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.ellipsis_vertical),
                onPressed: () {
                  Get.to(
                      () => ProfileScreen(
                            user: FireStoreServices.me,
                          ),
                      transition: Transition.rightToLeft);
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.back();
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => _showMsgUpdateDialog(context));
              return;
            },
            backgroundColor: fontGrey,
            child: const Icon(
              Icons.add_comment_sharp,
              color: Colors.white,
            ),
          ),
          body: Column(
            children: [
              Visibility(
                visible: isSearching,
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 5),
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(
                              color: Colors.black, width: 1.2)),
                      hintText: "Name,Email",
                      hintStyle: const TextStyle(color: fontGrey),
                    ),
                    onChanged: (val) {
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FireStoreServices.getFriendsId(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: loadingIndicator());
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: "Add Fired To Start Conversation"
                              .text
                              .semiBold
                              .color(darkFontGrey)
                              .make());
                    } else {
                      final data = snapshot.data!.docs;
                      return StreamBuilder(
                          stream: FireStoreServices.allUser(
                              data.map((e) => e.id).toList()),
                          builder: (context, snapshot) {
                            //
                            // switch(snapshot.connectionState){
                            //   case ConnectionState.waiting:
                            //   case ConnectionState.none:
                            //     return Center(
                            //         child: "No Chat Yet".text.semiBold.color(darkFontGrey).make());
                            //   case ConnectionState.active:
                            //   case ConnectionState.done:
                            //     return Center(
                            //          return listViewBuilder or listTile
                            //         );
                            //   }
                            if (!snapshot.hasData) {
                              return Center(child: loadingIndicator());
                            } else if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                  child: "No User Yet"
                                      .text
                                      .semiBold
                                      .color(darkFontGrey)
                                      .make());
                            } else {
                              final data1 = snapshot.data!.docs;
                              _list = data1
                                  .map((e) => ChatUser.fromJson(e.data()))
                                  .toList();
                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 5, right: 5),
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: isSearching
                                      ? _searchList.length
                                      : _list.length,
                                  itemBuilder:
                                      (BuildContext context, index) {
                                    return UserCard(
                                      user: isSearching
                                          ? _searchList[index]
                                          : _list[index],
                                    );
                                  });
                            }
                          });
                    }
                  }),
            ],
          )).onTap(() {
        FocusScope.of(context).unfocus();
      }),
    );
  }

  Widget _showMsgUpdateDialog(context) {
    String email = "";
    return Dialog(
      child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  "Add User".text.bold.size(18).color(darkFontGrey).make(),
                  const Divider(
                    color: chatBackColor,
                    thickness: 2,
                  ),
                  5.heightBox,
                  TextFormField(
                    autofocus: true,
                    onChanged: (value) => email = value,
                    maxLines: null,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      label: const Text(
                        "Email",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: fontGrey),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(
                              color: Colors.black, width: 1.2)),
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
                          title: "Add",
                          onPress: () async {
                            if (email.isNotEmpty) {
                              await FireStoreServices.addFriends(email);
                            }
                          }),
                    ],
                  )
                ],
              ))
          .box
          .color(textfieldGrey)
          .padding(const EdgeInsets.all(10))
          .rounded
          .make(),
    );
  }
}
