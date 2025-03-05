import 'package:si_angkot/data/models/format_model.dart';
import 'package:si_angkot/data/models/login_model.dart';
import 'package:si_angkot/data/remote/api_service.dart';

class LoginRepository {
  final ApiService apiService = ApiService();

  Future<FormatModel<LoginModel>> login(String email, String password) async {
    try {
      final response = await apiService.post('login', data: {
        'email': email.trim(),
        'password': password.trim(),
      });
      return FormatModel.fromJson(response.data,
          (data) => LoginModel.fromJson(data as Map<String, dynamic>));
    } catch (e) {
      print(e.toString());
      // AppUtils.showSnackbar("Login gagal", e.toString(), isError: true);
      throw Exception("Login gagal: $e");
    }
  }
}
