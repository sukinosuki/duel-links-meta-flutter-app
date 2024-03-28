import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/type/skill_stats/SkillStats.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// TODO: https://github.com/imaNNeo/fl_chart/issues/406
class SampleBarChart extends StatelessWidget {
  const SampleBarChart(this.skillStats);

  final List<SkillStats> skillStats;

  // var touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
      ),
      swapAnimationDuration: const Duration(milliseconds: 500),
      // swapAnimationDuration: Duration(milliseconds: 350), // Optional
      // swapAnimationCurve: Curves.linear, // Optional
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 4,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              '${rod.toY.toStringAsFixed(0)}%',
              const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
            );
          },
        ),
        // touchCallback: (FlTouchEvent event, barTouchResponse) {
        //   setState(() {
        //     if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
        //       touchedIndex = -1;
        //       return;
        //     }
        //     touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
        //   });
        // },
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 6, overflow: TextOverflow.clip);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(height: value.toInt() %2 == 0 ? 10: 0,),
            Container(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Container(
                  width: 26,
                  height: 26,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: 'https://imgserv.duellinksmeta.com/v2/dlm/deck-type/${skillStats[value.toInt()].name}?portrait=true&width=100',
                  ),
                ),
              ),
            ),
            Container(child: Text(skillStats[value.toInt()].name, style: style)),
            // if (skillStats[value.toInt()].tier!= null) Container(child: Text(skillStats[value.toInt()].tier.toString(), style: style)),
          ],
        ),
      ),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(show: false);

  // LinearGradient get _barsGradient => const LinearGradient(
  List<BarChartGroupData> get barGroups => skillStats
      .asMap()
      .entries
      .map(
        (e) => BarChartGroupData(
          x: e.key,
          barRods: [
            BarChartRodData(
              toY: e.value.percentage,
              width: 14,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: skillStats[e.key].tier != null ? Colors.orange : Colors.blueAccent,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      )
      .toList();
}
