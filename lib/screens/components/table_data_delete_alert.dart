import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/config.dart';
import '../../collections/invest_name.dart';
import '../../collections/invest_record.dart';
import '../../controllers/controllers_mixin.dart';

class _TableEntry {
  _TableEntry({required this.name, required this.getCount, required this.clear});

  final String name;
  final Future<int> Function() getCount;
  final Future<void> Function() clear;
}

class TableDataDeleteAlert extends ConsumerStatefulWidget {
  const TableDataDeleteAlert({super.key, required this.isar});

  final Isar isar;

  @override
  ConsumerState<TableDataDeleteAlert> createState() => _TableDataDeleteAlertState();
}

class _TableDataDeleteAlertState extends ConsumerState<TableDataDeleteAlert>
    with ControllersMixin<TableDataDeleteAlert> {
  late final List<_TableEntry> _tables;

  @override
  void initState() {
    super.initState();

    final Isar isar = widget.isar;

    _tables = <_TableEntry>[
      _TableEntry(
        name: 'Config',
        getCount: () => isar.configs.where().count(),
        clear: () => isar.writeTxn(() => isar.configs.clear()),
      ),
      _TableEntry(
        name: 'InvestName',
        getCount: () => isar.investNames.where().count(),
        clear: () => isar.writeTxn(() => isar.investNames.clear()),
      ),
      _TableEntry(
        name: 'InvestRecord',
        getCount: () => isar.investRecords.where().count(),
        clear: () => isar.writeTxn(() => isar.investRecords.clear()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('テーブルデータ削除', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox.shrink(),
            ],
          ),
          Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
          Expanded(
            child: ListView.builder(
              itemCount: _tables.length,
              itemBuilder: (BuildContext context, int index) {
                final _TableEntry entry = _tables[index];

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                  ),
                  child: DefaultTextStyle(
                    style: const TextStyle(fontSize: 12),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () => _showDeleteDialog(entry: entry),
                          icon: Icon(Icons.delete, color: Colors.white.withValues(alpha: 0.4)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(entry.name)),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FutureBuilder<int>(
                              future: entry.getCount(),
                              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                                if (snapshot.hasData) {
                                  return Text('${snapshot.data} 件');
                                }

                                return const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog({required _TableEntry entry}) {
    final Widget cancelButton = TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('いいえ'),
    );

    final Widget continueButton = TextButton(
      onPressed: () async {
        Navigator.pop(context);
        await entry.clear();
        if (mounted) {
          setState(() {});
        }
      },
      child: const Text('はい'),
    );

    final AlertDialog alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: Text('「${entry.name}」のデータをすべて消去しますか？'),
      actions: <Widget>[cancelButton, continueButton],
    );

    showDialog<void>(context: context, builder: (BuildContext context) => alert);
  }
}
