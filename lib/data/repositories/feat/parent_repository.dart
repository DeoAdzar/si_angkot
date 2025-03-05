import 'package:si_angkot/data/models/format_model.dart';
import 'package:si_angkot/data/models/students_model.dart';
import 'package:si_angkot/data/remote/api_service.dart';

class ParentRepository {
  final ApiService apiService = ApiService();

  Future<FormatModel<StudentData>> registerStudent(
      String name,
      String school,
      String email,
      String number,
      String pict,
      String schoolAddress,
      String status,
      String phone) async {
    try {
      final response = await apiService.post('register-student', data: {
        'name': name.trim(),
        'school': school.trim(),
        'email': email.trim(),
        'number': number.trim(),
        'pict': pict.trim(),
        'schoolAddress': schoolAddress.trim(),
        'status': status.trim(),
        'phone': phone.trim(),
      });
      return FormatModel.fromJson(response.data,
          (data) => StudentData.fromJson(data as Map<String, dynamic>));
    } catch (e) {
      print(e.toString());
      // AppUtils.showSnackbar("Register gagal", e.toString(), isError: true);
      throw Exception("Register gagal: $e");
    }
  }

  Future<List<StudentData>> fetchStudent() async {
    try {
      final response = await apiService.get('students');
      List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => StudentData.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      // AppUtils.showSnackbar("Fetch students failed", e.toString(), isError: true);
      throw Exception("Fetch students failed: $e");
    }
  }
}
