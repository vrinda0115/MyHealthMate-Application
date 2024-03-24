/* import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  void initialize() {
    try {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("FCM Message Received: ${message.notification?.title}");
        _logEvent(message);
      });
    } catch (e) {
      print("Error initializing Firebase Messaging: $e");
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    try {
      print("FCM Message Received (background): ${message.notification?.title}");
      _logEvent(message);
    } catch (e) {
      print("Error handling background message: $e");
    }
  }

  void _logEvent(RemoteMessage message) {
    try {
      _analytics.logEvent(name: 'message_received', parameters: {
        'title': message.notification?.title ?? '',
        'body': message.notification?.body ?? '',
      });
    } catch (e) {
      print("Error logging event: $e");
    }
  }
}
 */