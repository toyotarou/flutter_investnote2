# flutter_investnote2

投資記録を管理する Flutter アプリです。株式・投資信託・ファンドなどの投資情報をローカルに保存し、コスト・損益・グラフで可視化します。

---

## 主な機能

- **投資銘柄管理**: 種別（kind）・口座区分（frame）・銘柄名（name）・取引単位・関連IDを登録・編集
- **投資記録入力**: 日付・銘柄・取得コスト・時価を記録
- **日次投資表示**: 指定日の投資状況をまとめて確認
- **損益・コスト集計**: 銘柄ごとのコスト合計・損益結果を一覧表示
- **グラフ表示**: fl_chart を用いた投資推移グラフ・合計グラフ
- **ファンド一覧**: 投資信託ファンドの一覧表示
- **CSV インポート / エクスポート**: file_picker でファイル選択、share_plus で共有
- **設定画面**: アプリ設定を Config コレクションで管理

---

## 使用技術

| カテゴリ | ライブラリ |
|---|---|
| UI フレームワーク | Flutter (Material 3 off / ダークテーマ) |
| 状態管理 | hooks_riverpod |
| ローカル DB | Isar v3.0.5 |
| グラフ | fl_chart |
| フォント | google_fonts (KiwiMaru) / font_awesome_flutter |
| ファイル操作 | file_picker / share_plus |
| コード生成 | isar_generator / build_runner |
| Linter | pedantic_mono |

---

## Isar コレクション

### `InvestRecord`
投資の取引記録を保存します。

| フィールド | 型 | 説明 |
|---|---|---|
| id | Id | 自動採番 |
| date | String | 取引日（インデックス付き） |
| investId | int? | 銘柄 ID（InvestName への参照） |
| cost | int | 取得コスト |
| price | int | 時価 |

### `InvestName`
投資銘柄の基本情報を管理します。

| フィールド | 型 | 説明 |
|---|---|---|
| id | Id | 自動採番 |
| kind | String | 投資種別（例: 株式・投信） |
| frame | String | 口座区分（例: 特定・NISA） |
| name | String | 銘柄名 |
| dealNumber | int | 取引単位 |
| relationalId | int | 関連 ID |

### `Config`
アプリ設定を保存します。

---

## 画面構成

```
HomeScreen（ホーム画面）
├── components/
│   ├── daily_invest_display_alert.dart    日次投資状況表示
│   ├── invest_name_input_alert.dart       銘柄入力・編集
│   ├── invest_name_list_alert.dart        銘柄一覧
│   ├── invest_record_input_alert.dart     取引記録入力
│   ├── invest_record_list_alert.dart      取引記録一覧
│   ├── invest_result_list_alert.dart      損益結果一覧
│   ├── invest_cost_info_alert.dart        コスト情報詳細
│   ├── invest_cost_total_list_alert.dart  コスト合計一覧
│   ├── invest_graph_alert.dart            投資推移グラフ
│   ├── invest_graph_guide_alert.dart      グラフ凡例・ガイド
│   ├── invest_total_graph_alert.dart      合計グラフ
│   ├── fund_list_alert.dart               ファンド一覧
│   ├── config_setting_alert.dart          設定
│   ├── csv_data/                          CSV インポート/エクスポート関連
│   ├── page/                              ページコンポーネント
│   └── parts/                             共通パーツ
```

---

## ディレクトリ構成

```
lib/
├── collections/        Isar コレクション定義
├── controllers/        ビジネスロジック・コントローラー
├── data/               データ定数・初期値
├── enum/               列挙型定義
├── extensions/         拡張メソッド
├── model/              データモデル（Freezed 等）
├── repository/         DB アクセス層
├── screens/            UI 画面・コンポーネント
├── utilities/          ユーティリティ関数
└── main.dart           エントリーポイント
```

---

## セットアップ

```bash
# 依存パッケージのインストール
flutter pub get

# Isar コード生成
dart run build_runner build --delete-conflicting-outputs

# アプリ起動
flutter run
```

---

## 動作環境

- Flutter: 3.x 以上
- Dart SDK: >=3.3.0 <4.0.0
- iOS / Android 対応
