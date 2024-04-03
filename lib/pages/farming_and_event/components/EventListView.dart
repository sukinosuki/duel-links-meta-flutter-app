import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/http/ArticleApi.dart';
import 'package:duel_links_meta/pages/articles/components/ArticleItem.dart';
import 'package:duel_links_meta/pages/farming_and_event/type/TabType.dart';
import 'package:duel_links_meta/type/Article.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/listViewData.dart';
import 'package:flutter/material.dart';

import '../../../components/ListFooter.dart';
import '../../../util/index.dart';
import '../../webview/index.dart';

class EventListView extends StatefulWidget {
  const EventListView({super.key, required this.type});

  final TabType type;

  @override
  State<EventListView> createState() => _EventListViewState();
}

class _EventListViewState extends State<EventListView> with AutomaticKeepAliveClientMixin {

  TabType get type => widget.type;

  final ScrollController _scrollController = ScrollController();

  final _listViewData = ListViewData<Article>();

  List<Article> get _articles => _listViewData.data;

  //
  handleTapArticleItem(Article article) {
    var title = article.title;
    var url = 'https://www.duellinksmeta.com/articles${article.url}';

    Navigator.push(context, MaterialPageRoute(builder: (context) => WebviewPage(title: title, url: url)));
  }

  //
  fetchData({bool isLoadMore = false}) async {
    Exception? err;
    List<dynamic>? res;

    if (type == TabType.active) {
      (err, res) = await Util.toCatch(ArticleApi().activeEventLst(DateTime.now()));
    }
    if (type == TabType.past) {
      (err, res) = await Util.toCatch(ArticleApi().pastEventLst(DateTime.now(), _listViewData.page));
    }
    if (type == TabType.general) {
      (err, res) = await Util.toCatch(ArticleApi().pinnedFarmingEvent());
    }

    if (err != null) {
      if (isLoadMore) {
        setState(() {
          _listViewData.loadMoreStatus = PageStatus.fail;
        });
      } else {

        setState(() {
          _listViewData.pageStatus = PageStatus.fail;
        });
      }
      return;
    }

    var list = res!.map((e) => Article.fromJson(e)).toList();

    _listViewData.page += 1;

    setState(() {
      _listViewData.data.addAll(list);
      _listViewData.hasMore = list.length == _listViewData.size;
      _listViewData.loadMoreStatus = PageStatus.success;
      _listViewData.pageStatus = PageStatus.success;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  initScrollReachBottomListener() {
    _scrollController.addListener(() {
      if (_listViewData.pageStatus != PageStatus.success) {
        print('页面未加载完成不可以加载更多');

        return;
      }

      if (_listViewData.hasMore && Util.isReachBottom(_scrollController)) {
        if (_listViewData.loadMoreStatus == PageStatus.loading) {
          print('到达底部，是加载更多中，不可执行 _loadMoreStatus ${_listViewData.loadMoreStatus}, ${PageStatus.loading}');
          return;
        }
        setState(() {
          _listViewData.loadMoreStatus = PageStatus.loading;
        });

        fetchData(isLoadMore: true);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    initScrollReachBottomListener();
    fetchData();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _listViewData.pageStatus == PageStatus.success ? 1 : 0,
          duration: const Duration(milliseconds: 400),
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            itemCount: _articles.length >= _listViewData.size ? _articles.length + 1 : _articles.length,
            itemBuilder: (context, index) {
              return _articles.length >= _listViewData.size && index == _articles.length
                  ? ListFooter(loadMoreStatus: _listViewData.loadMoreStatus, hasMore: _listViewData.hasMore)
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
        if (_listViewData.pageStatus == PageStatus.loading)
          const Positioned.fill(
            child: Center(
              child: Loading(),
            ),
          ),
      ],
    );
  }
}
