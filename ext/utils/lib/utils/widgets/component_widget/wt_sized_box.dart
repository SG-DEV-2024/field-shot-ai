import 'package:utils/utils.dart';

SizedBox sizedBoxN(double size) => SizedBox(width: size, height: size);
SizedBox get sizedBox0 => const SizedBox.shrink();
SizedBox get sizedBox2 => const SizedBox(width: 2, height: 2);
SizedBox get sizedBox4 => const SizedBox(width: 4, height: 4);
SizedBox get sizedBox6 => const SizedBox(width: 6, height: 6);
SizedBox get sizedBox8 => const SizedBox(width: 8, height: 8);
SizedBox get sizedBox10 => const SizedBox(width: 10, height: 10);
SizedBox get sizedBox12 => const SizedBox(width: 12, height: 12);
SizedBox get sizedBox16 => const SizedBox(width: 16, height: 16);
SizedBox get sizedBox20 => const SizedBox(width: 20, height: 20);
SizedBox get sizedBox24 => const SizedBox(width: 24, height: 24);
SizedBox get sizedBox28 => const SizedBox(width: 28, height: 28);
SizedBox get sizedBox32 => const SizedBox(width: 32, height: 32);
SizedBox get sizedBox36 => const SizedBox(width: 36, height: 36);
SizedBox get sizedBox40 => const SizedBox(width: 40, height: 40);
SizedBox get sizedBox48 => const SizedBox(width: 48, height: 48);
SizedBox get sizedBox16safe => SizedBox(height: 16 + safeAreaBottom);
SizedBox get sizedBox24safe => SizedBox(height: 24 + safeAreaBottom);
Container get filledBox16 => Container(color: WtColors.background, width: double.infinity, height: 16);
Container get filledBox24 => Container(color: WtColors.background, width: double.infinity, height: 24);
Container get filledBox32 => Container(color: WtColors.background, width: double.infinity, height: 32);
Container get filledBox40 => Container(color: WtColors.background, width: double.infinity, height: 40);
SizedBox get sizedBox0test {
  log.info('sizedBox0test');
  return const SizedBox.shrink();
}
