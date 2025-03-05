import 'package:get/get.dart';
import 'package:si_angkot/presentation/pages/auth/register_screen.dart';
import 'package:si_angkot/presentation/pages/auth/login_screen.dart';
import 'package:si_angkot/presentation/pages/driver/driver_home_screen.dart';
import 'package:si_angkot/presentation/pages/parent/parent_home_screen.dart';
import 'package:si_angkot/presentation/pages/parent/register_student_screen.dart';
import 'package:si_angkot/presentation/pages/splash_screen.dart';
import 'package:si_angkot/presentation/pages/student/student_home_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String baseRegister = '/base-register';
  static const String student = '/student-home';
  static const String driver = '/driver-home';
  static const String parent = '/parent-home';
  static const String parentFormRegister = '/parent-form-register';

  static final List<GetPage> pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: baseRegister, page: () => RegisterScreen()),

    //student
    GetPage(name: student, page: () => StudentHomeScreen()),

    //Driver
    GetPage(name: driver, page: () => DriverHomeScreen()),

    //Parent
    GetPage(name: parent, page: () => ParentHomeScreen()),
    GetPage(name: parentFormRegister, page: () => RegisterStudentScreen()),
  ];
}
