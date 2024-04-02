import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  int currentLoadingIndex = 1;
  var loadingImageUrl = 'https://s3.duellinksmeta.com/img/static/assets/avatars/default-discord-avatar.webp';

  late Animation<Offset> _animation;
  late Animation<double> _scaleAnimation;
  late AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    // loadingImgTimer.cancel();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat(reverse: true);

    _animation = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -0.2)).chain(CurveTween(curve: Curves.easeOut)).animate(_animationController);
    // ..addListener(() {
    //   print("animation change status ${_animation.status}");
    //   print("animation change value ${_animation.value}");
    //   print("animation change isCompleted ${_animation.isCompleted}");
    // });

    _scaleAnimation = Tween<double>(begin: 1, end: 1.01).chain(CurveTween(curve: Curves.easeInOut)).animate(_animationController);

    _animationController.repeat(reverse: true);

    // loadingImgTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   var random = Random();
    //   var randomNumber = random.nextInt(4) + 1;
    //   // print("randomNumber $randomNumber");
    //
    //   if (randomNumber == currentLoadingIndex) {
    //     randomNumber += 1;
    //     if (randomNumber > 4) {
    //       randomNumber = 1;
    //     }
    //   }
    //   setState(() {
    //     currentLoadingIndex = randomNumber;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    print('Loading build');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SlideTransition(
          position: _animation,
          child: CachedNetworkImage(width: 60, height: 60, imageUrl: loadingImageUrl),
        ),
        ScaleTransition(scale: _scaleAnimation, child: const Text("Loading", style: TextStyle(fontSize: 14, color: Colors.white)))
      ],
    );
  }
}
