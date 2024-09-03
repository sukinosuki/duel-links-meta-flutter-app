import 'dart:developer';

import 'package:get/get.dart';

class Net extends GetConnect {
  Net()
      : super(
          timeout: const Duration(seconds: 30),
          userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0',
        ) {
    var start = DateTime.now();

    httpClient
      ..addRequestModifier<Object?>((request) async {
        start = DateTime.now();

        final query = Uri.splitQueryString(request.url.query);
        log('[Net] 请求开始, query: $query, path1: ${request.url}');

        return request;
      })
      ..addResponseModifier((request, response) {
        log('[Net] 请求结束, take: ${DateTime.now().difference(start).inMilliseconds}ms, code: ${response.statusCode}, codeText: ${response.statusText}');
        return response;
      });
  }

  @override
  String get baseUrl => 'https://www.duellinksmeta.com';
}

Net http = Net();
