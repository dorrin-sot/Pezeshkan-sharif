import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:tahlil_front/classes/statistics.dart';
import 'package:tahlil_front/services/profile.dart';
import 'package:tahlil_front/utils/pair.dart';
import 'package:tahlil_front/widgets/error.dart' as error;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _profileService = ProfileService.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Statistics?>(
      future: _profileService.getStatistics(),
      builder: (context, snapshot) {
        print(snapshot.error);
        if (snapshot.hasError) {
          return error.ErrorWidget(
            msg: 'Encountered an error loading appointment information.',
            refresh: () => setState(() {}),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final stats = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black45, blurRadius: 2)
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: stats is ReferrerStatistics
                  ? Center(child: ReferrerPieChart(stats, width: 500))
                  : StaggeredGrid.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: [
                        if (stats is DoctorStatistics) ...[
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: AgesBarChart(stats, width: 500),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: RepeatingCustomerPieChart(stats, width: 500),
                          ),
                        ],
                        if (stats is DoctorImagingCenterStatistics) ...[
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: Center(
                              child: RatingsPieChart(stats, width: 500),
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 3,
                            mainAxisCellCount: 1,
                            child: AppointmentDateChart(stats),
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget ReferrerPieChart(ReferrerStatistics stats, {required double width}) {
    return CustomPieChart(
      stats.refereePercentages,
      colors: {
        'verified': Colors.green.shade300,
        'declined': Colors.redAccent.shade100,
        'waiting': Colors.amber.shade200,
      },
      width: width,
    );
  }

  Widget RatingsPieChart(
    DoctorImagingCenterStatistics stats, {
    required double width,
  }) {
    return CustomPieChart(
      stats.groupedRating.map((k, v) => MapEntry('$k⭐️', v)),
      colors: {
        '1⭐️': Colors.red,
        '2⭐️': Colors.redAccent.shade100,
        '3⭐️': Colors.amber,
        '4⭐️': Colors.lightGreen.shade400,
        '5⭐️': Colors.green,
      },
      centerText: '\nAverage: ${stats.avgRating.toStringAsFixed(1)}⭐️',
      width: width,
    );
  }

  Widget RepeatingCustomerPieChart(
    DoctorStatistics stats, {
    required double width,
  }) {
    // todo
    return CustomPieChart(
      stats.groupedRating.map((k, v) => MapEntry('$k⭐️', v)),
      colors: {
        '1⭐️': Colors.red,
        '2⭐️': Colors.redAccent.shade100,
        '3⭐️': Colors.amber,
        '4⭐️': Colors.lightGreen.shade400,
        '5⭐️': Colors.green,
      },
      centerText: '\nAverage: ${stats.avgRating.toStringAsFixed(1)}⭐️',
      width: width,
    );
  }

  Widget AgesBarChart(
    DoctorStatistics stats, {
    required double width,
  }) =>
      CustomBarChart(stats.groupedPatientsByAge, width: width);

  Widget AppointmentDateChart(DoctorImagingCenterStatistics stats) {
    // todo
    return Container();
  }

  Widget CustomPieChart(
    Map<String, int> map, {
    required Map<String, Color> colors,
    required double width,
    String? centerText,
  }) {
    final sum = map.values.reduce((v, e) => v + e);

    final theme = Theme.of(context).textTheme;
    final bodyLarge = theme.bodyLarge?.copyWith(fontWeight: FontWeight.w900);
    final bodyMedium = theme.bodyMedium?.copyWith(fontWeight: FontWeight.bold);

    return SizedBox(
      height: width * 3 / 5,
      width: width,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sections: map.entries
                        .map(
                          (e) => PieChartSectionData(
                            title:
                                '${(e.value / sum * 100).toStringAsFixed(1)}%',
                            color: colors[e.key],
                            value: e.value.toDouble(),
                            radius: width * 3 / 5 / 3,
                            titleStyle: bodyLarge,
                          ),
                        )
                        .toList(),
                    centerSpaceRadius: double.infinity,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Total: $sum${centerText ?? ''}',
                    textAlign: TextAlign.center,
                    style: bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: colors.entries
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: e.value,
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(e.key.capitalize!, style: bodyMedium)
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget CustomBarChart(
    Map<int, int> map, {
    required double width,
    String? xTitle,
    String? yTitle,
  }) {
    final theme = Theme.of(context).textTheme;
    final bodyLarge = theme.bodyLarge?.copyWith(fontWeight: FontWeight.w900);
    final bodyMedium = theme.bodyMedium?.copyWith(fontWeight: FontWeight.bold);

    Map<Pair<int, int>, int> data = map.map((k, v) => MapEntry(Pair(k, k), v));
    final needsGrouping = map.keys.length >= 7;
    const rangeSize = 2;

    if (needsGrouping) {
      final minAge = map.keys.reduce(min);
      final maxAge = map.keys.reduce(max);

      data = {};
      int rangeStart = minAge, rangeEnd = rangeStart + rangeSize;

      while (true) {
        data[Pair(rangeStart, rangeEnd)] = Map.fromEntries(map.entries
                .where((e) => rangeStart <= e.key && e.key < rangeEnd))
            .values
            .reduce((v, e) => v + e);
        rangeStart += rangeSize;
        rangeEnd += rangeSize;

        if (rangeEnd >= maxAge) break;
      }
    }

    return SizedBox(
      height: width * 3 / 5,
      width: width,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 30,
                showTitles: true,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    !needsGrouping
                        ? '$value'
                        : '${value - rangeSize / 2}-${value + rangeSize / 2}',
                  ),
                ),
              ),
            ),
          ),
          gridData: FlGridData(checkToShowVerticalLine: (_) => false),
          barGroups: data.entries
              .map(
                (e) => BarChartGroupData(
                  x: (e.key.first + e.key.second) ~/ 2,
                  barRods: [
                    BarChartRodData(toY: e.value.toDouble()),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
