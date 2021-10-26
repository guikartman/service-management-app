import 'package:flutter/material.dart';
import 'package:services_controll_app/models/order.model.dart';
import 'package:services_controll_app/services/order.service.dart';
import 'package:services_controll_app/widgets/order_title.dart';

class CompletedOrdersTab extends StatefulWidget {
  @override
  _CompletedOrdersTabState createState() => _CompletedOrdersTabState();
}

class _CompletedOrdersTabState extends State<CompletedOrdersTab> {
  @override
  Widget build(BuildContext context) {
    final OrderService orderService = OrderService();
    return Scaffold(
        body: FutureBuilder<List<Order>>(
      future: orderService.getOrders(),
      builder: (_, AsyncSnapshot<List<Order>> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (snapshot.hasError)
          return Center(
            child: Text(snapshot.error.toString()),
          );

        var allOrders = snapshot.data!;
        var completedOrders =
            allOrders.where((order) => order.status == 'COMPLETED').toList();
        return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: completedOrders.length,
            itemBuilder: (BuildContext context, int index) {
              return OrderTitle(order: completedOrders[index]);
            });
      },
    ));
  }
}
