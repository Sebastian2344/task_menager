import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_meneger/modules/stats_module/ui/stats_page.dart';
import 'package:task_meneger/modules/task_module/ui/screens/get_tasks.dart';

import '../providers/page_provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            "Menedżer zadań osobistych",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          elevation: 5,
        ),
      ),
      body: IndexedStack(
        index: context.watch<PageProvider>().currentPage,
        children: const [GetTasks(), StatsPage()],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: Consumer(
            builder: (context, PageProvider pageProvider, child) {
              int currentPage = pageProvider.currentPage;
              return BottomNavigationBar(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.indigo,
                unselectedItemColor: Colors.grey,
                currentIndex: currentPage,
                onTap: (value) => pageProvider.setCurrentPage(value),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Ekran główny',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.stacked_bar_chart),
                    label: 'Statystyki',
                  ),
                ],
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
              );
            },
          ),
        ),
      ),
    );
  }
}
