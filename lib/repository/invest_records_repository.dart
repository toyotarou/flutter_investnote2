import 'package:isar/isar.dart';

import '../collections/invest_record.dart';

class InvestRecordsRepository {
  ///
  IsarCollection<InvestRecord> getCollection({required Isar isar}) => isar.investRecords;

  ///
  Future<void> inputInvestRecord({required Isar isar, required InvestRecord investRecord}) async {
    final investRecordsCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => investRecordsCollection.put(investRecord));
  }
}
