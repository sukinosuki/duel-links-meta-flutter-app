import 'package:duel_links_meta/type/enum/PageStatus.dart';

class ListViewData<T> {

  ListViewData({this.size = 10});
  PageStatus pageStatus = PageStatus.loading;
  bool hasMore = true;
  int page = 1;
  int size = 10;
  PageStatus loadMoreStatus = PageStatus.success;
  List<T> data = [];
}
