import 'package:flutter/material.dart';
import 'package:services_controll_app/models/report.model.dart';
import 'package:services_controll_app/services/order.service.dart';
import 'package:services_controll_app/utils/sample_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatusPage extends SampleView {
  StatusPage({Key? key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends SampleViewState {
  _StatusPageState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, canShowMarker: false, header: '');
    super.initState();
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
            return _buildCustomizedColumnChart(report);
          }),
    );
  }

  /// Get customized column chart
  SfCartesianChart _buildCustomizedColumnChart(Report report) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Status Serviços'),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      series: <ChartSeries<ChartSampleData, String>>[
        ColumnSeries<ChartSampleData, String>(
          onCreateRenderer: (ChartSeries<ChartSampleData, String> series) {
            return _CustomColumnSeriesRenderer();
          },
          isTrackVisible: false,
          dataLabelSettings: const DataLabelSettings(
              isVisible: true, labelAlignment: ChartDataLabelAlignment.middle),
          dataSource: <ChartSampleData>[
            ChartSampleData(
                x: 'Aberto',
                y: report.totalOrderOpen,
                pointColor: const Color.fromARGB(53, 92, 125, 1)),
            ChartSampleData(
                x: 'Em Progresso',
                y: report.totalOrderInProgress,
                pointColor: const Color.fromARGB(192, 108, 132, 1)),
            ChartSampleData(
                x: 'Atrasado',
                y: report.totalOrderDelayed,
                pointColor: const Color.fromARGB(246, 114, 128, 1)),
            ChartSampleData(
                x: 'Completo',
                y: report.totalOrderCompleted,
                pointColor: const Color.fromARGB(246, 114, 126, 1)),
          ],
          width: 0.8,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
        )
      ],
      tooltipBehavior: _tooltipBehavior,
    );
  }
}

class _CustomColumnSeriesRenderer extends ColumnSeriesRenderer {
  _CustomColumnSeriesRenderer();

  @override
  ChartSegment createSegment() {
    return _ColumnCustomPainter();
  }
}

class _ColumnCustomPainter extends ColumnSegment {
  List<Color> colorList = <Color>[
    Colors.grey.shade600,
    Colors.blueAccent.shade700,
    Colors.redAccent.shade700,
    Colors.greenAccent.shade700,
  ];
  @override
  int get currentSegmentIndex => super.currentSegmentIndex!;

  @override
  Paint getFillPaint() {
    final Paint customerFillPaint = Paint();
    customerFillPaint.isAntiAlias = false;
    customerFillPaint.color = colorList[currentSegmentIndex];
    customerFillPaint.style = PaintingStyle.fill;
    return customerFillPaint;
  }

  @override
  Paint getStrokePaint() {
    final Paint customerStrokePaint = Paint();
    customerStrokePaint.isAntiAlias = false;
    customerStrokePaint.color = Colors.transparent;
    customerStrokePaint.style = PaintingStyle.stroke;
    return customerStrokePaint;
  }

  @override
  void onPaint(Canvas canvas) {
    double x, y;
    x = segmentRect.center.dx;
    y = segmentRect.top;
    double width = 0;
    const double height = 20;
    width = segmentRect.width;
    final Paint paint = Paint();
    paint.color = getFillPaint().color;
    paint.style = PaintingStyle.fill;
    final Path path = Path();
    final double factor = segmentRect.height * (1 - animationFactor);
    path.moveTo(x - width / 2, y + factor + height);
    path.lineTo(x, (segmentRect.top + factor + height) - height);
    path.lineTo(x + width / 2, y + factor + height);
    path.lineTo(x + width / 2, segmentRect.bottom + factor);
    path.lineTo(x - width / 2, segmentRect.bottom + factor);
    path.close();
    canvas.drawPath(path, paint);
  }
}
