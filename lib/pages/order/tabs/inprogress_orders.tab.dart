import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:services_controll_app/models/order.model.dart';
import 'package:services_controll_app/services/order.service.dart';
import 'package:services_controll_app/widgets/order_title.dart';

class InprogressOrdersTab extends StatefulWidget {
  @override
  _InprogressOrdersTabState createState() => _InprogressOrdersTabState();
}

class _InprogressOrdersTabState extends State<InprogressOrdersTab> {
  final dateFormat = DateFormat('dd/MM/yyyy');

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
                (order.startDate.isAtSameMomentAs(
                        dateFormat.parse(dateFormat.format(DateTime.now()))) ||
                    order.startDate.isBefore(DateTime.now()) &&
                        (order.deliveryDate.isAfter(DateTime.now()) ||
                            order.deliveryDate.isAtSameMomentAs(dateFormat
                                .parse(dateFormat.format(DateTime.now())))))))
            .toList();
        return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: inProgressOrders.length,
            itemBuilder: (BuildContext context, int index) {
              return OrderTitle(order: inProgressOrders[index]);
            });
      },
    ));
  }
}
