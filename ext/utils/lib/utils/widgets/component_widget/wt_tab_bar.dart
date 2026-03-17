import 'package:utils/utils.dart';

class TabBarModel {
  String tabName;
  Widget tabWidget;
  TabBarModel({
    required this.tabName,
    required this.tabWidget,
  });
}

class WtTabBar extends StatelessWidget {
  /// 탭 바
  ///
  /// Example:
  /// ```dart
  /// WtTabBar(
  ///   tabList: ['Wt Widget Sample', wt Utility Sample'],
  ///   pageList: [SampleWidgetPage1(), SampleWidgetPage2()],
  ///   initialIndex: 0,
  /// );
  /// ```
  ///
  /// See also:
  ///  * [tabList], 탭 명칭 목록
  ///  * [initialIndex], 탭 최초 호출시 선택할 페이지
  ///  * [showLine], 탭 라인 표시 여부
  ///  * [isScrollable], 탭 바 스크롤 여부(좌측정렬)
  ///  * [automaticKeep], 탭 상태유지 여부
  ///  * [automaticKeep], 탭 컨트롤러
  ///
  const WtTabBar({
    super.key,
    required this.tabList,
    this.initialIndex = 0,
    this.showLine = false,
    this.isScrollable = false,
    this.automaticKeepAlive = false,
    this.controller,
    this.useSwipeMode = false,
    this.height = 36,
    this.tabLeftPadding = 8,
    this.onTap,
  });

  /// 탭 목록
  final List<TabBarModel> tabList;

  /// 탭 최초 호출시 선택할 페이지
  final int initialIndex;

  /// 라인 표시 여부
  final bool showLine;

  /// 탭 바 스크롤 여부(좌측정렬)
  final bool isScrollable;

  /// 탭 상태유지 여부
  final bool automaticKeepAlive;

  /// 컨트롤러
  final TabController? controller;

  /// 바디부분
  final bool useSwipeMode;

  /// 높이
  final double height;

  /// 탭 좌측 패딩
  final double tabLeftPadding;

  /// 클릭 이벤트
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex,
      length: tabList.length,
      child: Column(
        children: [
          Stack(
            children: [
              //TabBar 리스트 Divider stack
              showLine
                  ? Positioned.fill(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: WtColors.gray4,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              //TabBar 리스트 Divider stack
              Container(
                  width: double.infinity,
                  height: 48,
                  padding: EdgeInsets.only(left: tabLeftPadding),
                  child: RatioTabBar(
                      isScrollable: isScrollable,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: WtColors.primaryContainer,
                      indicatorWeight: 2.0,
                      unselectedLabelColor: WtColors.gray3,
                      unselectedLabelStyle: WtTextStyle.titleMedium,
                      labelColor: WtColors.primaryContainer,
                      labelStyle: WtTextStyle.titleMedium,
                      // indicatorPadding: EdgeInsets.symmetric(horizontal: -8),
                      controller: controller,
                      onTap: onTap,
                      tabs: tabList.map((tabBarModel) => _getTab(tabBarModel.tabName, height)).toList())),
            ],
          ),
          Expanded(
              child: TabBarView(
                      controller: controller,
                      physics: useSwipeMode ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
                      children: tabList.map((tabBarModel) {
                        return automaticKeepAlive
                            ? AutomaticKeepAliveScreen(
                                child: tabBarModel.tabWidget,
                              )
                            : tabBarModel.tabWidget;
                      }).toList())
                  .scrollEffectOff()),
        ],
      ),
    );
  }

  Widget _getTab(String text, double height) {
    return Tab(
      height: height,
      child: Text(text),
    );
  }
}

class RatioTabBar extends TabBar {
  const RatioTabBar({
    super.key,
    required List<Widget> tabs,
    TabController? controller,
    bool isScrollable = false,
    EdgeInsetsGeometry? padding,
    Color? indicatorColor,
    bool automaticIndicatorColorAdjustment = true,
    double? indicatorWeight,
    EdgeInsetsGeometry indicatorPadding = EdgeInsets.zero,
    Decoration? indicator,
    TabBarIndicatorSize? indicatorSize,
    Color? labelColor,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? labelPadding,
    Color? unselectedLabelColor,
    TextStyle? unselectedLabelStyle,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    MaterialStateProperty<Color?>? overlayColor,
    MouseCursor? mouseCursor,
    bool? enableFeedback,
    ValueChanged<int>? onTap,
    ScrollPhysics? physics,
    this.height,
  }) : super(
          tabs: tabs,
          controller: controller,
          isScrollable: isScrollable,
          padding: padding,
          indicatorColor: indicatorColor,
          automaticIndicatorColorAdjustment: automaticIndicatorColorAdjustment,
          indicatorWeight: indicatorWeight ?? 2.0,
          indicatorPadding: indicatorPadding,
          indicator: indicator,
          indicatorSize: indicatorSize,
          labelColor: labelColor,
          labelStyle: labelStyle,
          labelPadding: labelPadding ?? const EdgeInsets.symmetric(horizontal: 8.0),
          unselectedLabelColor: unselectedLabelColor,
          unselectedLabelStyle: unselectedLabelStyle,
          dragStartBehavior: dragStartBehavior,
          overlayColor: overlayColor,
          mouseCursor: mouseCursor,
          enableFeedback: enableFeedback,
          onTap: onTap,
          physics: physics,
        );

  final double? height;

  @override
  Size get preferredSize {
    if (height != null) {
      return Size.fromHeight(height!);
    } else {
      return const Size.fromHeight(46.0);
    }
  }
}

class WtTabBarOnly extends StatelessWidget {
  /// 탭 바
  ///
  /// Example:
  /// ```dart
  /// WtTabBar(
  ///   tabList: ['Wt Widget Sample', wt Utility Sample'],
  ///   pageList: [SampleWidgetPage1(), SampleWidgetPage2()],
  ///   initialIndex: 0,
  /// );
  /// ```
  ///
  /// See also:
  ///  * [tabList], 탭 명칭 목록
  ///  * [initialIndex], 탭 최초 호출시 선택할 페이지
  ///  * [showLine], 탭 라인 표시 여부
  ///  * [isScrollable], 탭 바 스크롤 여부(좌측정렬)
  ///  * [automaticKeep], 탭 상태유지 여부
  ///  * [automaticKeep], 탭 컨트롤러
  ///
  const WtTabBarOnly({
    super.key,
    required this.tabList,
    this.initialIndex = 0,
    this.showLine = false,
    this.isScrollable = false,
    this.automaticKeepAlive = false,
    this.controller,
    this.useSwipeMode = false,
    this.height = 36,
    this.tabLeftPadding = 8,
    this.onTap,
  });

  /// 탭 목록
  final List<String> tabList;

  /// 탭 최초 호출시 선택할 페이지
  final int initialIndex;

  /// 라인 표시 여부
  final bool showLine;

  /// 탭 바 스크롤 여부(좌측정렬)
  final bool isScrollable;

  /// 탭 상태유지 여부
  final bool automaticKeepAlive;

  /// 컨트롤러
  final TabController? controller;

  /// 바디부분
  final bool useSwipeMode;

  /// 높이
  final double height;

  /// 탭 좌측 패딩
  final double tabLeftPadding;

  /// 클릭 이벤트
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //TabBar 리스트 Divider stack
        showLine
            ? Positioned.fill(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: WtColors.gray4,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        //TabBar 리스트 Divider stack
        Container(
            width: double.infinity,
            height: 48,
            padding: EdgeInsets.only(left: tabLeftPadding),
            child: RatioTabBar(
                isScrollable: isScrollable,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: WtColors.primaryContainer,
                indicatorWeight: 2.0,
                unselectedLabelColor: WtColors.gray3,
                unselectedLabelStyle: WtTextStyle.titleMedium,
                labelColor: WtColors.primaryContainer,
                labelStyle: WtTextStyle.titleMedium,
                // indicatorPadding: EdgeInsets.symmetric(horizontal: -8),
                controller: controller,
                onTap: onTap,
                tabs: tabList
                    .map((e) => Tab(
                          height: height,
                          child: Text(e),
                        ))
                    .toList())),
      ],
    );
  }
}
