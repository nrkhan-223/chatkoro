import 'package:chat_koro/services/fiirestore_services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../consts/consts.dart';

Widget imagePicker(context) {
  var listTile = ["camera", "gallery"];
  var icon = [Icons.camera_alt_rounded, Icons.image_rounded];
  return Dialog(
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: textfieldGrey, borderRadius: BorderRadius.circular(14)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          "Select one".text.black.size(17).semiBold.make(),
          const Divider(
            thickness: 1,
            color: Colors.black,
          ),
          10.heightBox,
          ListView(
            shrinkWrap: true,
            children: List.generate(
                listTile.length,
                (index) => ListTile(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Get.back();
                            FireStoreServices.changeImage(context, ImageSource.camera);
                            break;
                          case 1:
                            Get.back();
                            FireStoreServices.changeImage(context, ImageSource.gallery);
                            break;
                        }
                      },
                      leading: Icon(
                        icon[index],
                        color: Colors.black,
                      ),
                      title: listTile[index].text.black.make(),
                    )),
          )
        ],
      ),
    ),
  );
}
