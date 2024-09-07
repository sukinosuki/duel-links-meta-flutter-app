import 'package:duel_links_meta/api/ArticleApi.dart';
import 'package:duel_links_meta/components/ListFooter.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/db/ArticleHiveDb.dart';
import 'package:duel_links_meta/pages/articles/components/ArticleItem.dart';
import 'package:duel_links_meta/pages/farming_and_event/type/TabType.dart';
import 'package:duel_links_meta/pages/webview/index.dart';
import 'package:duel_links_meta/type/Article.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/listViewData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class EventListView extends StatefulWidget {
  const EventListView({required this.type, super.key});

  final TabType type;

  @override
  State<EventListView> createState() => _EventListViewState();
}

class _EventListViewState extends State<EventListView> with AutomaticKeepAliveClientMixin {
  TabType get _type => widget.type;
  final ScrollController _scrollController = ScrollController();

  List<Article> get _articles => _listViewData.data;
  final _listViewData = ListViewData<Article>();
  var _isInit = false;
  final _refreshIndicator = GlobalKey<RefreshIndicatorState>();

  //
  void handleTapArticleItem(Article article) {
    final title = article.title;
    final url = 'https://www.duellinksmeta.com/articles${article.url}';

    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => WebviewPage(title: title, url: url)),
    );
  }

  Future<void> loadMore() async {
    List<Article>? articles;
    Exception? err;

    if (_type == TabType.active) {
      (err, articles) = await ArticleApi().activeEventLst(DateTime.now()).toCatch;
    } else if (_type == TabType.past) {
      (err, articles) = await ArticleApi().pastEventLst(DateTime.now(), _listViewData.page).toCatch;
    } else if (_type == TabType.general) {
      (err, articles) = await ArticleApi().pinnedFarmingEvent().toCatch;
    }

    if (err != null || articles == null) {
      setState(() {
        _listViewData.loadMoreStatus = PageStatus.fail;
      });

      return;
    }

    setState(() {
      _listViewData.data.addAll(articles!);
      _listViewData.loadMoreStatus = PageStatus.success;
      _listViewData.page++;
      _listViewData.hasMore = articles.length == _listViewData.size;
    });
  }

  //
  Future<void> fetchData({bool force = false}) async {
    var articles = await ArticleHiveDb().get(_type.toString());
    final expireTime = await ArticleHiveDb().getExpireTime(_type.toString());

    Exception? err;

    if (articles != null) {
      setState(() {
        _listViewData
          ..data = articles!
          ..pageStatus = PageStatus.success;
      });
    }

    if (force || expireTime == null || expireTime.isBefore(DateTime.now())) {
      if (_type == TabType.active) {
        (err, articles) = await ArticleApi().activeEventLst(DateTime.now()).toCatch;
      } else if (_type == TabType.past) {
        (err, articles) = await ArticleApi().pastEventLst(DateTime.now(), _listViewData.page).toCatch;
      } else if (_type == TabType.general) {
        (err, articles) = await ArticleApi().pinnedFarmingEvent().toCatch;
      }

      if (err != null || articles == null) {
        setState(() {
          _listViewData.pageStatus = PageStatus.fail;
        });
        return;
      }

      await ArticleHiveDb().set(articles, _type.toString());
      await ArticleHiveDb().setExpireTime(DateTime.now().add(const Duration(days: 1)), _type.toString());
    }

    _listViewData.page += 1;

    setState(() {
      _listViewData
        ..data = articles!
        ..pageStatus = PageStatus.success
        ..hasMore = articles.length == _listViewData.size;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  bool isReachBottom() {
    return _scrollController.position.maxScrollExtent - _scrollController.position.pixels <= 200;
  }

  void initScrollReachBottomListener() {
    _scrollController.addListener(() {
      if (_listViewData.pageStatus != PageStatus.success) {
        return;
      }

      if (!_listViewData.hasMore || _listViewData.loadMoreStatus == PageStatus.loading || isReachBottom()) {
        return;
      }

      setState(() {
        _listViewData.loadMoreStatus = PageStatus.loading;
      });

      loadMore();
    });
  }

  Future<void> _handleRefresh() async {
    _listViewData.page = 1;
    await fetchData(force: _isInit);
    _isInit = true;
  }

  void init() {
    initScrollReachBottomListener();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshIndicator.currentState?.show();
    });
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      key: _refreshIndicator,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedOpacity(
            opacity: _listViewData.pageStatus == PageStatus.success ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              itemCount: _articles.length >= _listViewData.size ? _articles.length + 1 : _articles.length,
              itemBuilder: (context, index) {
                return _articles.length >= _listViewData.size && index == _articles.length
                    ? ListFooter(
                        loadMoreStatus: _listViewData.loadMoreStatus,
                        hasMore: _listViewData.hasMore,
                      )
                    : ArticleItem(
                        article: _articles[index],
                        onTap: handleTapArticleItem,
                      );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
            ),
          ),
          if (_listViewData.pageStatus == PageStatus.fail)
            const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
            ),
          if (_listViewData.pageStatus == PageStatus.fail)
            const Center(
              child: Text('Loading failed'),
            ),
        ],
      ),
    );
  }
}
