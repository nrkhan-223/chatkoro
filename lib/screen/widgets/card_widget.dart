import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_koro/models/message_model.dart';
import 'package:chat_koro/services/chat_apis.dart';
import 'package:chat_koro/services/fiirestore_services.dart';
import '../../consts/consts.dart';
import '../../models/chat_users_model.dart';
import '../chat_screen/chat_screen.dart';

class UserCard extends StatelessWidget {
  final ChatUser user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Message? message;
    String getMonth(DateTime date) {
      switch (date.month) {
        case 1:
          return 'jan';
        case 2:
          return 'feb';
        case 3:
          return 'mar';
        case 4:
          return 'apr';
        case 5:
          return 'may';
        case 6:
          return 'jun';
        case 7:
          return 'jul';
        case 8:
          return 'aug';
        case 9:
          return 'sep';
        case 10:
          return 'oct';
        case 11:
          return 'nov';
        case 12:
          return 'dec';
      }
      return 'NA';
    }

    String getLastMessageTime(BuildContext context, String time) {
      final DateTime sendTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(time));
      final DateTime now = DateTime.now();
      if (now.day == sendTime.day &&
          now.month == sendTime.month &&
          now.year == sendTime.year) {
        return TimeOfDay.fromDateTime(sendTime).format(context);
      }
      return ' ${sendTime.day} ${getMonth(sendTime)}';
    }

    return Card(
        color: Colors.grey[400],
        elevation: 1.0,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: StreamBuilder(
            stream: ChatApis.getLastMessage(user),
            builder: (context, snapshot) {
             if(!snapshot.hasData){
               return Center(child: "Loading...".text.make());
             }else{
               final data1 = snapshot.data!.docs;
               final list =
                   data1.map((e) => Message.fromJson(e.data())).toList() ?? [];
               if(list.isNotEmpty){
                 message=list[0];
               }
               return ListTile(
                 leading: CachedNetworkImage(
                   imageUrl: user.image,
                   placeholder: (context, url) =>
                   const CircularProgressIndicator(),
                   errorWidget: (context, url, error) => const Icon(Icons.error),
                 ).box.rounded.clip(Clip.antiAlias).make(),
                 title: user.name.text.semiBold.make(),
                 subtitle: message != null?
                     message!.type==Type.image?"image".text.size(13.5).black.make():
                      message?.msg.text.black.size(13.5).maxLines(1).make()
                     : user.about.text.black.size(13.5).maxLines(1).make(),
                 trailing: message == null
                     ? null
                     : message!.read.isEmpty &&
                     message!.fromId != FireStoreServices.cuser.uid
                     ? Container(
                   width: 10,
                   height: 10,
                   color: Colors.green.shade700,
                 ).box.rounded.clip(Clip.antiAlias).make()
                     : getLastMessageTime(context, message!.send)
                     .text
                     .color(Colors.black54)
                     .make(),
               );
             }
            })).onTap(() {
      Get.to(
          () => ChatScreen(
                user: user,
              ),
          transition: Transition.leftToRight);
    });
  }
}
