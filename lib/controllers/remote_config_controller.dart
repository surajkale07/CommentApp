import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigController {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await _remoteConfig.setDefaults(<String, dynamic>{
      'show_full_email': false,  // Default value
    });
    await _remoteConfig.fetchAndActivate();
  }

  bool shouldShowFullEmail() {
    return _remoteConfig.getBool('show_full_email');
  }

  String maskEmail(String email, bool showFullEmail) {
    if (showFullEmail) {
      return email;
    } else {
      // Mask part of the email after the first 3 characters
      return email.replaceRange(3, email.indexOf('@'), '****');
    }
  }
}
