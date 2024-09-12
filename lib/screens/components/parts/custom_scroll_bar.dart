import 'package:flutter/material.dart';
import '../../../collections/invest_name.dart';
import '../../../extensions/extensions.dart';
import '../invest_graph_guide_alert.dart';
import 'invest_dialog.dart';

class CustomScrollBar extends StatefulWidget {
  const CustomScrollBar(
      {super.key,
      required this.scrollController,
      required this.investGraphGuideNames,
      required this.investNameList,
      required this.investGraphGuideFrames});

  final ScrollController scrollController;
  final List<String> investGraphGuideFrames;
  final List<String> investGraphGuideNames;
  final List<InvestName> investNameList;

  @override
  State<CustomScrollBar> createState() => _CustomScrollBarState();
}

class _CustomScrollBarState extends State<CustomScrollBar> {
  double _alignmentY = -1;

  ///
  @override
  void initState() {
    widget.scrollController.addListener(_scrollingListener);

    super.initState();
  }

  ///
  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(1, _alignmentY),
      child: GestureDetector(
        onTap: () {
          InvestDialog(
            context: context,
            widget: InvestGraphGuideAlert(
              investGraphGuideFrames: widget.investGraphGuideFrames,
              investGraphGuideNames: widget.investGraphGuideNames,
              investNameList: widget.investNameList,
            ),
            paddingTop: context.screenSize.height * 0.2,
            clearBarrierColor: true,
          );
        },
        child: CircleAvatar(
          backgroundColor: Colors.orangeAccent.withOpacity(0.3),
          child: Icon(
            Icons.info_outline,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  ///
  void _scrollingListener() {
    setState(() {
      final ScrollPosition position = widget.scrollController.position;
      final double ratio = position.pixels / position.maxScrollExtent;
      _alignmentY = ratio * 2 - 1;
    });
  }
}
