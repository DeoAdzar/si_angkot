import 'package:get/get.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_utils.dart';
import 'package:si_angkot/data/models/login_model.dart';
import 'package:si_angkot/data/remote/api_service.dart';
import 'package:si_angkot/data/repositories/auth/login_repository.dart';

class LoginController extends GetxController {
  final LoginRepository loginRepository = LoginRepository();

  bool isLoading = false;
  LoginModel? loginModel;

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      update(); // Rebuild hanya widget yang pakai GetBuilder

      // final response = await loginRepository.login(email, password);
      // if (response.code == 200) {
      //   loginModel = response.data;
      //   ApiService().setToken(response.data?.token);
      //   if (response.data?.role == "driver") {
      //     Get.offAllNamed('/driver-home');
      //   } else if (response.data?.role == "parent") {
      //     Get.offAllNamed('/parent-home');
      //   } else {
      //     Get.offAllNamed("/student-home");
      //   }
      // } else {
      //   AppUtils.showSnackbar("Login gagal", response.message, isError: true);
      // }
      if (email.isEmpty || password.isEmpty) {
        var isAllEmpty = email.isEmpty && password.isEmpty;
        var message = isAllEmpty
            ? "${Constant.EMAIL} dan ${Constant.PASSWORD}"
            : email.isEmpty
                ? Constant.EMAIL
                : Constant.PASSWORD;
        AppUtils.showSnackbar(
            "Isian tidak boleh kosong", "$message tidak boleh kosong",
            isError: true);
        return;
      } else {
        //dummy login
        if (email == "driver" && password == "driver") {
          Get.offAllNamed('/driver-home');
        } else if (email == "parent" && password == "parent") {
          Get.offAllNamed('/parent-home');
        } else if (email == "student" && password == "student") {
          Get.offAllNamed("/student-home");
        } else {
          AppUtils.showSnackbar("Login gagal", "Email atau password salah",
              isError: true);
        }

        // final response = await loginRepository.login(email, password);
        // if (response.code == 200) {
        //   loginModel = response.data;
        //   ApiService().setToken(response.data?.token);
        //   if (response.data?.role == "driver") {
        //     Get.offAllNamed('/driver-home');
        //   } else if (response.data?.role == "parent") {
        //     Get.offAllNamed('/parent-home');
        //   } else {
        //     Get.offAllNamed("/student-home");
        //   }
        // } else {
        //   AppUtils.showSnackbar("Login gagal", response.message, isError: true);
        // }
      }
    } catch (e) {
      print(e.toString());
      AppUtils.showSnackbar(Constant.SOMETHING_WRONG, "Please try again later",
          isError: true);
    } finally {
      isLoading = false;
      update(); // Rebuild setelah loading selesai
    }
  }
}


  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  // final ApiService apiService = ApiService();

  // var isPassworddHidden = true.obs;
  // var isLoading = false.obs;

  // void togglePasswordVisibility() {
  //   isPassworddHidden.value = !isPassworddHidden.value;
  // }

  // Future<void> login() async {
  //   try {
  //     if (emailController.text.isEmpty || passwordController.text.isEmpty) {
  //       var isAllEmpty =
  //           emailController.text.isEmpty && passwordController.text.isEmpty;
  //       var message = isAllEmpty
  //           ? "${Constant.EMAIL} dan ${Constant.PASSWORD}"
  //           : emailController.text.isEmpty
  //               ? Constant.EMAIL
  //               : Constant.PASSWORD;
  //       AppUtils.showSnackbar(
  //           "Isian tidak boleh kosong", "$message tidak boleh kosong",
  //           isError: true);
  //       return;
  //     } else {
  //       final response = await apiService.post('login', data: {
  //         'email': emailController.text.trim(),
  //         'password': passwordController.text.trim(),
  //       });
  //       if (response.statusCode == 200) {
  //         // AppUtils.showSnackbar("Login berhasil", "Selamat datang");
  //         var rawData = FormatModel.fromJson(response.data,
  //             (data) => LoginModel.fromJson(data as Map<String, dynamic>));
  //         if (rawData.code == 200) {
  //           AppUtils.showSnackbar("Login berhasil", "Selamat datang");
  //           ApiService().setToken(rawData.data?.token);
  //           if (rawData.data?.role == "driver") {
  //             Get.offAllNamed('/driver-home');
  //           } else if (rawData.data?.role == "parent") {
  //             Get.offAllNamed('/parent-home');
  //           } else {
  //             Get.offAllNamed("/student-home");
  //           }
  //         } else {
  //           AppUtils.showSnackbar("Login gagal", rawData.message,
  //               isError: true);
  //         }
  //       }
  //     }
  //   } on Exception catch (e) {
  //     print(e.toString());
  //     AppUtils.showSnackbar(Constant.SOMETHING_WRONG, "Please try again later",
  //         isError: true);
  //   }
  // }
