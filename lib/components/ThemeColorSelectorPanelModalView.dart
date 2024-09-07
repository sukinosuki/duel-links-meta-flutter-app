import 'package:duel_links_meta/components/ModalBottomSheetWrap.dart';
import 'package:duel_links_meta/store/AppStore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeColorSelectorPanelModalView extends StatefulWidget {
  const ThemeColorSelectorPanelModalView({super.key});

  @override
  State<ThemeColorSelectorPanelModalView> createState() => _ThemeColorSelectorPanelModalViewState();
}

class _ThemeColorSelectorPanelModalViewState extends State<ThemeColorSelectorPanelModalView> {
  var _index = 0;
  var appStore = Get.put(AppStore());

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrap(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Choose theme color',
                style: TextStyle(fontSize: 24),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appStore.themeColorList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    appStore.changeThemeColorIndex(index);
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: appStore.themeColorList[index],
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(2, 2),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        child: Center(
                          child: Obx(() => AnimatedScale(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.fastOutSlowIn,
                                scale: appStore.themeColorIndex.value == index ? 1 : 0,
                                child: AnimatedOpacity(
                                  opacity: appStore.themeColorIndex.value == index ? 1 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: const Icon(
                                    Icons.check,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
