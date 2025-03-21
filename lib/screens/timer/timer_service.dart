import 'dart:async';
import 'package:women_safety_app/services/location_service.dart';
import 'package:women_safety_app/services/notification_service.dart';
import 'package:women_safety_app/screens/timer/sos_handler.dart';

class TimerService {
  Timer? _timer;
  int _remainingSeconds = 0;
  Function? onTick;
  Function? onTimeout;
  Function? onPreTimeout;

  void startTimer(int seconds) {
    _remainingSeconds = seconds;
    LocationService.startTracking(); // Start GPS tracking

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _remainingSeconds--;

      if (onTick != null) onTick!(_remainingSeconds);

      // Notify user 10 minutes before timeout
      if (_remainingSeconds == 600) {
        NotificationService.showNotification("10 minutes left!", "Your timer is about to expire.");
        if (onPreTimeout != null) onPreTimeout!();
      }

      // If time is up, send SOS
      if (_remainingSeconds <= 0) {
        stopTimer();
        _sendSOS();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
  }

  void resumeTimer() {
    startTimer(_remainingSeconds);
  }

  void stopTimer() {
    _timer?.cancel();
    _remainingSeconds = 0;
    LocationService.stopTracking();
  }

  void _sendSOS() {
    NotificationService.showNotification("SOS Alert!", "Emergency alert sent!");
    SOSHandler.sendEmergencyAlert();
  }
}
