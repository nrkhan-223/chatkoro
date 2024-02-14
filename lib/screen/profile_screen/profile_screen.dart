import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_koro/consts/consts.dart';
import 'package:chat_koro/screen/splash_screen/splash_screen.dart';
import 'package:chat_koro/services/chat_apis.dart';
import 'package:chat_koro/services/fiirestore_services.dart';
import '../../models/chat_users_model.dart';
import 'dart:io';
import '../widgets/common_button.dart';
import '../widgets/snackbar_common.dart';
import '../widgets/text_field2.dart';
import 'component/imagepicker.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = context.screenHeight * .05;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: textfieldGrey,
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_outlined,
          color: Colors.white,
        ).onTap(() {
          Get.back();
         // Get.off(const HomeScreen(), transition: Transition.leftToRight);
        }),
        title: "Profile".text.color(Colors.white).size(24).bold.make(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        onPressed: () async {
          Dialogs.showProgressBar(context);
           await ChatApis.updateActiveStatus(false);
          await FirebaseAuth.instance.signOut().then((value) async {
            await GoogleSignIn().signOut();
          }).then((value) {
            FireStoreServices.auth=FirebaseAuth.instance;
            Get.offAll(() => const SplashScreen());
          });
        },
        icon: const Icon(
          Icons.logout_outlined,
          color: Colors.white,
        ),
        label: "LogOut".text.white.make(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            height.heightBox,
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      FireStoreServices.profileImagePath.isNotEmpty
                          ? SizedBox(
                              width: context.screenWidth * .4,
                              height: context.screenHeight * .2,
                              child: Image.file(
                                File(FireStoreServices.profileImagePath.value),
                                fit: BoxFit.cover,
                              ),
                            ).box.clip(Clip.antiAlias).roundedFull.make()
                          : SizedBox(
                                  width: context.screenWidth * .45,
                                  height: context.screenHeight * .2,
                                  // decoration:BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(15)
                                  // ) ,
                                  child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: widget.user.image,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator()
                                              .box
                                              .makeCentered(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                            Icons.person_add,
                                            size: 90,
                                          )))
                              .box
                              .clip(Clip.antiAlias)
                              .roundedFull
                              .make(),
                      Positioned(
                          bottom: 0,
                          right: -25,
                          child: MaterialButton(
                            height: 30,
                            onPressed: () {
                              Get.dialog(imagePicker(
                                context,
                              ));
                            },
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: const Icon(
                              Icons.edit,
                              color: darkFontGrey,
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),
            10.heightBox,
            widget.user.email.text.black.semiBold.size(17).make(),
            Form(
              key: _key,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    13.heightBox,
                    commonTextField(
                      onSaved: (val) => FireStoreServices.me.name = val,
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "require field",
                      value: widget.user.name,
                      hint: "eg. name",
                      label: 'Name',
                      icon: const Icon(Icons.person,
                          size: 25, color: Colors.black),
                    ),
                    15.heightBox,
                    commonTextField(
                      value: widget.user.about,
                      onSaved: (val) => FireStoreServices.me.about = val,
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "require field",
                      isDesc: true,
                      hint: "eg. about",
                      label: 'About',
                      icon: const Icon(Icons.account_box_outlined,
                          size: 25, color: Colors.black),
                    ),
                    30.heightBox,
                    commonButton(
                        onPress: () {
                          if (_key.currentState!.validate()) {
                            _key.currentState!.save();
                            FireStoreServices.userUpdate(context);
                          }
                        },
                        title: "Update",
                        height: 47,
                        width: 120,
                        color: fontGrey,
                        textColor: whiteColor)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).onTap(() {
      FocusScope.of(context).unfocus();
    });
  }
}
