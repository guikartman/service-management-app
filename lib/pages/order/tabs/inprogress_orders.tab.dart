import 'package:flutter/material.dart';
import 'package:services_controll_app/models/order.model.dart';
import 'package:services_controll_app/services/order.service.dart';
import 'package:services_controll_app/widgets/order_title.dart';

class InprogressOrdersTab extends StatefulWidget {
  @override
  _InprogressOrdersTabState createState() => _InprogressOrdersTabState();
}

class _InprogressOrdersTabState extends State<InprogressOrdersTab> {
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
        var inProgressOrders = allOrders
            .where((order) => (order.status == 'OPEN' &&
                (order.startDate.isAtSameMomentAs(DateTime.now()) ||
                    order.startDate.isAfter(DateTime.now()))))
            .toList();
        return ListView.builder(
            itemCount: inProgressOrders.length,
            itemBuilder: (BuildContext context, int index) {
              return OrderTitle(order: inProgressOrders[index]);
            });
      },
    ));
  }
}
