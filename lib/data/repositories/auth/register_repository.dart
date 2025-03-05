import 'package:si_angkot/data/models/format_model.dart';
import 'package:si_angkot/data/remote/api_service.dart';

class RegisterRepository {
  final ApiService apiService = ApiService();

  Future<FormatModel> register(String name, String address, String phone,
      String email, String password, String role) async {
    try {
      await apiService.post('register', data: {
        'phone': phone.trim(),
        'address': address.trim(),
        'email': email.trim(),
        'password': password.trim(),
        'name': name.trim(),
        'role': role.trim(),
      });

      return FormatModel(code: 200, message: "Register berhasil");
    } catch (e) {
      print(e.toString());
      throw Exception("Register gagal: $e");
    }
  }
}
