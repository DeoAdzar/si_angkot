import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:si_angkot/data/models/students_model.dart';
import 'package:si_angkot/data/repositories/feat/parent_repository.dart';

class ParentController extends GetxController {
  var studentsList = <StudentData>[].obs;
  final ParentRepository parentRepository = ParentRepository();
  var imageFile = Rx<File?>(null);

  @override
  void onInit() {
    fetchStudentsDummy();
    super.onInit();
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> fetchStudentFromServer() async {
    try {
      final response = await parentRepository.fetchStudent();
      studentsList.assignAll(response);
    } catch (e) {
      print(e.toString());
      // AppUtils.showSnackbar("Register gagal", e.toString(), isError: true);
      throw Exception("Register gagal: $e");
    }
  }

  void fetchStudentsDummy() {
    studentsList.assignAll([
      StudentData(
          id: 1,
          name: "John Doe",
          school: "SMP 1",
          email: "johndoe@gmail.com",
          number: "12334125123",
          pict: "https://via.placeholder.com/150",
          schoolAddress: "Jl. Jendral Sudirman",
          status: "Menunggu Verifikasi",
          phone: "081234123123"),
      StudentData(
          id: 1,
          name: "Bagas",
          school: "SMP 2",
          email: "bagas@gmail.com",
          number: "66641525123123",
          pict: "https://via.placeholder.com/150",
          schoolAddress: "Jl. Jendral Sudirman",
          status: "Terdaftar",
          phone: "081234123123")
    ]);
  }
}
