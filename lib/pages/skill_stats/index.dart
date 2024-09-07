import 'package:duel_links_meta/api/SkillStatsApi.dart';
import 'package:duel_links_meta/components/SkillModalView.dart';
import 'package:duel_links_meta/type/skill_stats/SkillStats.dart';
import 'package:flutter/material.dart';

class SkillStatsPage extends StatefulWidget {
  const SkillStatsPage({super.key, required this.name});

  final String name;

  @override
  State<SkillStatsPage> createState() => _SkillStatsState();
}

class _SkillStatsState extends State<SkillStatsPage> {
  String get name => widget.name;
  List<SkillStats> _skillStats = [];

  Future<void> fetchData() async {
    setState(() {
      _skillStats = [];
    });

    final res = await SkillStatsApi().getByName(name);
    final list = res.body!.map(SkillStats.fromJson).toList();

    setState(() {
      _skillStats = list;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name, style: const TextStyle(color: Colors.white)),
          actions: [
            IconButton(onPressed: fetchData, icon: const Icon(Icons.refresh)),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SkillModalView(name: name),

              const SizedBox(height: 20),
              const Text('Usage Statistics', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
              const SizedBox(height: 30),

              // Container(
              //   child: AspectRatio(
              //     aspectRatio: 1.6,
              //     child: SampleBarChart(_skillStats),
              //   ),
              // )
            ],
          ),
        ));
  }
}
