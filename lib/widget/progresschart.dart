import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:databasecrud/models/data_entry.dart';
import 'package:tuple/tuple.dart';

import 'dart:math' as math;
import 'dart:ui' as ui;

var txColor = const Color(0xffF3C623);

class ProgressChart extends StatefulWidget {
  //static const int NUMBER_OF_DAYS = 31;
  final List<PowerEntry> entries;

  ProgressChart(this.entries);

  @override
  _ProgressChartState createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart> {
  int numberOfDays = 31;
  int previousNumOfDays;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: (){},
      onScaleStart: (scaleDetails) =>
          setState(() => previousNumOfDays = numberOfDays),
      onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
        setState(() {
          int newNumberOfDays =
              (previousNumOfDays / scaleDetails.scale).round();
          if (newNumberOfDays >= 7) {
            numberOfDays = newNumberOfDays;
          }
        });
      },
      child: CustomPaint(
        painter: ChartPainter(_prepareEntryList(widget.entries), numberOfDays),
      ),
    );
  }

  List<PowerEntry> _prepareEntryList(List<PowerEntry> initialEntries) {
    DateTime beginningDate = _getStartDateOfChart(numberOfDays);
    List<PowerEntry> entries = initialEntries
        .where((entry) => entry.dateTime.isAfter(beginningDate))
        .toList();
    if (_isMissingEntryFromBeginningDate(beginningDate, entries) &&
        _isAnyEntryBeforeBeginningDate(beginningDate, initialEntries)) {
      _addFakeEntryOnTheChartBeginning(initialEntries, entries, beginningDate);
    }
    return entries;
  }

  void _addFakeEntryOnTheChartBeginning(List<PowerEntry> initialEntries,
      List<PowerEntry> entries, DateTime beginningDate) {
    List<PowerEntry> entriesNotInChart =
        initialEntries.where((entry) => !entries.contains(entry)).toList();
    PowerEntry firstEntryAfterBeginning = entries.last;
    PowerEntry lastEntryBeforeBeginning = entriesNotInChart.first;
    PowerEntry fakeEntry = new PowerEntry(
        beginningDate,
        _calculateValueOnBeginningDate(
            lastEntryBeforeBeginning, firstEntryAfterBeginning, beginningDate));
    entries.add(fakeEntry);
  }

  bool _isMissingEntryFromBeginningDate(
      DateTime beginningDate, List<PowerEntry> entries) {
    return !entries.any((entry) =>
        entry.dateTime.day == beginningDate.day &&
        entry.dateTime.month == beginningDate.month &&
        entry.dateTime.year == beginningDate.year);
  }

  bool _isAnyEntryBeforeBeginningDate(
      DateTime beginningDate, List<PowerEntry> entries) {
    return entries.any((entry) => entry.dateTime.isBefore(beginningDate));
  }

  double _calculateValueOnBeginningDate(PowerEntry lastEntryBeforeBeginning,
      PowerEntry firstEntryAfterBeginning, DateTime beginningDate) {
    DateTime firstEntryDateTime =
        _copyDateWithoutTime(firstEntryAfterBeginning.dateTime);
    DateTime lastEntryDateTime =
        _copyDateWithoutTime(lastEntryBeforeBeginning.dateTime);

    int differenceInDays =
        firstEntryDateTime.difference(lastEntryDateTime).inDays;

    double differenceInValue =
        firstEntryAfterBeginning.value - lastEntryBeforeBeginning.value;

    int differenceInDaysFromBeginning =
        beginningDate.difference(lastEntryDateTime).inDays;

    double valueChangeFromLastEntry =
        (differenceInValue * differenceInDaysFromBeginning) / differenceInDays;

    double estimatedValue =
        lastEntryBeforeBeginning.value + valueChangeFromLastEntry;
    return estimatedValue;
  }

  DateTime _copyDateWithoutTime(DateTime dateTime) {
    return new DateTime.utc(dateTime.year, dateTime.month, dateTime.day);
  }
}

class ChartPainter extends CustomPainter {
  final List<PowerEntry> entries;
  final int numberOfDays;

  ChartPainter(this.entries, this.numberOfDays);

  double leftOffsetStart;
  double topOffsetEnd;
  double drawingWidth;
  double drawingHeight;

  static const int NUMBER_OF_HORIZONTAL_LINES = 5;

  @override
  void paint(Canvas canvas, Size size) {
    leftOffsetStart = size.width * 0.07;
    topOffsetEnd = size.height * 0.85;
    drawingWidth = size.width * 0.88;
    drawingHeight = topOffsetEnd;

    if (entries.isNotEmpty) {
      Tuple2<int, int> borderLineValues = _getMinAndMaxValues(entries);
      _drawHorizontalLinesAndLabels(
          canvas, size, borderLineValues.item1, borderLineValues.item2);
      _drawBottomLabels(canvas, size);

      _drawLines(canvas, borderLineValues.item1, borderLineValues.item2);
    } else {}
  }

  @override
  bool shouldRepaint(ChartPainter old) => true;

  ///draws actual chart
  void _drawLines(ui.Canvas canvas, int minLineValue, int maxLineValue) {
    final paint = new Paint()
      ..color = txColor
      ..strokeWidth = 3.0;
    DateTime beginningOfChart = _getStartDateOfChart(numberOfDays);
    for (int i = 0; i < entries.length - 1; i++) {
      
      Offset startEntryOffset = _getEntryOffset(
          entries[i], beginningOfChart, minLineValue, maxLineValue);
      Offset endEntryOffset = _getEntryOffset(
          entries[i + 1], beginningOfChart, minLineValue, maxLineValue);
      canvas.drawLine(startEntryOffset, endEntryOffset, paint);
      canvas.drawCircle(endEntryOffset, 3.0, paint);
    }
    canvas.drawCircle(
        _getEntryOffset(
            entries.first, beginningOfChart, minLineValue, maxLineValue),
        5.0,
        paint);
  }

  /// Draws horizontal lines and labels informing about power values attached to those lines
  void _drawHorizontalLinesAndLabels(
      Canvas canvas, Size size, int minLineValue, int maxLineValue) {
    final paint = new Paint()..color = Colors.yellow;
    int lineStep = _calculateHorizontalLineStep(maxLineValue, minLineValue);
    double offsetStep = _calculateHorizontalOffsetStep;
    for (int line = 0; line < NUMBER_OF_HORIZONTAL_LINES; line++) {
      double yOffset = line * offsetStep;
      _drawHorizontalLabel(maxLineValue, line, lineStep, canvas, yOffset);
      _drawHorizontalLine(canvas, yOffset, size, paint);
    }
  }

  void _drawHorizontalLine(
      ui.Canvas canvas, double yOffset, ui.Size size, ui.Paint paint) {
    canvas.drawLine(
      new Offset(leftOffsetStart, 5 + yOffset),
      new Offset(size.width, 5 + yOffset),
      paint,
    );
  }

  void _drawHorizontalLabel(int maxLineValue, int line, int lineStep,
      ui.Canvas canvas, double yOffset) {
    ui.Paragraph paragraph =
        _buildParagraphForLeftLabel(maxLineValue, line, lineStep);
    canvas.drawParagraph(
      paragraph,
      new Offset(0.0, yOffset),
    );
  }

  /// Calculates offset difference between horizontal lines.
  ///
  /// e.g. between every line should be 100px space.
  double get _calculateHorizontalOffsetStep {
    return drawingHeight / (NUMBER_OF_HORIZONTAL_LINES - 1);
  }

  /// Calculates power difference between horizontal lines.
  ///
  /// e.g. every line should increment value by 5
  int _calculateHorizontalLineStep(int maxLineValue, int minLineValue) {
    return (maxLineValue - minLineValue) ~/ (NUMBER_OF_HORIZONTAL_LINES - 1);
  }

  void _drawBottomLabels(Canvas canvas, Size size) {
    for (int daysFromStart = numberOfDays;
        daysFromStart > 0;
        daysFromStart = (daysFromStart - (numberOfDays / 4)).round()) {
      double offsetXbyDay = drawingWidth / numberOfDays;
      double offsetX = leftOffsetStart + offsetXbyDay * daysFromStart;
      ui.Paragraph paragraph = _buildParagraphForBottomLabel(daysFromStart);
      canvas.drawParagraph(
        paragraph,
        new Offset(offsetX - 50.0, 10.0 + drawingHeight),
      );
    }
  }

  ///Builds paragraph for label placed on the bottom (dates)
  ui.Paragraph _buildParagraphForBottomLabel(int daysFromStart) {
    ui.ParagraphBuilder builder = new ui.ParagraphBuilder(
        new ui.ParagraphStyle(fontSize: 10.0, textAlign: TextAlign.right))
      ..pushStyle(new ui.TextStyle(color: Colors.white))
      ..addText(new DateFormat('d MMM').format(new DateTime.now()
          .subtract(new Duration(days: numberOfDays - daysFromStart))));
    final ui.Paragraph paragraph = builder.build()
      ..layout(new ui.ParagraphConstraints(width: 50.0));
    return paragraph;
  }

  ///Builds text paragraph for label placed on the left side of a chart (values)
  ui.Paragraph _buildParagraphForLeftLabel(
      int maxLineValue, int line, int lineStep) {
    ui.ParagraphBuilder builder = new ui.ParagraphBuilder(
      new ui.ParagraphStyle(
        fontSize: 10.0,
        textAlign: TextAlign.right,
      ),
    )
      ..pushStyle(new ui.TextStyle(color: Colors.white))
      ..addText((maxLineValue - line * lineStep).toString());
    final ui.Paragraph paragraph = builder.build()
      ..layout(new ui.ParagraphConstraints(width: leftOffsetStart - 4));
    return paragraph;
  }

  ///Produces minimal and maximal value of horizontal line that will be displayed
  Tuple2<int, int> _getMinAndMaxValues(List<PowerEntry> entries) {
    double maxValue = entries.map((entry) => entry.value).reduce(math.max);
    double minValue = entries.map((entry) => entry.value).reduce(math.min);

    int maxLineValue = maxValue.ceil();
    int difference = maxLineValue - minValue.floor();
    int toSubtract = (NUMBER_OF_HORIZONTAL_LINES - 1) -
        (difference % (NUMBER_OF_HORIZONTAL_LINES - 1));
    if (toSubtract == NUMBER_OF_HORIZONTAL_LINES - 1) {
      toSubtract = 0;
    }
    int minLineValue = minValue.floor() - toSubtract;

    return new Tuple2(minLineValue, maxLineValue);
  }

  /// Calculates offset at which given entry should be painted
  Offset _getEntryOffset(PowerEntry entry, DateTime beginningOfChart,
      int minLineValue, int maxLineValue) {
    int daysFromBeginning = entry.dateTime.difference(beginningOfChart).inDays;
    double relativeXposition = daysFromBeginning / numberOfDays;
    double xOffset = leftOffsetStart + relativeXposition * drawingWidth;
    double relativeYposition =
        (entry.value - minLineValue) / (maxLineValue - minLineValue);
    double yOffset = 5 + drawingHeight - relativeYposition * drawingHeight;
    return new Offset(xOffset, yOffset);
  }
}

DateTime _getStartDateOfChart(int daysToSubtract) {
  DateTime now = new DateTime.now();
  DateTime beginningOfChart = now.subtract(
      //new Duration(days: daysToSubtract, hours: now.hour, minutes: now.minute));
      new Duration(days: daysToSubtract, hours: now.hour, minutes: now.minute));
  return beginningOfChart;
}
