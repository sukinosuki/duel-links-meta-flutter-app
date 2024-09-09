import 'dart:developer';

import 'package:duel_links_meta/api/ArticleApi.dart';
import 'package:duel_links_meta/components/ListFooter.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/hive/db/ArticleHiveDb.dart';
import 'package:duel_links_meta/pages/articles/components/ArticleItem.dart';
import 'package:duel_links_meta/pages/webview/index.dart';
import 'package:duel_links_meta/type/Article.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/listViewData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  final _listViewData = ListViewData<Article>();

  final _refreshIndicator = GlobalKey<RefreshIndicatorState>();

  List<Article> get _articles => _listViewData.data;

  void handleTapArticleItem(Article article) {
    final title = article.title;
    final url = 'https://www.duellinksmeta.com/articles${article.url}';

    Navigator.push(context, MaterialPageRoute<void>(builder: (context) => WebviewPage(title: title, url: url)));
  }

  Future<void> fetchData({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      final list = await ArticleHiveDb().get('');
      if (list != null) {
        setState(() {
          _listViewData
            ..data = list
            ..pageStatus = PageStatus.success;
        });
      }
    }

    final params = <String, String>{
      'limit': _listViewData.size.toString(),
      'page': _listViewData.page.toString(),
    };
    params['field'] = '-markdown';
    params['sort'] = '-featured,-date';
    params[r'hidden[$ne]'] = 'true';
    params[r'category[$ne]'] = 'quick-news';

    final (err, list) = await ArticleApi().articleList(params).toCatch;
    if (err != null || list == null) {
      if (isLoadMore) {
        setState(() {
          _listViewData.loadMoreStatus = PageStatus.fail;
        });
      } else {
        if (_listViewData.data.isEmpty) {
          setState(() {
            _listViewData.pageStatus = PageStatus.fail;
          });
        }
      }
      return;
    }

    _listViewData.page += 1;
    if (isLoadMore) {
      setState(() {
        _listViewData.data.addAll(list);
      });
    } else {
      setState(() {
        _listViewData.data = list;
      });

      ArticleHiveDb().set(list, '').ignore();
    }

    setState(() {
      _listViewData
        ..pageStatus = PageStatus.success
        ..hasMore = list.length == _listViewData.size
        ..loadMoreStatus = PageStatus.success;
    });
  }

  bool isReachBottom() {
    return _scrollController.position.maxScrollExtent - _scrollController.position.pixels <= 200;
  }

  void initScrollReachBottomListener() {
    _scrollController.addListener(() {
      if (_listViewData.pageStatus != PageStatus.success) {
        return;
      }

      if (!_listViewData.hasMore || !isReachBottom()) {
        return;
      }

      if (_listViewData.loadMoreStatus == PageStatus.loading || _listViewData.loadMoreStatus == PageStatus.fail) {
        return;
      }

      setState(() {
        _listViewData.loadMoreStatus = PageStatus.loading;
      });

      fetchData(isLoadMore: true);
    });
  }

  Future<void> _handleRefresh() async {
    _listViewData.page = 1;
    await fetchData();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
      ),
      body: RefreshIndicator(
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
                padding: const EdgeInsets.only(top: 8),
                itemCount: _articles.length >= _listViewData.size ? _articles.length + 1 : _articles.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: _articles.length >= _listViewData.size && index == _articles.length
                            ? ListFooter(loadMoreStatus: _listViewData.loadMoreStatus, hasMore: _listViewData.hasMore)
                            : ArticleItem(article: _articles[index], onTap: handleTapArticleItem),
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 8);
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
      ),
    );
  }
}
