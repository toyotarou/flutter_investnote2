import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../collections/invest_name.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';

import '../../utilities/utilities.dart';

class InvestGraphGuideAlert extends ConsumerStatefulWidget {
  const InvestGraphGuideAlert(
      {super.key,
      required this.investGraphGuideNames,
      required this.investNameList,
      required this.investGraphGuideFrames});

  final List<String> investGraphGuideFrames;
  final List<String> investGraphGuideNames;
  final List<InvestName> investNameList;

  @override
  ConsumerState<InvestGraphGuideAlert> createState() => _InvestGraphGuideAlertState();
}

class _InvestGraphGuideAlertState extends ConsumerState<InvestGraphGuideAlert>
    with ControllersMixin<InvestGraphGuideAlert> {
  final Utility _utility = Utility();

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: Column(
            children: <Widget>[
              Container(width: context.screenSize.width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () => investGraphNotifier.setWideGraphDisplay(flag: !investGraphState.wideGraphDisplay),
                    icon: Icon(
                      Icons.show_chart,
                      color: investGraphState.wideGraphDisplay ? Colors.yellowAccent : Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      investGraphNotifier.setSelectedGraphId(id: 0);

                      investGraphNotifier.setSelectedGraphName(name: '');
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: displayGraphGuide()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayGraphGuide() {
    final List<Widget> list = <Widget>[];

    final List<Color> twelveColor = _utility.getTwelveColor();

    for (int i = 0; i < widget.investGraphGuideNames.length; i++) {
      list.add(GestureDetector(
        onTap: () {
          final InvestName investName = widget.investNameList
              .where((InvestName element) => element.name == widget.investGraphGuideNames[i])
              .first;

          investGraphNotifier.setSelectedGraphId(id: investName.relationalId);

          investGraphNotifier.setSelectedGraphName(name: investName.name);

          investGraphNotifier.setSelectedGraphColor(color: twelveColor[i % 12]);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: (investGraphState.selectedGraphColor != null &&
                        widget.investGraphGuideNames[i] == investGraphState.selectedGraphName)
                    ? investGraphState.selectedGraphColor!
                    : Colors.transparent,
              ),
            ),
          ),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(backgroundColor: twelveColor[i % 12].withOpacity(0.4), radius: 15),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.investGraphGuideFrames[i],
                          style: const TextStyle(fontSize: 12, color: Colors.lightBlueAccent),
                        ),
                        Text(
                          widget.investGraphGuideNames[i],
                          style: TextStyle(
                            fontSize: 12,
                            color: (investGraphState.selectedGraphColor != null &&
                                    widget.investGraphGuideNames[i] == investGraphState.selectedGraphName)
                                ? investGraphState.selectedGraphColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ));
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) => list[index], childCount: list.length),
        ),
      ],
    );
  }
}
