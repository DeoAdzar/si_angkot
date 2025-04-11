import 'package:get/get.dart';
import 'package:si_angkot/presentation/pages/auth/register_screen.dart';
import 'package:si_angkot/presentation/pages/auth/login_screen.dart';
import 'package:si_angkot/presentation/pages/driver/driver_home_screen.dart';
import 'package:si_angkot/presentation/pages/driver/main/main_scan_view.dart';
import 'package:si_angkot/presentation/pages/parent/parent_home_screen.dart';
import 'package:si_angkot/presentation/pages/parent/parent_settings_screen.dart';
import 'package:si_angkot/presentation/pages/parent/register_student_screen.dart';
import 'package:si_angkot/presentation/pages/splash_screen.dart';
import 'package:si_angkot/presentation/pages/student/student_home_screen.dart';
import 'package:si_angkot/presentation/pages/student/student_pending_screen.dart';
import 'package:si_angkot/presentation/pages/student/student_settings_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String baseRegister = '/base-register';
  static const String student = '/student-home';
  static const String studentPending = '/student-pending';
  static const String studentSetting = '/student-setting';
  static const String driver = '/driver-home';
  static const String parent = '/parent-home';
  static const String parentSetting = '/parent-setting';
  static const String parentFormRegister = '/parent-form-register';
  static const String driverBaseScan = '/driver-base-scan';

  static final List<GetPage> pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: baseRegister, page: () => RegisterScreen()),

    //student
    GetPage(name: student, page: () => StudentHomeScreen()),
    GetPage(name: studentSetting, page: () => StudentSettingScreen()),
    GetPage(name: studentPending, page: () => StudentPendingScreen()),

    //Driver
    GetPage(name: driver, page: () => DriverHomeScreen()),
    GetPage(name: driverBaseScan, page: () => MainScanView()),

    //Parent
    GetPage(name: parent, page: () => ParentHomeScreen()),
    GetPage(name: parentSetting, page: () => ParentSettingsScreen()),
    GetPage(name: parentFormRegister, page: () => RegisterStudentScreen()),
  ];
}
