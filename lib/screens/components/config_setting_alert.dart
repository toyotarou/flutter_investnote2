import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/config.dart';
import '../../extensions/extensions.dart';
import '../../repository/configs_repository.dart';

class ConfigSettingAlert extends ConsumerStatefulWidget {
  const ConfigSettingAlert({super.key, required this.isar});

  final Isar isar;

  @override
  ConsumerState<ConfigSettingAlert> createState() => _ConfigSettingAlertState();
}

class _ConfigSettingAlertState extends ConsumerState<ConfigSettingAlert> {
  List<Config>? configList = <Config>[];

  Map<String, String> settingConfigMap = <String, String>{};

  ///
  void _init() {
    makeSettingConfigMap();
  }

  ///
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    Future(_init);

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
            children: <Widget>[
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              const Text('設定'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
//              _displayStartYearmonthSettingWidget(),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Future<void> makeSettingConfigMap() async {
    await ConfigsRepository().getConfigList(isar: widget.isar).then((List<Config>? value) {
      setState(() {
        configList = value;

        if (value!.isNotEmpty) {
          for (final Config element in value) {
            settingConfigMap[element.configKey] = element.configValue;
          }
        }
      });
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:isar/isar.dart';
//
// import '../../collections/config.dart';
// import '../../collections/credit_detail.dart';
// import '../../collections/credit_item.dart';
// import '../../extensions/extensions.dart';
// import '../../repository/configs_repository.dart';
// import '../../repository/credit_items_repository.dart';
// import '../../state/config_start_yearmonth/config_start_yearmonth_notifier.dart';
//
// import '../../state/config_start_yearmonth/config_start_yearmonth_response_state.dart';
// import 'parts/error_dialog.dart';
//
// class ConfigSettingAlert extends ConsumerStatefulWidget {
//   const ConfigSettingAlert({super.key, required this.isar, required this.creditItemCountMap});
//
//   final Isar isar;
//
//   final Map<String, List<CreditDetail>> creditItemCountMap;
//
//   ///
//   @override
//   ConsumerState<ConfigSettingAlert> createState() => _ConfigSettingAlertState();
// }
//
// class _ConfigSettingAlertState extends ConsumerState<ConfigSettingAlert> {
//   List<Config>? configList = <Config>[];
//
//   Map<String, String> settingConfigMap = <String, String>{};
//
//   List<CreditItem>? creditItemList = <CreditItem>[];
//
//   ///
//   void _init() {
//     makeSettingConfigMap();
//
//     _makeCreditItemList();
//   }
//
//   ///
//   @override
//   Widget build(BuildContext context) {
//     // ignore: always_specify_types
//     Future(_init);
//
//     return AlertDialog(
//       titlePadding: EdgeInsets.zero,
//       contentPadding: EdgeInsets.zero,
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.zero,
//       content: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         width: double.infinity,
//         height: double.infinity,
//         child: DefaultTextStyle(
//           style: GoogleFonts.kiwiMaru(fontSize: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               const SizedBox(height: 20),
//               Container(width: context.screenSize.width),
//               const Text('設定'),
//               Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
//               _displayStartYearmonthSettingWidget(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   ///
//   Widget _displayStartYearmonthSettingWidget() {
//     //==============================//
//     int configSelectedyear = -1;
//     int configSelectedmonth = -1;
//
//     if (settingConfigMap['start_yearmonth'] != null && settingConfigMap['start_yearmonth'] != '') {
//       final List<String> exYearmonth = settingConfigMap['start_yearmonth']!.split('-');
//
//       if (exYearmonth.length > 1) {
//         if (exYearmonth[0] != '' && exYearmonth[1] != '') {
//           configSelectedyear = exYearmonth[0].toInt();
//           configSelectedmonth = exYearmonth[1].toInt() - 1;
//         }
//       }
//     }
//     //==============================//
//
//     final ConfigStartYearmonthResponseState configStartYearmonthState = ref.watch(configStartYearmonthProvider);
//
//     return Container(
//       padding: const EdgeInsets.all(5),
//       margin: const EdgeInsets.only(bottom: 5),
//       decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.2))),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(width: context.screenSize.width),
//           const Text('開始する年月'),
//           const SizedBox(height: 10),
//           Wrap(
//             children: configStartYearmonthState.startYears.map((int e) {
//               return GestureDetector(
//                 onTap: () {
//                   (settingConfigMap['start_yearmonth'] != null)
//                       ? updateConfig(key: 'start_yearmonth', value: '', closeFlag: false)
//                       : inputConfig(key: 'start_yearmonth', value: '', closeFlag: false);
//
//                   ref.read(configStartYearmonthProvider.notifier).setSelectedYear(year: e);
//                 },
//                 child: Container(
//                   width: context.screenSize.width / 6,
//                   margin: const EdgeInsets.symmetric(horizontal: 3),
//                   padding: const EdgeInsets.symmetric(vertical: 3),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white.withOpacity(0.2)),
//                     color: (configStartYearmonthState.selectedStartYear == e || configSelectedyear == e)
//                         ? Colors.yellowAccent.withOpacity(0.2)
//                         : Colors.transparent,
//                   ),
//                   child: Text(e.toString()),
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 10),
//           Wrap(
//             children: configStartYearmonthState.startMonths.map((int e) {
//               return GestureDetector(
//                 onTap: () {
//                   (settingConfigMap['start_yearmonth'] != null)
//                       ? updateConfig(key: 'start_yearmonth', value: '', closeFlag: false)
//                       : inputConfig(key: 'start_yearmonth', value: '', closeFlag: false);
//
//                   ref.read(configStartYearmonthProvider.notifier).setSelectedMonth(month: e);
//                 },
//                 child: Container(
//                   width: context.screenSize.width / 10,
//                   margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
//                   padding: const EdgeInsets.symmetric(vertical: 3),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white.withOpacity(0.2)),
//                     color: (configStartYearmonthState.selectedStartMonth == e || configSelectedmonth == e)
//                         ? Colors.yellowAccent.withOpacity(0.2)
//                         : Colors.transparent,
//                   ),
//                   child: Text((e + 1).toString().padLeft(2, '0')),
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 10),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Container(),
//                 GestureDetector(
//                   onTap: () {
//                     final int year = configStartYearmonthState.selectedStartYear;
//                     final int month = configStartYearmonthState.selectedStartMonth;
//
//                     final String val = '$year-${(month + 1).toString().padLeft(2, '0')}';
//
//                     if (year == -1 || month == -1) {
//                       // ignore: always_specify_types
//                       Future.delayed(
//                         Duration.zero,
//                         () {
//                           if (mounted) {
//                             return error_dialog(context: context, title: '登録できません。', content: '値を正しく入力してください。');
//                           }
//                         },
//                       );
//
//                       return;
//                     }
//
//                     (settingConfigMap['start_yearmonth'] != null)
//                         ? updateConfig(key: 'start_yearmonth', value: val, closeFlag: true)
//                         : inputConfig(key: 'start_yearmonth', value: val, closeFlag: true);
//                   },
//                   child: Text(
//                     (settingConfigMap['start_yearmonth'] != null) ? '更新する' : '設定する',
//                     style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
//
//   ///
//   Future<void> makeSettingConfigMap() async {
//     await ConfigsRepository().getConfigList(isar: widget.isar).then((List<Config>? value) {
//       setState(() {
//         configList = value;
//
//         if (value!.isNotEmpty) {
//           for (final Config element in value) {
//             settingConfigMap[element.configKey] = element.configValue;
//           }
//         }
//       });
//     });
//   }
//
//   ///
//   Future<void> inputConfig({required String key, required String value, required bool closeFlag}) async {
//     final Config config = Config()
//       ..configKey = key
//       ..configValue = value;
//
//     // ignore: always_specify_types
//     await ConfigsRepository()
//         .inputConfig(isar: widget.isar, config: config)
//         // ignore: always_specify_types
//         .then((value) {
//       if (closeFlag) {
//         if (mounted) {
//           Navigator.pop(context);
//           Navigator.pop(context);
//         }
//       }
//     });
//   }
//
//   ///
//   Future<void> updateConfig({required String key, required String value, required bool closeFlag}) async {
//     await widget.isar.writeTxn(() async {
//       await ConfigsRepository().getConfigByKeyString(isar: widget.isar, key: key).then((Config? value2) async {
//         value2!.configValue = value;
//
//         // ignore: always_specify_types
//         await ConfigsRepository()
//             .updateConfig(isar: widget.isar, config: value2)
//             // ignore: always_specify_types
//             .then((value) {
//           if (closeFlag) {
//             if (mounted) {
//               Navigator.pop(context);
//               Navigator.pop(context);
//             }
//           }
//         });
//       });
//     });
//   }
//
//   ///
//   Future<void> _makeCreditItemList() async => CreditItemsRepository()
//       .getCreditItemList(isar: widget.isar)
//       .then((List<CreditItem>? value) => setState(() => creditItemList = value));
// }
