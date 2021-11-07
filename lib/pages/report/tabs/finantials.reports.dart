import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:services_controll_app/models/report.model.dart';
import 'package:services_controll_app/services/order.service.dart';

class FinantialsPage extends StatefulWidget {
  FinantialsPage({Key? key}) : super(key: key);

  @override
  _FinantialsPageState createState() => _FinantialsPageState();
}

class _FinantialsPageState extends State<FinantialsPage>
    with TickerProviderStateMixin {
  var numberFormat = NumberFormat("###0.00#", "pt_BR");

  late AnimationController _controller;
  late Animation<double> _animation;
  late double _earned;
  late double _pending;
  late double _earnedHeight;
  late double _pendingHeight;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _setHeightBalances(Report report) {
    if (report.totalCash == 0) {
      _earnedHeight = 0;
      _pendingHeight = 0;
      _earned = 0;
      _pending = 0;
    }
    var maxHeight = MediaQuery.of(context).size.height - 400;
    var wHeight = (report.totalCashEarned / report.totalCash) * maxHeight;
    var dHeight =
        ((report.totalCash - report.totalCashEarned) / report.totalCash) *
            maxHeight;

    _earnedHeight = wHeight;
    _pendingHeight = dHeight;
    _earned = report.totalCashEarned;
    _pending = (report.totalCash - report.totalCashEarned);
  }

  @override
  Widget build(BuildContext context) {
    var orderService = OrderService();
    return Scaffold(
        body: FutureBuilder<Report>(
      future: orderService.getReports(),
      builder: (_, AsyncSnapshot<Report> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (snapshot.hasError)
          return Center(
            child: Text(snapshot.error.toString()),
          );

        var report = snapshot.data!;
        _setHeightBalances(report);

        return ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  height: 100,
                  alignment: Alignment.center,
                  child: Text(
                    'R\$${numberFormat.format(report.totalCash)}',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                Container(
                    padding: EdgeInsets.only(bottom: 80),
                    height: MediaQuery.of(context).size.height - 220,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _BarLine(
                            _pendingHeight,
                            Colors.redAccent.shade700,
                            'Pendente',
                            numberFormat.format(_pending),
                            _animation),
                        _BarLine(
                            _earnedHeight,
                            Colors.greenAccent.shade700,
                            'Recebido',
                            numberFormat.format(_earned),
                            _animation)
                      ],
                    )),
              ],
            )
          ],
        );
      },
    ));
  }
}

class _BarLine extends StatelessWidget {
  const _BarLine(
    this.height,
    this.color,
    this.label,
    this.amount,
    this.animation,
  );
  final double height;
  final String label;
  final Color color;
  final String amount;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AnimatedBuilder(
            animation: animation,
            builder: (_, __) {
              return Container(
                height: animation.value * height,
                width: 100,
                color: color,
              );
            }),
        SizedBox(
          height: 3,
        ),
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          'R\$ $amount',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
