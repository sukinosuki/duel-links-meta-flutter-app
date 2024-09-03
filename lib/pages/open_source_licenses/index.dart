import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:duel_links_meta/pages/webview/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenSourceLicense {
  OpenSourceLicense({required this.name, required this.repos, required this.licensesPath, required this.version});

  String name;
  String repos;
  String licensesPath;
  String version;
}

class OpenSourceLicensePage extends StatefulWidget {
  const OpenSourceLicensePage({super.key});

  @override
  State<OpenSourceLicensePage> createState() => _OpenSourceLicensePageState();
}

class _OpenSourceLicensePageState extends State<OpenSourceLicensePage> {
  List<OpenSourceLicense> licenses = [];

  //
  Future<void> _openBrowser(OpenSourceLicense license) async {
    var url = license.licensesPath;
    if (url.isEmpty) {
      url = license.repos;
    }
    final uri = Uri.parse(url);

    await showModal<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Open by browser'),
          content: Text(url),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      launchUrl(uri).ignore();
                      Navigator.pop(context);
                    },
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  //
  Future<void> init() async {
    final jsonData = await rootBundle.loadString('assets/json/open_source_licenses.json');
    final data = json.decode(jsonData) as List<dynamic>;

    final list = data
        .map(
          (e) => OpenSourceLicense(
              name: (e['name'] ?? '') as String,
              repos: (e['repos'] ?? '') as String,
              licensesPath: (e['license_path'] ?? '') as String,
              version: (e['version'] ?? '') as String),
        )
        .toList();

    setState(() {
      licenses = list;
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
      appBar: AppBar(
        title: const Text('Open source licenses'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: licenses.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => _openBrowser(licenses[index]),
                child: Card(
                  margin: EdgeInsets.zero,
                  shadowColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              licenses[index].name,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                        Text(
                          licenses[index].repos,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          );
        },
      ),
    );
  }
}
