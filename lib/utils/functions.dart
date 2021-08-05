import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> pickImage() async {
  File file;
  ImagePicker imagePicker = ImagePicker();

  await Permission.photos.request();

  var permissionStatus = await Permission.photos.status;

  if (permissionStatus.isGranted) {
    final XFile? photo =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      file = File(photo.path);

      String image = base64Encode(file.readAsBytesSync());
      return image;
    } else {
      print('Pick Image First');
      return 'Error';
    }
  } else {
    print('Give Permissions First');
    return 'Error';
  }
}
