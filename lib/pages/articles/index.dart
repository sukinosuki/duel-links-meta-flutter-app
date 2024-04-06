import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/components/ListFooter.dart';
import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/constant/colors.dart';
import 'package:duel_links_meta/extension/Function.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/http/ArticleApi.dart';
import 'package:duel_links_meta/pages/articles/components/ArticleItem.dart';
import 'package:duel_links_meta/pages/webview/index.dart';
import 'package:duel_links_meta/type/Article.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:duel_links_meta/util/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../type/listViewData.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> with AutomaticKeepAliveClientMixin {
  // List<Article> _articles = [];

  final ScrollController _scrollController = ScrollController();

  // var _page = 1;
  // final _size = 8;
  // var _pageStatus = PageStatus.loading;
  // var _loadMoreStatus = PageStatus.success;
  // var _hasMore = true;

  final _listViewData = ListViewData<Article>();

  List<Article> get _articles => _listViewData.data;

  handleTapArticleItem(Article article) {
    var title = article.title;
    var url = 'https://www.duellinksmeta.com/articles${article.url}';

    Navigator.push(context, MaterialPageRoute(builder: (context) => WebviewPage(title: title, url: url)));
  }

  //
  fetchData({bool isLoadMore = false}) async {
    var params = <String, String>{};
    params['limit'] = _listViewData.size.toString();
    params['page'] = _listViewData.page.toString();

    var (err, res) = await ArticleApi().articleList(params).toCatch;
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
    var list = res!.map((e) => Article.fromJson(e)).toList();

    _listViewData.page += 1;
    setState(() {
      _listViewData.data.addAll(list);
      _listViewData.pageStatus = PageStatus.success;
      _listViewData.hasMore = list.length == _listViewData.size;
      _listViewData.loadMoreStatus = PageStatus.success;
    });
  }

  bool isReachBottom() {
    log('bottom: ${_scrollController.position.maxScrollExtent - _scrollController.position.pixels}');
    return _scrollController.position.maxScrollExtent - _scrollController.position.pixels <= 200;
  }

  initScrollReachBottomListener() {
       var fn = () {
      log('滚动中。。。');
      if (_listViewData.pageStatus != PageStatus.success) {
        log('不是加载成功，return');
        return;
      }

      if (_listViewData.hasMore && isReachBottom()) {
        log('hasMore && 到达底部');
        if (_listViewData.loadMoreStatus == PageStatus.loading) {
          print('到达底部，是加载更多中，不可执行 _loadMoreStatus ${_listViewData.loadMoreStatus}, ${PageStatus.loading}');
          return;
        }
        setState(() {
          _listViewData.loadMoreStatus = PageStatus.loading;
        });

        fetchData(isLoadMore: true);
      } else{
        log('没有更多或者没到达底部');
      }
    }.throttle(1000);

    _scrollController.addListener(fn);
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
        title: const Text("Articles"),
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
