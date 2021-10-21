import 'package:flutter/material.dart';
import 'package:services_controll_app/pages/index.dart';
import 'package:services_controll_app/pages/order/order.page.dart';
import 'package:services_controll_app/pages/order/tabs/completed_orders.tab.dart';
import 'package:services_controll_app/pages/order/tabs/delayed_orders.tab.dart';
import 'package:services_controll_app/pages/order/tabs/inprogress_orders.tab.dart';
import 'package:services_controll_app/widgets/menu.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
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
          title: const Text('Serviços'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => OrderPage()))
                      .then((_) => setState(() {}));
                },
                icon: Icon(Icons.add))
          ],
        ),
        drawer: Menu(),
        body: TabBarView(
          children: [
            OpenOrdersTab(),
            InprogressOrdersTab(),
            DelayedOrdersTab(),
            CompletedOrdersTab()
          ],
          controller: controller,
        ),
        bottomNavigationBar: Material(
          color: Colors.blue,
          child: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home_repair_service),
                text: 'Abertos',
              ),
              Tab(
                icon: Icon(Icons.build_circle),
                text: 'Fazendo',
              ),
              Tab(
                icon: Icon(Icons.access_time_filled),
                text: 'Atrasados',
              ),
              Tab(
                icon: Icon(Icons.check_circle_outline_rounded),
                text: 'Completos',
              ),
            ],
            controller: controller,
          ),
        ));
  }
}
