enum ShintakuFrame { blank, specific, nisaAccumulated, nisaGrowth, nisaFreshly }

extension ShintakuFrameExtension on ShintakuFrame {
  String get japanName {
    switch (this) {
      case ShintakuFrame.blank:
        return '';
      case ShintakuFrame.specific:
        return '特定口座';
      case ShintakuFrame.nisaAccumulated:
        return 'NISAつみたて投資枠';
      case ShintakuFrame.nisaGrowth:
        return 'NISA成長投資枠';
      case ShintakuFrame.nisaFreshly:
        return 'つみたてNISA';
    }
  }
}
