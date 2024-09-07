import 'dart:async';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/gen/assets.gen.dart';
import 'package:duel_links_meta/hive/db/DarkModeHiveDb.dart';
import 'package:duel_links_meta/pages/main/index.dart';
import 'package:duel_links_meta/store/BanCardStore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class BgItem {
  BgItem({required this.url, required this.scale});

  String url;
  double scale;
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  int _count = 5;
  late Timer _timer;
  final banCardStore = Get.put(BanCardStore());
  late Animation<double> _scaleAnimation;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  int index = 0;
  double positionTop = 0;
  String placeholder =
      'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/91c64743-70df-48d8-bc46-032dcb781164/deyge89-7a17c4e8-bea6-420e-93fa-2133104a0fd1.png/v1/fill/w_1120,h_713/blue_eyes_alternative_white_dragon_render_by_d_evil6661_deyge89-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTMwNCIsInBhdGgiOiJcL2ZcLzkxYzY0NzQzLTcwZGYtNDhkOC1iYzQ2LTAzMmRjYjc4MTE2NFwvZGV5Z2U4OS03YTE3YzRlOC1iZWE2LTQyMGUtOTNmYS0yMTMzMTA0YTBmZDEucG5nIiwid2lkdGgiOiI8PTIwNDgifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.qLwRAIvBxtGlcd9K1aL9Hyrwudo5zDvq3skuSfE9N3A';

  String bgBlueFlexUrl = 'https://img.konami.com/yugioh/masterduel/images/background-blueflex.png';
  String bgRb = 'https://img.konami.com/yugioh/masterduel/images/background-fixed-rb.png';
  String bgTl = 'https://img.konami.com/yugioh/masterduel/images/background-fixed-tl.png';
  String bgUrl = 'https://img.konami.com/yugioh/masterduel/images/background-sparks.jpg';

  @override
  void dispose() {
    super.dispose();

    _timer.cancel();
  }

  void navigateToHomePage() {
    _animationController.dispose();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (context) => const MainPage()),
      (route) => false, //if you want to disable back feature set to false
    );
  }

  //
  void startCounterDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_count <= 0) {

        timer.cancel();

        navigateToHomePage();

        return;
      }

      setState(() {
        _count -= 1;
      });
    });
  }

  Future<void> initDarkMode() async {
    final mode = await DarkModeHiveDb().get();

    if (mode != ThemeMode.light) {
      Get.changeThemeMode(mode);
    }
  }

  List<BgItem> bgList = [
    // 防火墙
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/627fe721-846f-4f75-ac61-111ca00b27dd/dcut8b7-dd903b85-4837-4b40-96b3-ef9052858781.png/v1/fit/w_800,h_742/firewall_xceed_dragon__full_render___by_alanmac95_dcut8b7-414w-2x.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NzQyIiwicGF0aCI6IlwvZlwvNjI3ZmU3MjEtODQ2Zi00Zjc1LWFjNjEtMTExY2EwMGIyN2RkXC9kY3V0OGI3LWRkOTAzYjg1LTQ4MzctNGI0MC05NmIzLWVmOTA1Mjg1ODc4MS5wbmciLCJ3aWR0aCI6Ijw9ODAwIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.AZTGdxh0r0_Lli_vb8wuOYFmZkFlT_HmOZ23QuklI7U',
      scale: 1,
    ),

    // 时空龙
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/64d82561-3383-4f02-ba5d-0cd37c6f9227/dbi97ff-6e40406b-b417-4976-a2d0-d7071512917b.png/v1/fill/w_1024,h_609/number_107__galaxy_eyes_tachyon_dragon_by_koga92_by_dkpromangas92_dbi97ff-fullview.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NjA5IiwicGF0aCI6IlwvZlwvNjRkODI1NjEtMzM4My00ZjAyLWJhNWQtMGNkMzdjNmY5MjI3XC9kYmk5N2ZmLTZlNDA0MDZiLWI0MTctNDk3Ni1hMmQwLWQ3MDcxNTEyOTE3Yi5wbmciLCJ3aWR0aCI6Ijw9MTAyNCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.111LBrBGntP4T3txETGvMb6jgzRoWJ2tpdp7l-xkW4A',
      scale: 1.5,
    ),

    // 水晶大蛇
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/64d82561-3383-4f02-ba5d-0cd37c6f9227/dbi98er-3fae1bca-178d-49e6-abd4-583833a88418.png/v1/fill/w_853,h_937/crystron_quariongandrax_full_render_by_koga92_by_dkpromangas92_dbi98er-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTEyMiIsInBhdGgiOiJcL2ZcLzY0ZDgyNTYxLTMzODMtNGYwMi1iYTVkLTBjZDM3YzZmOTIyN1wvZGJpOThlci0zZmFlMWJjYS0xNzhkLTQ5ZTYtYWJkNC01ODM4MzNhODg0MTgucG5nIiwid2lkdGgiOiI8PTEwMjIifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.HJHntv3YAsFYTKILPkDa2xmvSTfvrgN3-CYKBjCK9HM',
      scale: 1.2,
    ),

    // 电子龙
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/fffbb7f5-78d1-47b5-a59d-19225f518420/dguocwe-68ece52b-ecfd-4def-806f-eb4b6ebc68b7.png/v1/fill/w_1257,h_636/cyber_dragon_infinity___yugioh_master_duel_by_matteste_dguocwe-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MjE1MCIsInBhdGgiOiJcL2ZcL2ZmZmJiN2Y1LTc4ZDEtNDdiNS1hNTlkLTE5MjI1ZjUxODQyMFwvZGd1b2N3ZS02OGVjZTUyYi1lY2ZkLTRkZWYtODA2Zi1lYjRiNmViYzY4YjcucG5nIiwid2lkdGgiOiI8PTQyNTAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.sABtGfCCtpj92YNOt_HbKO8eZ6vT5TzVm_YOnGidYh8',
      scale: 1.4,
    ),
    // 黑羽龙
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/53dc9ba2-f20c-4c3e-ac0b-b71317b922b2/d8tu7c4-079aef05-647a-4393-a1dd-227df9394547.png/v1/fill/w_875,h_600/black_winged_dragon_by_bright32302_d8tu7c4-fullview.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NjAwIiwicGF0aCI6IlwvZlwvNTNkYzliYTItZjIwYy00YzNlLWFjMGItYjcxMzE3YjkyMmIyXC9kOHR1N2M0LTA3OWFlZjA1LTY0N2EtNDM5My1hMWRkLTIyN2RmOTM5NDU0Ny5wbmciLCJ3aWR0aCI6Ijw9ODc1In1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.tupRakYBC9-ZgGcTw2axvGURhQ1FP4SZS-KhVOfbFL8',
      scale: 1,
    ),
    // 流星类天龙
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/53dc9ba2-f20c-4c3e-ac0b-b71317b922b2/dabn8zk-f85cebe6-7845-4e7c-b1e8-a1ac297cd860.png/v1/fill/w_835,h_768/shooting_quasar_dragon_by_bright32302_dabn8zk-fullview.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NzY4IiwicGF0aCI6IlwvZlwvNTNkYzliYTItZjIwYy00YzNlLWFjMGItYjcxMzE3YjkyMmIyXC9kYWJuOHprLWY4NWNlYmU2LTc4NDUtNGU3Yy1iMWU4LWExYWMyOTdjZDg2MC5wbmciLCJ3aWR0aCI6Ijw9ODM1In1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.uHalzH8hMuX7WuzZSm8O7m2npGPxdPfapPW_dAS9vXc',
      scale: 1,
    ),
    // 防火墙龙
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/59d970dd-eb09-447d-9a65-27f2c4fd248c/dbes4gw-5036056b-922d-4527-ad94-3c5ce3190fbb.png/v1/fill/w_889,h_899/firewall_dragon___full_artwork_by_xrosm_dbes4gw-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTAzMCIsInBhdGgiOiJcL2ZcLzU5ZDk3MGRkLWViMDktNDQ3ZC05YTY1LTI3ZjJjNGZkMjQ4Y1wvZGJlczRndy01MDM2MDU2Yi05MjJkLTQ1MjctYWQ5NC0zYzVjZTMxOTBmYmIucG5nIiwid2lkdGgiOiI8PTEwMTkifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.2_ctrGM9olCaoWsNHUYDvbJBk2si994BiEG4Bi0IcoY',
      scale: 1,
    ),
    // 电子龙无限
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/53dc9ba2-f20c-4c3e-ac0b-b71317b922b2/d9xejwh-9196d980-3598-4cd8-90bf-cd06905fefca.png/v1/fill/w_1024,h_683/cyber_dragon_infinity_by_bright32302_d9xejwh-fullview.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NjgzIiwicGF0aCI6IlwvZlwvNTNkYzliYTItZjIwYy00YzNlLWFjMGItYjcxMzE3YjkyMmIyXC9kOXhlandoLTkxOTZkOTgwLTM1OTgtNGNkOC05MGJmLWNkMDY5MDVmZWZjYS5wbmciLCJ3aWR0aCI6Ijw9MTAyNCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.lDdxdMVFOGxx7qGEIxfpeI88rYwwXjvVkzcVuUjpg1M',
      scale: 1.4,
    ),

    // 希望皇
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/5a6af839-076e-448b-b7e8-47dcfb1f1af3/df4yoiz-5994ee21-0c1b-4b6e-940a-0643c907f033.png/v1/fill/w_1040,h_769/master_duel_login_screen_render_by_henukim_df4yoiz-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTQ5MSIsInBhdGgiOiJcL2ZcLzVhNmFmODM5LTA3NmUtNDQ4Yi1iN2U4LTQ3ZGNmYjFmMWFmM1wvZGY0eW9pei01OTk0ZWUyMS0wYzFiLTRiNmUtOTQwYS0wNjQzYzkwN2YwMzMucG5nIiwid2lkdGgiOiI8PTIwMTYifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.d7PJXO0cAwu1WPsDlaQU0wtTEBTgj5hrBTTqiUq5gpA',
      scale: 1,
    ),

    // 龙辉巧
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/5a6af839-076e-448b-b7e8-47dcfb1f1af3/df2sg34-fed01781-72fd-4ead-a1bc-4ac63fc1156a.png/v1/fill/w_879,h_909/drytron_meteonis_draconids_render_by_henukim_df2sg34-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MjExOSIsInBhdGgiOiJcL2ZcLzVhNmFmODM5LTA3NmUtNDQ4Yi1iN2U4LTQ3ZGNmYjFmMWFmM1wvZGYyc2czNC1mZWQwMTc4MS03MmZkLTRlYWQtYTFiYy00YWM2M2ZjMTE1NmEucG5nIiwid2lkdGgiOiI8PTIwNDkifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.tWDvQtjSpY71-8eZ0gkzM32mT7W8IpyihoE_wAycj_o',
      scale: 1,
    ),

    // 刺刀
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/fffbb7f5-78d1-47b5-a59d-19225f518420/df40rj8-eb92ad9d-8ca8-49c7-9b4b-5f1b4b3eeb99.png/v1/fill/w_878,h_910/borrelsword_dragon___yugioh_master_duel_by_matteste_df40rj8-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MjgwMCIsInBhdGgiOiJcL2ZcL2ZmZmJiN2Y1LTc4ZDEtNDdiNS1hNTlkLTE5MjI1ZjUxODQyMFwvZGY0MHJqOC1lYjkyYWQ5ZC04Y2E4LTQ5YzctOWI0Yi01ZjFiNGIzZWViOTkucG5nIiwid2lkdGgiOiI8PTI3MDAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.JSankSgEKwzQReGylza5rxQEnKzogdKzsWL0TtvHwf0',
      scale: 1,
    ),

    // 蔷薇龙
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/b0d85773-a954-4ea3-8a6c-111cf5714f93/df4wysl-f15eb81f-e22f-470a-88ec-cb61771ce96a.png/v1/fill/w_895,h_893/ruddy_rose_dragon_by_faultzon3_df4wysl-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTI3NiIsInBhdGgiOiJcL2ZcL2IwZDg1NzczLWE5NTQtNGVhMy04YTZjLTExMWNmNTcxNGY5M1wvZGY0d3lzbC1mMTVlYjgxZi1lMjJmLTQ3MGEtODhlYy1jYjYxNzcxY2U5NmEucG5nIiwid2lkdGgiOiI8PTEyODAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.DN9jvTDr831Gl2GgV15YXzvKpUEW57img-rFCaIHwZM',
      scale: 1,
    ),

    // 冰龙剑
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/fffbb7f5-78d1-47b5-a59d-19225f518420/dfd1w89-a61f4b86-7899-443c-8272-b9c6b56a55bb.png/v1/fill/w_940,h_850/mirrorjade___yugioh_master_duel_by_matteste_dfd1w89-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MjM1MCIsInBhdGgiOiJcL2ZcL2ZmZmJiN2Y1LTc4ZDEtNDdiNS1hNTlkLTE5MjI1ZjUxODQyMFwvZGZkMXc4OS1hNjFmNGI4Ni03ODk5LTQ0M2MtODI3Mi1iOWM2YjU2YTU1YmIucG5nIiwid2lkdGgiOiI8PTI2MDAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.nJ63HHnEItCHdA6BYXkgYCXNq5Dw9xu44BFifafY4QA',
      scale: 1,
    ),

    // 法法
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/fffbb7f5-78d1-47b5-a59d-19225f518420/dguos3c-c70f5142-774e-45d3-b182-d12e11c90ad7.png/v1/fill/w_951,h_840/true_king_of_all_calamities___yugioh_master_duel_by_matteste_dguos3c-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MjY1MCIsInBhdGgiOiJcL2ZcL2ZmZmJiN2Y1LTc4ZDEtNDdiNS1hNTlkLTE5MjI1ZjUxODQyMFwvZGd1b3MzYy1jNzBmNTE0Mi03NzRlLTQ1ZDMtYjE4Mi1kMTJlMTFjOTBhZDcucG5nIiwid2lkdGgiOiI8PTMwMDAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.0_5-pTiovRRDYc8vpXspbqjtwLvBLuWOQRKTKySTANs',
      scale: 1,
    ),
    // 天庭号
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/fffbb7f5-78d1-47b5-a59d-19225f518420/dguoef8-2dc6ebf4-05cf-44d2-b8af-dc55d8cfd016.png/v1/fill/w_1103,h_724/divine_arsenal_aa_zeus___yugioh_master_duel_by_matteste_dguoef8-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MjIwMCIsInBhdGgiOiJcL2ZcL2ZmZmJiN2Y1LTc4ZDEtNDdiNS1hNTlkLTE5MjI1ZjUxODQyMFwvZGd1b2VmOC0yZGM2ZWJmNC0wNWNmLTQ0ZDItYjhhZi1kYzU1ZDhjZmQwMTYucG5nIiwid2lkdGgiOiI8PTMzNTAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.JJBLh_TKh6aF4zIprIL8OQh1rv0QdRDZeJjSH3BEo74',
      scale: 1,
    ),
    // 拿非利
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/fffbb7f5-78d1-47b5-a59d-19225f518420/dguofth-190988bb-9c15-4150-9939-4c70b9f4d90a.png/v1/fill/w_1017,h_786/el_shaddoll_construct___yugioh_master_duel_by_matteste_dguofth-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTcwMCIsInBhdGgiOiJcL2ZcL2ZmZmJiN2Y1LTc4ZDEtNDdiNS1hNTlkLTE5MjI1ZjUxODQyMFwvZGd1b2Z0aC0xOTA5ODhiYi05YzE1LTQxNTAtOTkzOS00YzcwYjlmNGQ5MGEucG5nIiwid2lkdGgiOiI8PTIyMDAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.DmbjoUE5MSQBPgNt-KcY4PEqReXnzxRnVZCMxfTebLI',
      scale: 1,
    ),

    // 天童
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/fffbb7f5-78d1-47b5-a59d-19225f518420/dfrau8v-5f219236-3b72-481d-9ac2-8d55bf596628.png/v1/fit/w_828,h_1082/kurikara_divincarnate___yugioh_master_duel_by_matteste_dfrau8v-414w-2x.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MzIwMCIsInBhdGgiOiJcL2ZcL2ZmZmJiN2Y1LTc4ZDEtNDdiNS1hNTlkLTE5MjI1ZjUxODQyMFwvZGZyYXU4di01ZjIxOTIzNi0zYjcyLTQ4MWQtOWFjMi04ZDU1YmY1OTY2MjgucG5nIiwid2lkdGgiOiI8PTI0NTAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.aOIDuS9mVlz3fimh080wAb1zRjnhRdKw-uEdZXxg3hc',
      scale: 1,
    ),

    //
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/fffbb7f5-78d1-47b5-a59d-19225f518420/dfp01tv-a4fd3118-83a3-4715-a47f-3c6344958553.png/v1/fill/w_902,h_886/ultimate_slayer___yugioh_master_duel_by_matteste_dfp01tv-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MjgwMCIsInBhdGgiOiJcL2ZcL2ZmZmJiN2Y1LTc4ZDEtNDdiNS1hNTlkLTE5MjI1ZjUxODQyMFwvZGZwMDF0di1hNGZkMzExOC04M2EzLTQ3MTUtYTQ3Zi0zYzYzNDQ5NTg1NTMucG5nIiwid2lkdGgiOiI8PTI4NTAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.ZO8atLE65xUuv7pS60RwGTwQXWtoqUMUah8YCFUOOlA',
      scale: 1,
    ),

    // 银河眼1
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/fffbb7f5-78d1-47b5-a59d-19225f518420/df3yr5s-58164e67-d65f-455d-bde7-a80cf725807f.png/v1/fill/w_970,h_824/galaxy_eyes_cipher_x_dragon___yugioh_master_duel_by_matteste_df3yr5s-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MzQwMCIsInBhdGgiOiJcL2ZcL2ZmZmJiN2Y1LTc4ZDEtNDdiNS1hNTlkLTE5MjI1ZjUxODQyMFwvZGYzeXI1cy01ODE2NGU2Ny1kNjVmLTQ1NWQtYmRlNy1hODBjZjcyNTgwN2YucG5nIiwid2lkdGgiOiI8PTQwMDAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.uuBQiItwym2MJM8Dzz8Vgqh0bN7S88TMCZnw92WpVp0',
      scale: 1,
    ),

    // 究极龙
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/03b5a34c-d066-4223-ae94-21c906adb0bc/dbjqir2-11577bfa-e050-4c9b-8f66-b3fba78649f2.png/v1/fill/w_1024,h_500/neo_blue_eyes_ultimate_dragon_full_render_by_holycrapwhitedragon_dbjqir2-fullview.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NTAwIiwicGF0aCI6IlwvZlwvMDNiNWEzNGMtZDA2Ni00MjIzLWFlOTQtMjFjOTA2YWRiMGJjXC9kYmpxaXIyLTExNTc3YmZhLWUwNTAtNGM5Yi04ZjY2LWIzZmJhNzg2NDlmMi5wbmciLCJ3aWR0aCI6Ijw9MTAyNCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.LFY8xAIptbencZ9hVhBNBYdURzJvZx5y8oETBNG03eI',
      scale: 1,
    ),
    // 青眼1
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/627fe721-846f-4f75-ac61-111ca00b27dd/ddmykl2-bf7bb3c2-0201-444e-b30e-63f366ca548b.png/v1/fill/w_908,h_589/blue_eyes_white_dragon__render__by_alanmac95_ddmykl2-fullview.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NTg5IiwicGF0aCI6IlwvZlwvNjI3ZmU3MjEtODQ2Zi00Zjc1LWFjNjEtMTExY2EwMGIyN2RkXC9kZG15a2wyLWJmN2JiM2MyLTAyMDEtNDQ0ZS1iMzBlLTYzZjM2NmNhNTQ4Yi5wbmciLCJ3aWR0aCI6Ijw9OTA4In1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.mfBxuZ78dqwd4SeJPfCAey0dZk6eEFJAOOoUNc9KdS4',
      scale: 1,
    ),

    // 驱魔姐妹
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/fffbb7f5-78d1-47b5-a59d-19225f518420/df51h22-8dd52191-184f-4b71-be58-89e3fd72759a.png/v1/fill/w_922,h_867/exosister_mikailis___yugioh_master_duel_by_matteste_df51h22-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MjM1MCIsInBhdGgiOiJcL2ZcL2ZmZmJiN2Y1LTc4ZDEtNDdiNS1hNTlkLTE5MjI1ZjUxODQyMFwvZGY1MWgyMi04ZGQ1MjE5MS0xODRmLTRiNzEtYmU1OC04OWUzZmQ3Mjc1OWEucG5nIiwid2lkdGgiOiI8PTI1MDAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.BWsVqbUI-xiOEDxHwMHlwf7trkB1Y-4tvPUiLhSDV-4',
      scale: 1,
    ),
    // 仪式凤凰
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/96551409-eddd-4b72-92da-7fd74699b762/dco5tvi-98636c24-8e72-48c6-9ead-a280bd74f229.png/v1/fill/w_1024,h_725/sacred_blue_phoenix_of_nephthys_by_coccvo_dco5tvi-fullview.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NzI1IiwicGF0aCI6IlwvZlwvOTY1NTE0MDktZWRkZC00YjcyLTkyZGEtN2ZkNzQ2OTliNzYyXC9kY281dHZpLTk4NjM2YzI0LThlNzItNDhjNi05ZWFkLWEyODBiZDc0ZjIyOS5wbmciLCJ3aWR0aCI6Ijw9MTAyNCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.qkpXN7HsyJo78gENU9KVYNIqI9X0nya4s574374DaLM',
      scale: 1,
    ),

    // 巨大喷流
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/b0d85773-a954-4ea3-8a6c-111cf5714f93/dfozeao-b29ecc75-4082-4b2b-acc9-4e6489bacb64.png/v1/fit/w_828,h_968/gigantic_spright_by_faultzon3_dfozeao-414w-2x.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTQ5NSIsInBhdGgiOiJcL2ZcL2IwZDg1NzczLWE5NTQtNGVhMy04YTZjLTExMWNmNTcxNGY5M1wvZGZvemVhby1iMjllY2M3NS00MDgyLTRiMmItYWNjOS00ZTY0ODliYWNiNjQucG5nIiwid2lkdGgiOiI8PTEyODAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.J0bwIjEjXIWkFBwwAlr8pXhYSKbH5KLf71Whb5ajfUQ',
      scale: 1,
    ),

    // 红莲龙
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/fffbb7f5-78d1-47b5-a59d-19225f518420/dhxlm3h-f570b54e-d728-4941-8830-9189a90b49d7.png/v1/fill/w_985,h_811/crimson_dragon___yugioh_master_duel_by_matteste_dhxlm3h-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MjgwMCIsInBhdGgiOiJcL2ZcL2ZmZmJiN2Y1LTc4ZDEtNDdiNS1hNTlkLTE5MjI1ZjUxODQyMFwvZGh4bG0zaC1mNTcwYjU0ZS1kNzI4LTQ5NDEtODgzMC05MTg5YTkwYjQ5ZDcucG5nIiwid2lkdGgiOiI8PTM0MDAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.OS_Ae_xkHAKC4JdoG3F9fIHjsL3Psx6xSoNTjoXFaQU',
      scale: 1,
    ),

    // 闪刀- kakari
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/fffbb7f5-78d1-47b5-a59d-19225f518420/dhjqbcz-0dd60ee9-f56e-4296-8c91-08a426c1a9b5.png/v1/fill/w_863,h_926/sky_striker___kagari__alt____yugioh_master_duel_by_matteste_dhjqbcz-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MjkwMCIsInBhdGgiOiJcL2ZcL2ZmZmJiN2Y1LTc4ZDEtNDdiNS1hNTlkLTE5MjI1ZjUxODQyMFwvZGhqcWJjei0wZGQ2MGVlOS1mNTZlLTQyOTYtOGM5MS0wOGE0MjZjMWE5YjUucG5nIiwid2lkdGgiOiI8PTI3MDAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.LVOcGOOhEqKjNdHWEwMfH2PASKtC8gplUDrPgZlq8FI',
      scale: 1,
    ),

    // 陨石
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/fffbb7f5-78d1-47b5-a59d-19225f518420/dguoltn-bca520a4-51c8-4e25-9b2a-1409c8d482f0.png/v1/fill/w_894,h_894/nibiru_the_primal_being___yugioh_master_duel_by_matteste_dguoltn-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MjA0OCIsInBhdGgiOiJcL2ZcL2ZmZmJiN2Y1LTc4ZDEtNDdiNS1hNTlkLTE5MjI1ZjUxODQyMFwvZGd1b2x0bi1iY2E1MjBhNC01MWM4LTRlMjUtOWIyYS0xNDA5YzhkNDgyZjAucG5nIiwid2lkdGgiOiI8PTIwNDgifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.vEk9jVASbPoi2mfMYGzXJnCihHWEgpKO_6pha8lLqDY',
      scale: 1,
    ),

    // 小米
    BgItem(
      url:
          'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/fffbb7f5-78d1-47b5-a59d-19225f518420/dguofxb-e0938f9f-cf1f-4e38-82db-59141c48ed5e.png/v1/fill/w_920,h_868/el_shaddoll_winda___yugioh_master_duel_by_matteste_dguofxb-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MjUwMCIsInBhdGgiOiJcL2ZcL2ZmZmJiN2Y1LTc4ZDEtNDdiNS1hNTlkLTE5MjI1ZjUxODQyMFwvZGd1b2Z4Yi1lMDkzOGY5Zi1jZjFmLTRlMzgtODJkYi01OTE0MWM0OGVkNWUucG5nIiwid2lkdGgiOiI8PTI2NTAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.LuAeeHlg52MXBPnEz-yFIihY9rWuKqV2CRYSne4BFsw',
      scale: 1,
    ),
  ];

  void initSlideBg() {
    setState(() {
      positionTop -= _count * 40;
    });
  }

  Future<void> init() async {
    await initDarkMode();

    initSlideBg();
    startCounterDown();

    banCardStore.setupLocalData().ignore();
  }

  @override
  void initState() {
    setState(() {
      index = math.Random().nextInt(bgList.length);
    });
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 5000))..repeat(reverse: true);

    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.02)).animate(_animationController);

    _scaleAnimation = Tween<double>(begin: 1, end: 1.02).chain(CurveTween(curve: Curves.easeOutCirc)).animate(_animationController);

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: InkResponse(
        highlightShape: BoxShape.rectangle,
        containedInkWell: true,
        onTap: navigateToHomePage,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedPositioned(
              duration: const Duration(seconds: 10),
              top: positionTop,
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 2,
                child: Transform.scale(
                  scale: 1.8,
                  child: CachedNetworkImage(
                    fit: BoxFit.fitWidth,
                    imageUrl: bgUrl,
                    repeat: ImageRepeat.repeatY,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: bgBlueFlexUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: -200,
              right: 0,
              child: CachedNetworkImage(imageUrl: bgRb),
            ),
            Positioned(
              top: 0,
              child: CachedNetworkImage(imageUrl: bgTl),
            ),
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Transform.translate(
                      offset: const Offset(0, -60),
                      child: Transform.scale(
                        scale: bgList[index].scale,
                        child: CachedNetworkImage(
                          fit: BoxFit.contain,
                          placeholder: (context, url) => CachedNetworkImage(imageUrl: placeholder),
                          imageUrl: bgList[index].url,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: const Offset(0, 40),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      index = math.Random().nextInt(bgList.length);
                    });
                  },
                  child: Assets.images.siteLogoDlmPng.image(height: 80),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Tap the screen (',
                    children: [
                      TextSpan(text: '$_count', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                      const TextSpan(text: 's)'),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
