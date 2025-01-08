import 'dart:io';
import 'package:critical_alert/sound.dart';
import 'package:do_not_disturb/do_not_disturb_plugin.dart';
import 'package:do_not_disturb/types.dart';

class CriticalNotificationManager {
  final dndPlugin = DoNotDisturbPlugin();

  void manageCriticalNotificationAccess() async {
    bool hasAccess = await dndPlugin.isNotificationPolicyAccessGranted();

    if (!hasAccess) {
    } else {
      final isDndEnabled = await dndPlugin.isDndEnabled();

      if (isDndEnabled) {
        await dndPlugin.setInterruptionFilter(InterruptionFilter.all);

        Future.delayed(const Duration(seconds: 5), () async {
          await dndPlugin.setInterruptionFilter(InterruptionFilter.none);
        });

        return;
      } else {
        if (Platform.isAndroid) {
          Sound().temporarilySwitchToNormalMode();
        }
      }
    }
  }
}
