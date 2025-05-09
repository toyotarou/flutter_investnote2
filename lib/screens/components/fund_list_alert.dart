import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../model/fund.dart';

class FundListAlert extends ConsumerStatefulWidget {
  const FundListAlert({super.key});

  @override
  ConsumerState<FundListAlert> createState() => _FundListAlertState();
}

class _FundListAlertState extends ConsumerState<FundListAlert> with ControllersMixin<FundListAlert> {
  ///
  @override
  void initState() {
    super.initState();

    fundNotifier.getAllFund();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Container(width: context.screenSize.width),
            displayFundNamePulldown(),
            Divider(color: Colors.white.withOpacity(0.1), thickness: 5),
            displayStartEndDate(),
            Divider(color: Colors.white.withOpacity(0.1), thickness: 5),
            Expanded(child: displayFundList()),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayFundNamePulldown() {
    //--------------------------//
    final Map<String, String> fundNamePulldownMap = <String, String>{'': '-'};

    final Map<Fundname, String> fundNameReverseMap = fundnameValues.reverse;

    fundState.fundNameMap.forEach(
        (Fundname key, List<FundModel> value) => fundNamePulldownMap[key.name] = fundNameReverseMap[key].toString());
    //--------------------------//

    // ignore: always_specify_types
    return DropdownButton(
      isExpanded: true,
      dropdownColor: Colors.pinkAccent.withOpacity(0.1),
      iconEnabledColor: Colors.white,
      items: fundNamePulldownMap.entries.map((MapEntry<String, String> e) {
        // ignore: always_specify_types
        return DropdownMenuItem(
          value: e.key,
          child: Text(
            e.value,
            style: TextStyle(
              fontSize: 12,
              color: (e.key == fundState.selectedFundName) ? Colors.yellowAccent : Colors.white,
            ),
          ),
        );
      }).toList(),
      value: fundState.selectedFundName,
      onChanged: (String? value) {
        if (value != '') {
          fundNotifier.setSelectedFundName(name: value!);
        }
      },
    );
  }

  ///
  Widget displayFundList() {
    final List<Widget> list = <Widget>[];

    fundState.fundNameMap.forEach((Fundname key, List<FundModel> value) {
      if (key.name == fundState.selectedFundName) {
        for (final FundModel element in value) {
          list.add(Container(
            width: context.screenSize.width,
            margin: const EdgeInsets.all(2),
            decoration:
                BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 2))),
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${element.year}-${element.month}-${element.day}'),
                  Text(element.basePrice.toString().toCurrency()),
                ],
              ),
            ),
          ));
        }
      }
    });

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }

  ///
  Widget displayStartEndDate() {
    String startDate = '';
    String endDate = '';

    fundState.fundNameMap.forEach((Fundname key, List<FundModel> value) {
      if (key.name == fundState.selectedFundName) {
        for (final FundModel element in value) {
          if (startDate == '') {
            startDate = '${element.year}-${element.month}-${element.day}';
          }

          endDate = '${element.year}-${element.month}-${element.day}';
        }
      }
    });

    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12, color: Colors.pinkAccent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Text(startDate), Text(endDate)],
      ),
    );
  }
}
