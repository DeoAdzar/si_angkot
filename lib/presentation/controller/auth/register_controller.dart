import 'package:get/get.dart';
import 'package:si_angkot/core/utils/app_utils.dart';
import 'package:si_angkot/data/models/format_model.dart';
import 'package:si_angkot/data/repositories/auth/register_repository.dart';

class RegisterController extends GetxController {
  final RegisterRepository registerRepository = RegisterRepository();

  var isLoading = false.obs;
  FormatModel? formatModel;

  Future<void> register(String name, String address, String phone, String email,
      String password, String role) async {
    try {
      isLoading.value = true;
      update();

      final response = await registerRepository.register(
          name, address, phone, email, password, role);
      formatModel = response;

      if (response.code == 200) {
        Get.offAllNamed('/login');
      } else {
        AppUtils.showSnackbar("Register gagal", response.message,
            isError: true);
      }
    } catch (e) {
      print(e.toString());
      AppUtils.showSnackbar("Register gagal", "Please try again later",
          isError: true);
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
