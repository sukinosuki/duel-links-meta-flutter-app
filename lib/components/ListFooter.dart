import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:flutter/material.dart';

class ListFooter extends StatefulWidget {
  const ListFooter({super.key, required this.loadMoreStatus, required this.hasMore});

  final PageStatus loadMoreStatus;
  final bool hasMore;

  @override
  State<ListFooter> createState() => _ListFooterState();
}

class _ListFooterState extends State<ListFooter> {
  var loadMoreStatusTextMap = <PageStatus, String>{
    PageStatus.loading: 'Loading',
    PageStatus.fail: 'Fail',
  };

  String get loadMoreStatusText {
    if (!widget.hasMore) {
      return 'Load Completed';
    }

    return loadMoreStatusTextMap[widget.loadMoreStatus] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(loadMoreStatusText),
          const SizedBox(width: 10),
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              semanticsLabel: '21',
            ),
          )
        ],
      ),
    );
  }
}
