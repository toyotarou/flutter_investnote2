import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../extensions/extensions.dart';

class ShintakuNameInputAlert extends StatefulWidget {
  const ShintakuNameInputAlert({super.key});

  @override
  State<ShintakuNameInputAlert> createState() => _ShintakuNameInputAlertState();
}

class _ShintakuNameInputAlertState extends State<ShintakuNameInputAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              const Text('信託名称登録'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
            ],
          ),
        ),
      ),
    );
  }
}
