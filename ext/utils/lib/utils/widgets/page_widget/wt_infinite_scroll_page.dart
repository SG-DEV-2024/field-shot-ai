import 'package:utils/utils.dart';

class WtInfiniteScrollPage extends StatefulWidget {
  const WtInfiniteScrollPage({
    super.key,

    /// 새로 로딩할 페이지 카운트
    this.pageCount = 10,

    /// 검색 최대 카운트
    this.maxCount = 30,

    /// 호출할 API
    required this.api,

    /// 아이템 빌더
    required this.itemBuilder,
  });

  final int pageCount;
  final int maxCount;
  final Future<List<dynamic>> Function(int page, int pageCount) api;
  final Widget Function(BuildContext context, int count, dynamic result) itemBuilder;

  @override
  WtInfiniteScrollPageState createState() => WtInfiniteScrollPageState();
}

class WtInfiniteScrollPageState extends State<WtInfiniteScrollPage> {
  ScrollController scrollController = ScrollController();

  /// 페이지
  int page = 1;

  /// 데이터
  List<dynamic> data = [];

  /// 로딩여부
  bool isLoading = false;

  /// 추가 호출 여부
  bool hasMore = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    // scrollController.offset >= scrollController.position.maxScrollExtent * 0.7
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && hasMore) {
        if (!isLoading) {
          _loadData();
        }
      }
    });
  }

  /// API호출부분
  _loadData() async {
    // show loading
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));

    // call API
    List<dynamic> appendData = await widget.api(page, widget.pageCount);
    page += 1;

    // data input
    setState(() {
      data.addAll(appendData);
      isLoading = false;
      hasMore = data.length < widget.maxCount;
    });
  }

  /// 새로고침
  _refresh() async {
    setState(() {
      isLoading = true;
      data.clear();
    });
    await Future.delayed(const Duration(seconds: 2));
    _loadData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: WtIconButton(
          icon: WtIcons.close,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sizedBox8,
          WtTitle.size24('예식장 위치를 등록해주세요'),
          sizedBox40,
          const WtTextFormField(
            decoration: InputDecoration(hintText: '텍스트'),
            isClearButton: false,
          ),
          Expanded(
            child: WtListView.separated(
              blankSize: 16,
              controller: scrollController,
              itemBuilder: (_, index) {
                if (index < data.length) {
                  return widget.itemBuilder(context, index, data[index]);
                }
                if (isLoading) {
                  return const Center(child: RefreshProgressIndicator());
                }
                if (hasMore) {
                  return const SizedBox.shrink();
                } else {
                  return Center(
                    child: Column(
                      children: [
                        const Text('데이터의 마지막 입니다'),
                        IconButton(
                          onPressed: () {
                            _refresh();
                          },
                          icon: const Icon(Icons.refresh_outlined),
                        ),
                      ],
                    ),
                  );
                }
              },
              separatorBuilder: (_, index) => const Divider(),
              itemCount: data.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}
