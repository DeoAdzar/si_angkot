import 'package:get/get.dart';
import 'package:si_angkot/presentation/pages/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String student = '/student';
  static const String driver = '/driver';
  static const String parent = '/parent';

  static final List<GetPage> pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    // GetPage(name: login, page: () => LoginScreen()),
    // GetPage(name: student, page: () => StudentScreen()),
    // GetPage(name: driver, page: () => DriverScreen()),
    // GetPage(name: parent, page: () => ParentScreen()),
  ];
}