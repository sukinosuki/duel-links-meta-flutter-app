import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/hive/db/DarkModeHiveDb.dart';
import 'package:duel_links_meta/pages/open_source_licenses/index.dart';
import 'package:duel_links_meta/store/AppStore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingModalView extends StatefulWidget {
  const SettingModalView({super.key});

  @override
  State<SettingModalView> createState() => _SettingModalViewState();
}

class _SettingModalViewState extends State<SettingModalView> {
  AppStore appStore = Get.put(AppStore());

  PackageInfo? get packageInfo => appStore.packageInfo;

  String repos = 'https://github.com/sukinosuki/duel-links-meta-flutter-app';
  String duelLinksMetaUrl = 'https://www.duellinksmeta.com';

  String githubHash = '';

  void init() {
    githubHash = const String.fromEnvironment('GITHUB_HASH');
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 30),
        color: Theme.of(context).colorScheme.onPrimary,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Setting',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Text('Theme mode'),
                    ),
                    Row(
                      children: [
                        IconButton(
                          isSelected: !Get.isDarkMode,
                          onPressed: () {
                            Get.changeThemeMode(ThemeMode.light);
                            DarkModeHiveDb().set(ThemeMode.light);
                          },

                          icon: const Icon(Icons.sunny),
                        ),
                        IconButton(
                          isSelected: Get.isDarkMode,
                          onPressed: () {
                            Get.changeThemeMode(ThemeMode.dark);
                            DarkModeHiveDb().set(ThemeMode.dark);
                          },
                          icon: const Icon(Icons.nightlight_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Text(
                  'About',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('App version'),
                    Text(packageInfo?.version ?? ''),
                  ],
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Commit ID'),
                    Text(githubHash),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    final uri = Uri.parse(repos);
                    launchUrl(uri).ignore();
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Github'),
                        Icon(Icons.arrow_forward, color: Theme.of(context).iconTheme.color?.withOpacity(0.6)),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const OpenSourceLicensePage()));
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Open source licenses'),
                        Icon(Icons.arrow_forward, color: Theme.of(context).iconTheme.color?.withOpacity(0.6),),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                      final uri = Uri.parse(duelLinksMetaUrl);
                      launchUrl(uri).ignore();
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Duel Link Meta'),
                        Icon(Icons.arrow_forward, color: Theme.of(context).iconTheme.color?.withOpacity(0.6),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
