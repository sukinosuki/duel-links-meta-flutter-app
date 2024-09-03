import 'dart:developer';

import 'package:duel_links_meta/components/ListFooter.dart';
import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/http/ArticleApi.dart';
import 'package:duel_links_meta/pages/articles/components/ArticleItem.dart';
import 'package:duel_links_meta/pages/webview/index.dart';
import 'package:duel_links_meta/type/Article.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/type/listViewData.dart';
import 'package:flutter/material.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> with AutomaticKeepAliveClientMixin {

  final ScrollController _scrollController = ScrollController();

  final _listViewData = ListViewData<Article>();

  List<Article> get _articles => _listViewData.data;

  void handleTapArticleItem(Article article) {
    final title = article.title;
    final url = 'https://www.duellinksmeta.com/articles${article.url}';

    Navigator.push(context, MaterialPageRoute<void>(builder: (context) => WebviewPage(title: title, url: url)));
  }

  //
  Future<void> fetchData({bool isLoadMore = false}) async {
    final params = <String, String>{};
    params['limit'] = _listViewData.size.toString();
    params['page'] = _listViewData.page.toString();

    final (err, res) = await ArticleApi().articleList(params).toCatch;
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
    }
    final list = res!.map(Article.fromJson).toList();

    _listViewData.page += 1;
    setState(() {
      _listViewData.data.addAll(list);
      _listViewData..pageStatus = PageStatus.success
      ..hasMore = list.length == _listViewData.size
      ..loadMoreStatus = PageStatus.success;
    });
  }

  bool isReachBottom() {
    log('bottom: ${_scrollController.position.maxScrollExtent - _scrollController.position.pixels}');
    return _scrollController.position.maxScrollExtent - _scrollController.position.pixels <= 200;
  }

  void initScrollReachBottomListener() {
    _scrollController.addListener(() {
      log('滚动中。。。');
      if (_listViewData.pageStatus != PageStatus.success) {
        log('不是加载成功，return');
        return;
      }

      if (_listViewData.hasMore && isReachBottom()) {
        log('hasMore && 到达底部');
        if (_listViewData.loadMoreStatus == PageStatus.loading) {
          log('到达底部，是加载更多中，不可执行 _loadMoreStatus ${_listViewData.loadMoreStatus}, ${PageStatus.loading}');
          return;
        }
        setState(() {
          _listViewData.loadMoreStatus = PageStatus.loading;
        });

        fetchData(isLoadMore: true);
      } else{
        log('没有更多或者没到达底部');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    initScrollReachBottomListener();
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
      body: Stack(
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
                            : ArticleItem(article: _articles[index], onTap: handleTapArticleItem)),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 8);
              },
            ),
          ),
          if (_listViewData.pageStatus != PageStatus.success) const Positioned.fill(child: Center(child: Loading())),
        ],
      ),
    );
  }
}
