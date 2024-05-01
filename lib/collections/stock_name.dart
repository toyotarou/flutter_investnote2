import 'package:isar/isar.dart';

part 'stock_name.g.dart';

@collection
class StockName {
  Id id = Isar.autoIncrement;

  late String frame;

  late String name;
}
