import 'package:flutter/material.dart';
import 'package:services_controll_app/models/order.model.dart';
import 'package:services_controll_app/services/order.service.dart';
import 'package:services_controll_app/widgets/order_title.dart';

class DelayedOrdersTab extends StatefulWidget {
  @override
  _DelayedOrdersTabState createState() => _DelayedOrdersTabState();
}

class _DelayedOrdersTabState extends State<DelayedOrdersTab> {
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
        var delayedOrders = allOrders
            .where((order) => (order.status != 'COMPLETED' &&
                order.deliveryDate.isAfter(DateTime.now())))
            .toList();
        return ListView.builder(
            itemCount: delayedOrders.length,
            itemBuilder: (BuildContext context, int index) {
              return OrderTitle(order: delayedOrders[index]);
            });
      },
    ));
  }
}
