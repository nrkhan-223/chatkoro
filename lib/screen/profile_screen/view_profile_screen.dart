import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

import '../../consts/consts.dart';
import '../../models/chat_users_model.dart';
import '../../services/fiirestore_services.dart';
import '../../services/time.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
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
          // Get.back();
          Get.back();
        }),
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
                              errorWidget: (context, url, error) => const Icon(
                                    Icons.person_add,
                                    size: 90,
                                  ))).box.clip(Clip.antiAlias).roundedFull.make(),
                ],
              ),
            ),
            10.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                "Email: ".text.bold.size(19).black.make(),
                widget.user.email.text.black.semiBold.size(16).make(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                "Name: ".text.bold.size(19).black.make(),
                widget.user.name.text.black.semiBold.size(16).make(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                "About: ".text.bold.size(19).black.make(),
                widget.user.about.text.black.semiBold.size(16).make(),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                "Joined On: ".text.bold.size(19).black.make(),
                Time.getCreatedTime(context, widget.user.createdAt)
                    .text
                    .black
                    .size(16)
                    .semiBold
                    .make(),
              ],
            ),
            15.heightBox
          ],
        ),
      ),
    );
  }
}
