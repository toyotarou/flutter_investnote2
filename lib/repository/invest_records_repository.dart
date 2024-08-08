import 'package:isar/isar.dart';

import '../collections/invest_record.dart';

class InvestRecordsRepository {
  ///
  IsarCollection<InvestRecord> getCollection({required Isar isar}) =>
      isar.investRecords;

  ///
  Future<InvestRecord?> getInvestRecord(
      {required Isar isar, required int id}) async {
    final investRecordsCollection = getCollection(isar: isar);
    return investRecordsCollection.get(id);
  }

  ///
  Future<List<InvestRecord>?> getInvestRecordList({required Isar isar}) async {
    final investRecordsCollection = getCollection(isar: isar);
    return investRecordsCollection
        .where()
        .sortByDate()
        .thenByInvestId()
        .findAll();
  }

  ///
  Future<List<InvestRecord>?> getInvestRecordListByInvestId(
      {required Isar isar, required int investId}) async {
    final investRecordsCollection = getCollection(isar: isar);
    return investRecordsCollection.filter().investIdEqualTo(investId).findAll();
  }

  ///
  Future<List<InvestRecord>?> getInvestRecordListByDate(
      {required Isar isar, required String date}) async {
    final investRecordsCollection = getCollection(isar: isar);
    return investRecordsCollection
        .filter()
        .dateEqualTo(date)
        .sortByInvestId()
        .findAll();
  }

  ///
  Future<void> inputInvestRecord(
      {required Isar isar, required InvestRecord investRecord}) async {
    final investRecordsCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => investRecordsCollection.put(investRecord));
  }

  ///
  Future<void> updateInvestRecord(
      {required Isar isar, required InvestRecord investRecord}) async {
    final investRecordsCollection = getCollection(isar: isar);
    await investRecordsCollection.put(investRecord);
  }

  ///
  Future<void> deleteInvestRecordList(
      {required Isar isar,
      required List<InvestRecord>? investRecordList}) async {
    investRecordList
        ?.forEach((element) => deleteInvestRecord(isar: isar, id: element.id));
  }

  ///
  Future<void> deleteInvestRecord({required Isar isar, required int id}) async {
    final investRecordsCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => investRecordsCollection.delete(id));
  }
}
