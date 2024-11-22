import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/config.dart';
import '../../extensions/extensions.dart';
import '../../repository/configs_repository.dart';
import 'parts/error_dialog.dart';

class ConfigSettingAlert extends ConsumerStatefulWidget {
  const ConfigSettingAlert({super.key, required this.isar});

  final Isar isar;

  @override
  ConsumerState<ConfigSettingAlert> createState() => _ConfigSettingAlertState();
}

class _ConfigSettingAlertState extends ConsumerState<ConfigSettingAlert> {
  List<Config>? configList = <Config>[];

  Map<String, String> configMap = <String, String>{};

  final TextEditingController _stockCostEditingController = TextEditingController();
  final TextEditingController _stockPriceEditingController = TextEditingController();

  final TextEditingController _shintakuCostEditingController = TextEditingController();
  final TextEditingController _shintakuPriceEditingController = TextEditingController();

  final TextEditingController _goldCostEditingController = TextEditingController();
  final TextEditingController _goldPriceEditingController = TextEditingController();

  ///
  void _init() {
    _makeSettingConfigMap();
  }

  bool configSetted = false;

  ///
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    Future(_init);

    if (!configSetted && configMap.isNotEmpty) {
      _stockCostEditingController.text = configMap['startCostStock'] ?? '';
      _stockPriceEditingController.text = configMap['startPriceStock'] ?? '';
      _shintakuCostEditingController.text = configMap['startCostShintaku'] ?? '';
      _shintakuPriceEditingController.text = configMap['startPriceShintaku'] ?? '';
      _goldCostEditingController.text = configMap['startCostGold'] ?? '';
      _goldPriceEditingController.text = configMap['startPriceGold'] ?? '';

      configSetted = true;
    }

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
              _displayInputParts(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(),
                  TextButton(
                    onPressed: inputConfig,
                    child: const Text('コンフィグレコードを登録する', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayInputParts() {
    return DecoratedBox(
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2))]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            width: context.screenSize.width,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Column(
              children: <Widget>[
                _displayStartCostPriceSettingWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayStartCostPriceSettingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(color: Colors.yellowAccent.withOpacity(0.1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('開始金額'),
              Container(),
            ],
          ),
        ),
        const Text('株'),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: _stockCostEditingController,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  hintText: 'cost(10桁以内)',
                  filled: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                ),
                style: const TextStyle(fontSize: 13, color: Colors.white),
                onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: _stockPriceEditingController,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  hintText: 'price(10桁以内)',
                  filled: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                ),
                style: const TextStyle(fontSize: 13, color: Colors.white),
                onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        const SizedBox(height: 10),
        const Text('信託'),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: _shintakuCostEditingController,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  hintText: 'cost(10桁以内)',
                  filled: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                ),
                style: const TextStyle(fontSize: 13, color: Colors.white),
                onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: _shintakuPriceEditingController,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  hintText: 'price(10桁以内)',
                  filled: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                ),
                style: const TextStyle(fontSize: 13, color: Colors.white),
                onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        const SizedBox(height: 10),
        const Text('金'),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: _goldCostEditingController,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  hintText: 'cost(10桁以内)',
                  filled: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                ),
                style: const TextStyle(fontSize: 13, color: Colors.white),
                onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: _goldPriceEditingController,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  hintText: 'price(10桁以内)',
                  filled: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                ),
                style: const TextStyle(fontSize: 13, color: Colors.white),
                onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  ///
  Future<void> _makeSettingConfigMap() async {
    await ConfigsRepository().getConfigList(isar: widget.isar).then((List<Config>? value) {
      setState(() {
        configList = value;

        if (value!.isNotEmpty) {
          for (final Config element in value) {
            configMap[element.configKey] = element.configValue;
          }
        }
      });
    });
  }

  ///
  Future<void> inputConfig() async {
    final List<String> list = <String>[
      _stockCostEditingController.text,
      _stockPriceEditingController.text,
      _shintakuCostEditingController.text,
      _shintakuPriceEditingController.text,
      _goldCostEditingController.text,
      _goldPriceEditingController.text,
    ];

    bool errFlg = false;

    for (final String element in list) {
      if (element == '') {
        errFlg = true;
      }

      if (element.length > 10) {
        errFlg = true;
      }
    }

    if (errFlg) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () {
          if (mounted) {
            return error_dialog(context: context, title: '登録できません。', content: '値を正しく入力してください。');
          }
        },
      );

      return;
    }

    final List<Config> configList = <Config>[];

    configList.add(Config()
      ..configKey = 'startCostStock'
      ..configValue = _stockCostEditingController.text);

    configList.add(Config()
      ..configKey = 'startPriceStock'
      ..configValue = _stockPriceEditingController.text);

    configList.add(Config()
      ..configKey = 'startCostShintaku'
      ..configValue = _shintakuCostEditingController.text);

    configList.add(Config()
      ..configKey = 'startPriceShintaku'
      ..configValue = _shintakuPriceEditingController.text);

    configList.add(Config()
      ..configKey = 'startCostGold'
      ..configValue = _goldCostEditingController.text);

    configList.add(Config()
      ..configKey = 'startPriceGold'
      ..configValue = _goldPriceEditingController.text);

    final List<Config> deleteConfigList = <Config>[];

    await widget.isar.writeTxn(() async {
      for (final Config element in configList) {
        ConfigsRepository().getConfigByKeyString(isar: widget.isar, key: element.configKey).then(
          (Config? value) {
            if (value != null) {
              deleteConfigList.add(value);
            }
          },
        );
      }
    });

    await ConfigsRepository().deleteConfigList(isar: widget.isar, configList: deleteConfigList).then(
      // ignore: always_specify_types
      (value) async {
        await ConfigsRepository().inputConfigList(isar: widget.isar, configList: configList).then(
          // ignore: always_specify_types
          (value2) {
            if (mounted) {
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }
}
