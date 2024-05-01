import 'package:isar/isar.dart';

import '../collections/stock_name.dart';

class StockNamesRepository {
  ///
  IsarCollection<StockName> getCollection({required Isar isar}) => isar.stockNames;

  ///
  Future<List<StockName>?> getStockNameList({required Isar isar}) async {
    final stockNamesCollection = getCollection(isar: isar);
    return stockNamesCollection.where().findAll();
  }

  ///
  Future<void> inputStockName({required Isar isar, required StockName stockName}) async {
    final stockNamesCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => stockNamesCollection.put(stockName));
  }
}
