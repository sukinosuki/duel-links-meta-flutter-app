import 'package:duel_links_meta/components/ModalBottomSheetWrap.dart';
import 'package:duel_links_meta/components/ThemeColorSelectorPanelModalView.dart';
import 'package:duel_links_meta/hive/db/DarkModeHiveDb.dart';
import 'package:duel_links_meta/pages/open_source_licenses/index.dart';
import 'package:duel_links_meta/store/AppStore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  Future<void> _handleOpenThemeColorModal() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const ThemeColorSelectorPanelModalView();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrap(
      child: Container(
        // height: 400,
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 28,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Setting',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              ListTile(
                title: Text('Theme mode ${Get.isDarkMode}'),
                contentPadding: const EdgeInsets.only(right: 10, left: 16),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Positioned.fill(
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(Get.isDarkMode ? 0 : 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          isSelected: !Get.isDarkMode,
                          onPressed: () {
                            Get.changeThemeMode(ThemeMode.light);
                            DarkModeHiveDb().set(ThemeMode.light);
                          },
                          icon: Icon(Icons.sunny, color: !Get.isDarkMode ? Theme.of(context).colorScheme.primary : null),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Positioned.fill(
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(!Get.isDarkMode ? 0 : 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          isSelected: Get.isDarkMode,
                          onPressed: () {
                            Get.changeThemeMode(ThemeMode.dark);
                            DarkModeHiveDb().set(ThemeMode.dark);
                          },
                          icon: Icon(Icons.nightlight_rounded, color: Get.isDarkMode ? Theme.of(context).colorScheme.primary : null),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: ListTile(
                  onTap: appStore.toggleShowWebviewNavs,
                  title: const Text('Show all navs'),
                  trailing: Obx(
                    () => Switch(
                      inactiveTrackColor: Colors.grey.withOpacity(0.4),
                      inactiveThumbColor: Colors.grey,
                      value: appStore.showWebviewNavs.value,
                      activeColor: Theme.of(context).colorScheme.primary,
                      trackOutlineColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.transparent;
                        } else {
                          return Colors.grey;
                        }
                      }),
                      onChanged: (checked) => appStore.toggleShowWebviewNavs(),
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: ListTile(
                  onTap: _handleOpenThemeColorModal,
                  title: const Text('Theme color'),
                  trailing: Obx(
                    () => Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: appStore.themeColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(40),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Text(
                  'About',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              ListTile(
                title: const Text('App version'),
                trailing: Text(packageInfo?.version ?? ''),
              ),
              ListTile(
                title: const Text('Commit ID'),
                trailing: Text(githubHash),
              ),
              Material(
                color: Colors.transparent,
                child: ListTile(
                  onTap: () {
                    final uri = Uri.parse(repos);
                    launchUrl(uri).ignore();
                  },
                  title: const Text('Github'),
                  trailing: const Icon(Icons.arrow_forward),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: ListTile(
                  title: const Text('Open Source Licenses'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const OpenSourceLicensePage()));
                  },
                  trailing: const Icon(Icons.arrow_forward),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: ListTile(
                  title: const Text('Duel Links Meta'),
                  onTap: () {
                    final uri = Uri.parse(duelLinksMetaUrl);
                    launchUrl(uri).ignore();
                  },
                  trailing: const Icon(Icons.arrow_forward),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  SettingItem({super.key, this.onTap, required this.title});

  void Function()? onTap;
  String title;
  Widget? tailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap?.call,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              tailing ?? const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
