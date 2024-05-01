enum StockFrame { blank, general, specific }

extension StockFrameExtension on StockFrame {
  String get japanName {
    switch (this) {
      case StockFrame.blank:
        return '';
      case StockFrame.general:
        return '一般口座';
      case StockFrame.specific:
        return '特定口座';
    }
  }
}
