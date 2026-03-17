// ignore_for_file: constant_identifier_names, use_key_in_widget_constructors

import 'package:utils/utils.dart';

enum LoadingType {
  CircularProgressIndicator,
  Shimmer_40_2,
  Shimmer_48_2,
}

class WtLoadingView extends StatefulWidget {
  WtLoadingView({
    this.shrinkWrap = false,
  }) {
    loadingType = LoadingType.CircularProgressIndicator;
  }

  WtLoadingView.shimmer40({
    this.shrinkWrap = false,
  }) {
    loadingType = LoadingType.Shimmer_40_2;
  }

  WtLoadingView.shimmer48({
    this.shrinkWrap = false,
  }) {
    loadingType = LoadingType.Shimmer_48_2;
  }

  /// 로딩뷰 로딩타입
  late final LoadingType loadingType;

  /// 스크롤 내부에 사용 true, 아닌경우 false
  final bool shrinkWrap;

  @override
  WtLoadingViewState createState() => WtLoadingViewState();
}

class WtLoadingViewState extends State<WtLoadingView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
      ),
    );
  }
}
