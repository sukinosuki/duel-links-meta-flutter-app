import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/components/ListFooter.dart';
import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/constant/colors.dart';
import 'package:duel_links_meta/http/ArticleApi.dart';
import 'package:duel_links_meta/pages/articles/components/ArticleItem.dart';
import 'package:duel_links_meta/pages/webview/index.dart';
import 'package:duel_links_meta/type/Article.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> with AutomaticKeepAliveClientMixin {
  List<Article> _articles = [];
  final format = DateFormat.yMMMMd();

  final ScrollController _scrollController = ScrollController();
  var _page = 1;
  final _size = 8;
  var _pageStatus = PageStatus.loading;
  var _loadMoreStatus = PageStatus.success;
  var _hasMore = true;

  _handleTapArticleItem(Article article) {
    var title = article.title;
    var url = 'https://www.duellinksmeta.com/articles${article.url}';

    print('url $url');
    Navigator.push(context, MaterialPageRoute(builder: (context) => WebviewPage(title: title, url: url)));
  }

  //
  fetchData({bool isLoadMore = false}) async {
    var params = <String, String>{};
    params['limit'] = _size.toString();
    params['page'] = _page.toString();
    // params['field'] = '-markdown';
    // params['sort'] = '-featured,-date';
    // params['hidden[\$ne]'] = 'true';
    // params['category[\$ne]'] = 'quick-news';
    var res = await ArticleApi().list(params);
    var list = res.body?.map((e) => Article.fromJson(e)).toList() ?? [];

    print("list 1 $list");

    _page += 1;
    setState(() {
      _articles = _articles..addAll(list);
      _pageStatus = PageStatus.success;
      _hasMore = list.length == _size;
      _loadMoreStatus = PageStatus.success;
    });
  }

  bool isReachBottom() {
    return _scrollController.position.maxScrollExtent - _scrollController.position.pixels <= 200;
  }

  init() {
    _scrollController.addListener(() {
      if (_pageStatus != PageStatus.success) {
        print('页面未加载完成不可以加载更多');

        return;
      }

      // print(
      //     'offset ${_scrollController.offset}, position: ${_scrollController.position.pixels}, maxScrollExtent: ${_scrollController.position.maxScrollExtent}');

      if (isReachBottom()) {
        if (_loadMoreStatus == PageStatus.loading) {
          print('到达底部，是加载更多中，不可执行 _loadMoreStatus $_loadMoreStatus, ${PageStatus.loading}');
          return;
        }
        setState(() {
          _loadMoreStatus = PageStatus.loading;
        });

        fetchData(isLoadMore: true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    init();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: BaColors.theme,
      appBar: AppBar(
        backgroundColor: BaColors.main,
        automaticallyImplyLeading: false,
        title: const Text("Articles", style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: _pageStatus == PageStatus.success ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8),
              itemCount: _articles.length >= _size ? _articles.length + 1 : _articles.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: _articles.length >= _size && index == _articles.length
                            ? ListFooter(loadMoreStatus: _loadMoreStatus, hasMore: _hasMore)
                            : ArticleItem(article: _articles[index], onTap: _handleTapArticleItem)),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
            ),
          ),
          if (_pageStatus != PageStatus.success) const Positioned(top: 0, bottom: 0, left: 0, right: 0, child: Center(child: Loading())),
        ],
      ),
    );
  }
}
