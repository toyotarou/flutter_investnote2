import 'package:isar/isar.dart';

part 'invest_record.g.dart';

@collection
class InvestRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late String date;

  late int? investId;

  late int cost;
  late int price;
}
