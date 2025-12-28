import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// お気に入りテーブル定義
class Favorites extends Table {
  TextColumn get itemId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {itemId};
}

@DriftDatabase(tables: [Favorites])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // お気に入り追加
  Future<int> addFavorite(String itemId) {
    return into(favorites).insert(
      FavoritesCompanion.insert(itemId: itemId),
      mode: InsertMode.insertOrReplace,
    );
  }

  // お気に入り削除
  Future<int> removeFavorite(String itemId) {
    return (delete(favorites)..where((tbl) => tbl.itemId.equals(itemId))).go();
  }

  // お気に入り確認
  Future<bool> isFavorite(String itemId) async {
    final result = await (select(favorites)
          ..where((tbl) => tbl.itemId.equals(itemId)))
        .getSingleOrNull();
    return result != null;
  }

  // すべてのお気に入りID取得
  Future<List<String>> getAllFavoriteIds() async {
    final result = await select(favorites).get();
    return result.map((row) => row.itemId).toList();
  }

  // すべてのお気に入り削除
  Future<int> clearAllFavorites() {
    return delete(favorites).go();
  }

  // お気に入り数取得
  Future<int> getFavoriteCount() async {
    final result = await select(favorites).get();
    return result.length;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}
