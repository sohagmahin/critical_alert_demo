import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

class Sound {
  void temporarilySwitchToNormalMode() async {
    RingerModeStatus ringerStatus = await SoundMode.ringerModeStatus;
    if (ringerStatus == RingerModeStatus.silent) {
      await SoundMode.setSoundMode(RingerModeStatus.normal);
      Future.delayed(const Duration(seconds: 5), () async {
        await SoundMode.setSoundMode(ringerStatus);
      });
    }
  }
}
