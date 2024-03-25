import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

class Net extends GetConnect {
  Net() : super(timeout: const Duration(seconds: 30), userAgent: 'Sesame-Client') {

    httpClient.addRequestModifier<Object?>((request) async {

      print("请求开始");

      _logRequest(request);

      await _setupHeader(request);

      return request;
    });
  }

  @override
  // String get baseUrl => currentEnvironment.host;
  String get baseUrl => 'https://www.duellinksmeta.com';

  // @override void onInit() {
  //   // TODO: implement onInit
  //   // super.onInit();
  //   httpClient.defaultDecoder = (data) {
  //     log("---- 响应 ----\n$data");
  //
  //     try {
  //       // return AppResponse.fromJson(data);
  //       return AppResponse(code: 0, msg: "ok", data: null);
  //     } catch (error) {
  //       print("请求出错 $error");
  //
  //       return AppResponse(code: 500, msg: error.toString(), data: null);
  //       // return NetResponse(NetCode.serverError, null)..message = '服务端未知错误';
  //     }
  //   };
  // }
  // @override
  // Decoder<AppResponse> get defaultDecoder => (data) {
  //   log("---- 响应 ----\n$data");
  //   try {
  //     // return AppResponse.fromJson(data);
  //     return AppResponse(code: 0, msg: "ok", data: null);
  //   } catch (error) {
  //     print("请求出错 $error");
  //
  //     return AppResponse(code: 500, msg: error.toString(), data: null);
  //     // return NetResponse(NetCode.serverError, null)..message = '服务端未知错误';
  //   }
  // };

  // String get _platform {
  //   if (Platform.isIOS) {
  //     return 'iOS';
  //   } else if (Platform.isAndroid) {
  //     return 'android';
  //   } else {
  //     return 'web';
  //   }
  // }

  Future _setupHeader(Request request) async {
    print("[_setupHeader]");
    // request.headers['Sesame-Platform'] = _platform;
    // final token = await StoreToken.getToken();

    // var authStore = Get.put(AuthStoreController());
    // // var token =;
    //
    // if (authStore.authToken != null) {
    //   request.headers['Authorization'] = authStore.authToken!;
    // }
  }

  void _logRequest(Request request) async {
    var str = "---- 请求 ----\nmethod: ${request.method}\nurl: ${request.url}\nquery: ${request.url.queryParameters}";
    if (request.method != 'post' || request.headers['content-type'] != 'application/json') {
      log(str);
      return;
    }

    const decoder = Utf8Decoder();

    List<List<int>> bodyBytes = [];

    request.bodyBytes.asBroadcastStream(onListen: (subscribe) {
      subscribe.onData((data) => bodyBytes.add(data));
      subscribe.onDone(() {
        str += '\nbody: ${(bodyBytes.map((e) => decoder.convert(e)).join())}';
        log(str);
      });
    });
  }
}
