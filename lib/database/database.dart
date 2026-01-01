import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Driftが自動生成するコードをインポート
// database.g.dart は build_runner によって生成される
part 'database.g.dart';

// ========================================
// Favorites Table（お気に入りテーブル定義）
// ========================================
// Driftでテーブルを定義するには、Tableクラスを継承する
// このクラスの各getterがテーブルのカラムになる
class Favorites extends Table {
  // itemId カラム: お気に入りに登録されたアイテムのID（TEXT型）
  // text()()の2つの括弧は、Driftの設定メソッド呼び出し
  TextColumn get itemId => text()();

  // createdAt カラム: お気に入りに追加された日時（DATETIME型）
  // withDefault()でデフォルト値を設定（現在日時を自動挿入）
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // プライマリーキー（主キー）の設定
  // itemIdを主キーにすることで、同じIDの重複登録を防ぐ
  // Setを使用することで複合主キーも定義可能
  @override
  Set<Column> get primaryKey => {itemId};
}

// ========================================
// App Database（アプリケーションデータベース）
// ========================================
// @DriftDatabaseアノテーションでデータベースを定義
// tables: 使用するテーブルのリストを指定
@DriftDatabase(tables: [Favorites])
class AppDatabase extends _$AppDatabase {
  // コンストラクタ: データベース接続を初期化
  // super()で親クラス（_$AppDatabase）のコンストラクタに接続情報を渡す
  AppDatabase() : super(_openConnection());

  // スキーマバージョン: データベース構造のバージョン番号
  // テーブル構造を変更した場合はこの番号をインクリメントする
  // Driftはこの番号を見てマイグレーション（データベース更新）が必要か判断する
  @override
  int get schemaVersion => 1;

  // ========================================
  // お気に入り追加
  // ========================================
  Future<int> addFavorite(String itemId) {
    // into(テーブル).insert()でデータを挿入
    // FavoritesCompanion.insert()で挿入するデータを指定
    // mode: InsertMode.insertOrReplaceで、既存データがあれば上書き（UPSERT）
    return into(favorites).insert(
      FavoritesCompanion.insert(itemId: itemId),
      mode: InsertMode.insertOrReplace,
    );
  }

  // ========================================
  // お気に入り削除
  // ========================================
  Future<int> removeFavorite(String itemId) {
    // delete(テーブル)で削除クエリを作成
    // ..where()でカスケード記法を使って条件を追加
    // tbl.itemId.equals(itemId)で「itemIdカラムが指定IDと一致する」条件
    // .go()でクエリを実行
    return (delete(favorites)..where((tbl) => tbl.itemId.equals(itemId))).go();
  }

  // ========================================
  // お気に入り確認
  // ========================================
  Future<bool> isFavorite(String itemId) async {
    // select(テーブル)で検索クエリを作成
    // ..where()で条件を追加（カスケード記法）
    // getSingleOrNull()で結果が1件またはnullを取得
    final result = await (select(favorites)
          ..where((tbl) => tbl.itemId.equals(itemId)))
        .getSingleOrNull();
    // 結果がnullでなければお気に入り登録済み
    return result != null;
  }

  // ========================================
  // すべてのお気に入りID取得
  // ========================================
  Future<List<String>> getAllFavoriteIds() async {
    // select(テーブル).get()で全レコードを取得
    final result = await select(favorites).get();
    // map()で各レコードからitemIdだけを抽出してリストに変換
    return result.map((row) => row.itemId).toList();
  }

  // ========================================
  // すべてのお気に入り削除
  // ========================================
  Future<int> clearAllFavorites() {
    // delete(テーブル).go()で全レコードを削除
    // where条件がないため、テーブルの全データが削除される
    return delete(favorites).go();
  }

  // ========================================
  // お気に入り数取得
  // ========================================
  Future<int> getFavoriteCount() async {
    // 全レコードを取得してlengthで件数をカウント
    final result = await select(favorites).get();
    return result.length;
  }
}

// ========================================
// データベース接続の初期化
// ========================================
// LazyDatabaseを使用して、実際に必要になるまでデータベース接続を遅延させる
// これによりアプリ起動時のパフォーマンスが向上する
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // getApplicationDocumentsDirectory()でアプリ専用のドキュメントディレクトリを取得
    // このディレクトリはアプリがアンインストールされると削除される
    final dbFolder = await getApplicationDocumentsDirectory();

    // p.join()でパスを結合してSQLiteファイルのパスを作成
    // 例: /data/user/0/com.example.app/app_flutter/app_database.sqlite
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));

    // NativeDatabase()でSQLiteデータベース接続を作成
    // Fileオブジェクトを渡すことで、指定したパスにデータベースファイルを作成
    return NativeDatabase(file);
  });
}
