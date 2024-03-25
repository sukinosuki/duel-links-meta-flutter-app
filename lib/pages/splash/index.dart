import 'dart:async';

import 'package:duel_links_meta/pages/main/index.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var count = 1;

  late Timer timer;

  init() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (count <= 0) {
        timer.cancel();

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
        return;
      }

      setState(() {
        count -= 1;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: BaColors.momo,
        child: Center(
          child: Text("splash page"),
        ),
      ),
    );
  }
}
