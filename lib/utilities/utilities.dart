import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Utility {
  ///
  Color getYoubiColor({
    required String date,
    required String youbiStr,
    required Map<String, String> holidayMap,
  }) {
    var color = Colors.black.withOpacity(0.2);

    switch (youbiStr) {
      case 'Sunday':
        color = Colors.redAccent.withOpacity(0.2);
        break;

      case 'Saturday':
        color = Colors.blueAccent.withOpacity(0.2);
        break;

      default:
        color = Colors.black.withOpacity(0.2);
        break;
    }

    if (holidayMap[date] != null) {
      color = Colors.greenAccent.withOpacity(0.2);
    }

    return color;
  }

  ///
  FlGridData getFlGridData() {
    final flline = FlLine(color: Colors.white30, strokeWidth: 1);

    return FlGridData(
      show: true,
      drawVerticalLine: true,

      //横線
      getDrawingHorizontalLine: (value) => flline,

      //縦線
      getDrawingVerticalLine: (value) => flline,
    );
  }

  ///
  List<Color> getTwelveColor() {
    return [
      const Color(0xffdb2f20),
      const Color(0xffefa43a),
      const Color(0xfffdf551),
      const Color(0xffa6c63d),
      const Color(0xff439638),
      const Color(0xff469c9e),
      const Color(0xff48a0e1),
      const Color(0xff3070b1),
      const Color(0xff020c75),
      const Color(0xff931c7a),
      const Color(0xffdc2f81),
      const Color(0xffdb2f5c),
    ];
  }
}
