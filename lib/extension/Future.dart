import 'dart:developer';
import 'dart:io';

import 'package:duel_links_meta/extension/String.dart';
import 'package:get/get_connect/connect.dart';

extension FutureEx<T> on Future<Response<T>> {

  Future<(Exception?, T?)> get toCatch async{
      try {
        final res = await this;
        if (res.statusCode != 200) {
          throw HttpException('status: ${res.statusCode}');
        }

        return (null, res.body);
      } catch (err) {
        log('[toCatch] err: $err, ${err.runtimeType}');

        // toast error
        err.toString().toast();

        return (HttpException(err.toString()), null);
      }
  }
}