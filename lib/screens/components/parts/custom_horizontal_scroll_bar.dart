import 'package:flutter/material.dart';
import 'package:invest_note/extensions/extensions.dart';
import 'package:invest_note/screens/components/invest_graph_guide_alert.dart';
import 'package:invest_note/screens/components/parts/invest_dialog.dart';

class CustomHorizontalScrollBar extends StatefulWidget {
  const CustomHorizontalScrollBar(
      {super.key,
      required this.scrollController,
      required this.investGraphGuideNames});

  final ScrollController scrollController;
  final List<String> investGraphGuideNames;

  @override
  State<CustomHorizontalScrollBar> createState() =>
      _CustomHorizontalScrollBarState();
}

class _CustomHorizontalScrollBarState extends State<CustomHorizontalScrollBar> {
  double _alignmentX = -1;

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
      alignment: Alignment(1, _alignmentX),
      child: GestureDetector(
        onTap: () {
          InvestDialog(
            context: context,
            widget: InvestGraphGuideAlert(
              investGraphGuideNames: widget.investGraphGuideNames,
            ),
            paddingTop: context.screenSize.height * 0.4,
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
      final position = widget.scrollController.position;
      final ratio = position.pixels / position.maxScrollExtent;
      _alignmentX = ratio * 2 - 1;
    });
  }
}
