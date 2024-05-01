enum InvestKind { blank, stock, shintaku, gold }

extension InvestKindExtension on InvestKind {
  String get japanName {
    switch (this) {
      case InvestKind.blank:
        return '';
      case InvestKind.stock:
        return '株式';
      case InvestKind.shintaku:
        return '信託';
      case InvestKind.gold:
        return '金';
    }
  }
}
