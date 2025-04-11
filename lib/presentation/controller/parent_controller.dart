import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:si_angkot/data/models/students_model.dart';

class ParentController extends GetxController {
  var studentsList = <StudentData>[].obs;
  var imageFile = Rx<File?>(null);
  var nameTemp = "".obs;
  var pictTemp = "".obs;
  var addressTemp = "".obs;
  var phoneTemp = "".obs;
  var emailTemp = "".obs;

  @override
  void dispose() {
    super.dispose();
    imageFile.value = null;
  }

  void resetDataInfo() {
    nameTemp.value = "";
    addressTemp.value = "";
    pictTemp.value = "";
    phoneTemp.value = "";
    emailTemp.value = "";
  }

  void setDataInfo(
      String name, String pict, String address, String phone, String email) {
    nameTemp.value = name;
    addressTemp.value = address;
    pictTemp.value = pict;
    phoneTemp.value = phone;
    emailTemp.value = email;
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }
}
