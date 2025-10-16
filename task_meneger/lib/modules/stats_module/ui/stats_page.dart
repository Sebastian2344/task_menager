import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stats_provider.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20,
        children: [
          Text(
            'Statystyki',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatCard(
                icon: Icons.task,
                title: 'Zadania do wykonania',
                selector: (stats) => stats.pending,
                color: Colors.orange,
              ),
              StatCard(
                icon: Icons.done,
                title: 'Wykonane zadania',
                selector: (stats) => stats.completed,
                color: Colors.green,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatCard(
                icon: Icons.star,
                title: 'Najbardziej produktywny dzień',
                selector: (stats) => stats.productiveWeekdayName,
                color: Colors.blue,
              ),
              StatCard(
                icon: Icons.bar_chart,
                title: 'Liczba zadań w tym dniu',
                selector: (stats) => stats.maxTasksInWeekday,
                color: Colors.blueAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.icon,
  required this.title,
  required this.selector,
  required this.color,});

  final IconData icon;
  final String title;
  final Object Function(StatsProvider) selector;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.7), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Selector<StatsProvider, Object>(
            selector: (_, stats) => selector(stats),
            builder: (context, value, child) {
              return Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    ),
  );
  }
}