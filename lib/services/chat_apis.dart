import 'dart:developer';
import 'package:chat_koro/consts/consts.dart';
import 'package:chat_koro/models/chat_users_model.dart';
import 'package:chat_koro/models/message_model.dart';
import 'package:chat_koro/services/notification_apis.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'fiirestore_services.dart';
import 'dart:io';

class ChatApis {
  static String getConvId(String id) =>
      FireStoreServices.cuser.uid.hashCode <= id.hashCode
          ? '${FireStoreServices.cuser.uid}_$id'
          : '${id}_${FireStoreServices.cuser.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessage(
      ChatUser user) {
    return FireStoreServices.fireStore
        .collection('chat/${getConvId(user.id)}/message/')
        .orderBy('send', descending: true)
        .snapshots();
  }

  static Future<void> sendFirstMsg(ChatUser user, String msg, Type type) async {
    await FireStoreServices.fireStore
        .collection(userCollection)
        .doc(user.id)
        .collection('friends')
        .doc(FireStoreServices.cuser.uid)
        .set({}).then((value) {
      ChatApis.sendMessage(user, msg, type);
    });
  }

  static Future<void> sendMessage(
    ChatUser user,
    String msg,
    Type type,
  ) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
      msg: msg,
      read: '',
      fromId: FireStoreServices.cuser.uid,
      toId: user.id,
      type: type,
      send: time,
    );
    final ref = FireStoreServices.fireStore
        .collection('chat/${getConvId(user.id)}/message/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        NotificationApi.sendNotification(
            user, type == Type.text ? msg : 'image'));
  }

  static Future<void> updateMessageStatus(Message message) async {
    FireStoreServices.fireStore
        .collection('chat/${getConvId(message.fromId)}/message/')
        .doc(message.send)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return FireStoreServices.fireStore
        .collection('chat/${getConvId(user.id)}/message/')
        .orderBy('send', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUser user, File file) async {
    final ext = file.path.split('.').last;
    final ref = FireStoreServices.storage.ref().child(
        'image/${getConvId(user.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => {log('data Transfer:${p0.bytesTransferred / 1000} kb')});
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(user, imageUrl, Type.image);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser user) {
    return FireStoreServices.fireStore
        .collection(userCollection)
        .where('id', isEqualTo: user.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    FireStoreServices.fireStore
        .collection(userCollection)
        .doc(FireStoreServices.cuser.uid)
        .update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': FireStoreServices.me.pushToken
    });
  }

  static Future<void> deleteMessage(Message message) async {
    await FireStoreServices.fireStore
        .collection('chat/${getConvId(message.toId)}/message/')
        .doc(message.send)
        .delete();
    if (message.type == Type.image) {
      await FireStoreServices.storage.refFromURL(message.msg).delete();
    }
  }

  static Future<void> updateMessage(Message message, String updatedMsg) async {
    await FireStoreServices.fireStore
        .collection('chat/${getConvId(message.toId)}/message/')
        .doc(message.send)
        .update({
      'msg': updatedMsg,
    });
  }
}
