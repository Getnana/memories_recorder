import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// firebase_options.dart dari flutterfire configure
import 'firebase_options.dart';


// Tema
import 'theme.dart';

// Auth & Forgot Password
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/forgot_password_sent_screen.dart';

// Home & Memory
import 'screens/home/homepage_empty.dart';
import 'screens/home/homepage_list.dart';
import 'screens/home/draft_page.dart';
import 'screens/home/memory_single_page.dart';
import 'screens/home/create_update_memory_page.dart';

// Profile & Settings
import 'screens/profile/profile_page.dart';
import 'screens/profile/update_username_page.dart';
import 'screens/profile/update_email_page.dart';
import 'screens/profile/update_password_page.dart';
import 'screens/profile/delete_account_page.dart';  // Pastikan ini diimpor dengan benar
// AI
import 'screens/ai/ai_recommendation_page.dart';

// Notifikasi
import 'screens/notifications/notification_page.dart';

// Theme Settings
import 'screens/profile/theme_settings_page.dart';

//akses halaman tes database
import 'screens/test_database_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase (WAJIB)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memories Recorder',
      debugShowCheckedModeBanner: false,

      // Untuk sementara tema dibuat statis dulu
      theme: themeDataLight,
      darkTheme: themeDataDark,
      themeMode: ThemeMode.light,

      // STEP 1: selalu mulai dari halaman test database dulu
      initialRoute: '/login', //ganti ke /login klo mau mulai dari page login
      

      routes: {
        // Auth
        '/login': (context) => LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgotPassword': (context) => const ForgotPasswordScreen(),
        '/forgotPasswordSent': (context) => const ForgotPasswordSentScreen(),

        // Home & Memory
        '/homeEmpty': (context) => const HomePageEmpty(),
        '/homeList': (context) => const HomePageList(),
        '/draft': (context) => const DraftPage(),
        '/memoryDetail': (context) => const MemorySinglePage(),
        '/memoryCreate': (context) => const CreateUpdateMemoryPage(mode: CreateUpdateMode.create),
        '/memoryUpdate': (context) => const CreateUpdateMemoryPage(mode: CreateUpdateMode.update),

        // Profile & Settings
        '/profile': (context) => const ProfilePage(),
        '/updateUsername': (context) => const UpdateUsernamePage(),
        '/updateEmail': (context) => const UpdateEmailPage(),
        '/updatePassword': (context) => const UpdatePasswordPage(),
        '/deleteAccount': (context) => const DeleteAccountPage(),  // Rute untuk halaman penghapusan akun

        // AI
        '/aiRecommendation': (context) => const AIRecommendationPage(),

        // Notification
        '/notification': (context) => const NotificationPage(),

        // Theme settings
        '/themeSettings': (context) => const ThemeSettingsPage(),

        // Akses halaman tes database
        '/testDatabase': (context) => const TestDatabasePage(),  // Rute ke halaman tes database
      },
    );
  }
}
