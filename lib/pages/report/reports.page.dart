import 'package:flutter/material.dart';
import 'package:services_controll_app/pages/report/tabs/finantials.reports.dart';
import 'package:services_controll_app/pages/report/tabs/status.reports.dart';
import 'package:services_controll_app/widgets/menu.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Graficos'),
          centerTitle: true,
        ),
        drawer: Menu(),
        body: TabBarView(
          children: [
            FinantialsPage(),
            StatusPage(),
          ],
          controller: controller,
        ),
        bottomNavigationBar: Material(
          color: Colors.blue,
          child: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.monetization_on_outlined),
                text: 'Financeiro',
              ),
              Tab(
                icon: Icon(Icons.account_tree),
                text: 'Status',
              ),
            ],
            controller: controller,
          ),
        ));
  }
}
