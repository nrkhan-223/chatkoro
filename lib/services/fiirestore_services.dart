import 'dart:io';
import 'package:chat_koro/consts/consts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:chat_koro/models/message_model.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/chat_users_model.dart';
import '../screen/widgets/snackbar_common.dart';
import 'chat_apis.dart';
import 'notification_apis.dart';

class FireStoreServices {
  static var profileImgLink = '';
  static var profileImagePath = ''.obs;

  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static get cuser => auth.currentUser!;
  static late ChatUser me;

  static Future<void> getSelf() async {
    await fireStore
        .collection(userCollection)
        .doc(cuser.uid)
        .get()
        .then((value) async {
      if (value.exists) {
        me = ChatUser.fromJson(value.data()!);
        await NotificationApi.getMessageToken();
        ChatApis.updateActiveStatus(true);
      } else {
        await createUser().then((value) {
          getSelf();
        });
      }
    });
  }

  static Future<bool> userExist() async {
    return (await fireStore
            .collection(userCollection)
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<void> createUser() async {
    final user = ChatUser(
        image: cuser.photoURL.toString(),
        about: "Hi There I`m Using Free Chat",
        name: cuser.displayName.toString(),
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        id: cuser.uid,
        lastActive: DateTime.now().microsecondsSinceEpoch.toString(),
        isOnline: true,
        email: cuser.email.toString(),
        pushToken: "");

    return await fireStore
        .collection(userCollection)
        .doc(cuser.uid)
        .set(user.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getFriendsId() {
    return fireStore
        .collection(userCollection)
        .doc(cuser.uid)
        .collection('friends')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> allUser(
      List<String> userIds) {
    return fireStore
        .collection(userCollection)
        .where('id', whereIn: userIds)
        //.where('id', isNotEqualTo: cuser.uid)
        .snapshots();
  }



  static Future<void> userUpdate(context) async {
    Dialogs.showProgressBar(context);
    await fireStore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .update({
      'name': me.name,
      'about': me.about,
    }).then((value) async {
      if (profileImagePath.isNotEmpty) {
        await uploadProfileImage();
      }
    }).then((value) => Get.back());
  }

  static changeImage(context, source) async {
    await Permission.camera.request().then((value) async {
      await Permission.photos.request().then((value) async {
        await Permission.storage.request();
      });
    });

    var status = await Permission.photos.status;
    if (status.isGranted) {
      try {
        final img =
            await ImagePicker().pickImage(source: source, imageQuality: 80);
        if (img == null) return;
        profileImagePath.value = img.path;
      } on PlatformException catch (e) {
        VxToast.show(context, msg: e.toString());
      }
    }
  }

  static uploadProfileImage() async {
    var filename = basename(profileImagePath.value);
    var destination = 'profile_image/${cuser.uid}/$filename';
    Reference ref = storage.ref().child(destination);
    await ref.putFile(File(profileImagePath.value));
    profileImgLink = await ref.getDownloadURL();
  }

  static Future<void> addFriends(String email) async {
    final data = await fireStore
        .collection(userCollection)
        .where('email', isEqualTo: email)
        .get();
    if (data.docs.isNotEmpty && data.docs.first.id != cuser.uid) {
      fireStore
          .collection(userCollection)
          .doc(cuser.uid)
          .collection('friends')
          .doc(data.docs.first.id)
          .set({}).then((value) {
        Get.back();
        Dialogs.showSnackBar('User Add successfully', "Done", Icons.done);
      });
    } else {
      Dialogs.showSnackBar(
          'Something Went Wrong or User Do Not Exist', "Error", Icons.error);
    }
  }
}
