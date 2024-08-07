import 'package:flutter/material.dart';
import 'package:invest_note/extensions/extensions.dart';
import 'package:invest_note/utilities/utilities.dart';

class InvestGraphGuideAlert extends StatelessWidget {
  InvestGraphGuideAlert({super.key, required this.investGraphGuideNames});

  final List<String> investGraphGuideNames;

  final Utility _utility = Utility();

  ///
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: context.screenSize.width),
          Expanded(child: displayGraphGuide()),
        ],
      ),
    );
  }

  ///
  Widget displayGraphGuide() {
    final list = <Widget>[];

    final twelveColor = _utility.getTwelveColor();

    for (var i = 0; i < investGraphGuideNames.length; i++) {
      list.add(Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: twelveColor[i],
                radius: 10,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  investGraphGuideNames[i],
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
        ],
      ));
    }

    return SingleChildScrollView(child: Column(children: list));
  }
}
