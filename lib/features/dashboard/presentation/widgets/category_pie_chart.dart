import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/types/money.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../providers/dashboard_providers.dart';

class CategoryPieChart extends StatefulWidget {
  const CategoryPieChart({
    super.key,
    required this.spends,
    required this.categoriesById,
  });

  final List<CategorySpend> spends;
  final Map<int, Category> categoriesById;

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.spends.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('No expenses this month')),
      );
    }

    final total = widget.spends.fold<int>(0, (s, e) => s + e.totalMinor);

    return SizedBox(
      height: 240,
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex =
                          response.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: List.generate(widget.spends.length, (i) {
                  final spend = widget.spends[i];
                  final cat = widget.categoriesById[spend.categoryId];
                  final isTouched = i == _touchedIndex;
                  final percent = (spend.totalMinor / total) * 100;

                  return PieChartSectionData(
                    value: spend.totalMinor.toDouble(),
                    color: _parseColor(cat?.colorHex ?? '#757575'),
                    title: percent >= 5 ? '${percent.toStringAsFixed(0)}%' : '',
                    radius: isTouched ? 65 : 55,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ListView(
              children: widget.spends.take(6).map((s) {
                final cat = widget.categoriesById[s.categoryId];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _parseColor(cat?.colorHex ?? '#757575'),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cat?.name ?? 'Other',
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(
                          Money.fromMinor(s.totalMinor, 'INR'),
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }
}