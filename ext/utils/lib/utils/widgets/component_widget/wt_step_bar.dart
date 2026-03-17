import 'package:utils/utils.dart';

class WtStepBar extends StatelessWidget {
  const WtStepBar({
    Key? key,
    required this.leftTabText,
    required this.centerTabText,
    required this.rightTabText,
    required this.currentStep,
    this.height = 40,
  }) : super(key: key);

  /// 좌측 탭 명
  final String leftTabText;

  /// 중앙 탭 명
  final String centerTabText;

  /// 우측 탭 명
  final String rightTabText;

  /// 탭 단계(1,2,3단계)
  final int currentStep;

  /// 탭 높이(기본 40)
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          double width = (boxConstraints.maxWidth) * 1 / 3 + 5;
          return Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ClipPath(
                    clipper: ClipperLeftButton(),
                    child: currentStep == 1 ? buildOnButton(width, leftTabText) : buildOffButton(width, leftTabText),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: ClipPath(
                    clipper: ClipperCenterButton(),
                    child:
                        currentStep == 2 ? buildOnButton(width, centerTabText) : buildOffButton(width, centerTabText),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ClipPath(
                    clipper: ClipperRightButton(),
                    child: currentStep == 3 ? buildOnButton(width, rightTabText) : buildOffButton(width, rightTabText),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Container buildOnButton(double width, String tabText) {
  return Container(
    width: width,
    color: WtColors.primaryContainer,
    child: Center(
      child: Text(
        tabText,
        style: WtTextStyle.bodyMedium.back,
      ),
    ),
  );
}

Container buildOffButton(double width, String tabText) {
  return Container(
    width: width,
    color: WtColors.gray4,
    child: Center(
      child: Text(
        tabText,
        style: WtTextStyle.bodyMedium.onBack,
      ),
    ),
  );
}

class ClipperLeftButton extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 8, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 8, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class ClipperCenterButton extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 8, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 8, size.height);
    path.lineTo(0, size.height);
    path.lineTo(8, size.height / 2);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class ClipperRightButton extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(8, size.height / 2);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
