// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:safe_alert_admin/admin_login.dart';
// import 'package:safe_alert_admin/firebase_options.dart';
// import 'package:safe_alert_admin/splash_screen.dart';
//
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await subscribeToCityTopic("Surat");
//   runApp(const MyApp());
// }
//
// Future<void> subscribeToCityTopic(String city) async {
//   FirebaseMessaging.instance.subscribeToTopic(city);
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home:const SplashScreen(),
//     );
//   }
// }
//

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:safe_alert_admin/firebase_options.dart';
import 'package:safe_alert_admin/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Awesome Notifications
  AwesomeNotifications().initialize(
    // set the icon to display on notifications (Android-specific)
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelKey: 'sos',
        channelName: 'sos',
        channelDescription: 'This channel is for SOS notifications.',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        enableVibration: true,
      )
    ],
  );

  // Request notification permissions (for iOS)
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });


  SharedPreferences sdf = await SharedPreferences.getInstance();
  String? city = sdf.getString("city");
  // Subscribe to Firebase Messaging topic
  await subscribeToCityTopic(city ?? "Surat");

  // Set up Firebase background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Listen for messages while app is in foreground
  FirebaseMessaging.onMessage.listen(_onMessageReceived);

  runApp(const MyApp());
}

Future<void> subscribeToCityTopic(String city) async {
  FirebaseMessaging.instance.subscribeToTopic(city);
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  if (message.notification != null) {
    _showNotification(message.notification!);
  }
}

// Method to handle foreground messages
void _onMessageReceived(RemoteMessage message) {
  print('Received a message while in the foreground: ${message.messageId}');
  if (message.notification != null) {
    _showNotification(message.notification!);
  }
}

// Method to show notification using Awesome Notifications
Future<void> _showNotification(RemoteNotification notification) async {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10, // Increment or use a unique ID
      channelKey: 'sos_channel',
      title: notification.title,
      body: notification.body,
      notificationLayout: NotificationLayout.Default,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safe Alert Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}



