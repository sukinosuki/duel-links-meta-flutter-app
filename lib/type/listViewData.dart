import 'enum/PageStatus.dart';

class ListViewData<T> {
  var pageStatus = PageStatus.loading;
  var hasMore = true;
  var page = 1;
  var size = 10;
  var loadMoreStatus = PageStatus.success;
  List<T> data = [];

  ListViewData({this.size = 10});
}
