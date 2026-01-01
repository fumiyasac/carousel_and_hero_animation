// ========================================
// アプリのエントリーポイント（main.dart）
// ========================================
// Flutterアプリの起動時に最初に実行されるファイル
// Riverpodを使った状態管理とMaterial Designのセットアップを行う

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/carousel_list_screen.dart';

// ========================================
// main 関数（アプリケーションのエントリーポイント）
// ========================================
// Flutterアプリが起動すると最初にこの関数が実行される
// Dartのすべてのアプリケーションはmain()関数から始まる
void main() {
  // runApp(): Flutterアプリを起動してWidgetツリーのルートを設定する関数
  runApp(
    // ========================================
    // ProviderScope（Riverpodのルート）
    // ========================================
    // Riverpodを使用するために必要なルートWidget
    // すべてのProviderはこのProviderScopeの下で動作する
    // アプリ全体でProviderにアクセスできるようにする
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// ========================================
// MyApp（アプリケーションのルートWidget）
// ========================================
// アプリ全体の設定を行うルートWidget
// StatelessWidget: 状態を持たないWidget（再描画されても内部状態は変わらない）
class MyApp extends StatelessWidget {
  // const コンストラクタ: コンパイル時定数として扱われ、パフォーマンスが向上
  // super.key: 親クラス（StatelessWidget）にkeyパラメータを渡す
  const MyApp({super.key});

  // ========================================
  // build メソッド
  // ========================================
  // Widgetの見た目を構築するメソッド
  // StatelessWidgetでは必ず実装する必要がある
  // @override: 親クラスのメソッドをオーバーライドすることを明示
  @override
  Widget build(BuildContext context) {
    // ========================================
    // MaterialApp（Material Designアプリのルート）
    // ========================================
    // Material Designに基づいたアプリを構築するための最上位Widget
    // ナビゲーション、テーマ、ローカライゼーションなどを管理
    return MaterialApp(
      // アプリのタイトル（タスクスイッチャーなどで表示される）
      title: 'グルメギャラリー - 美味しい料理を探そう',

      // デバッグバナーを非表示にする（画面右上の"DEBUG"表示を消す）
      debugShowCheckedModeBanner: false,

      // ========================================
      // theme（アプリ全体のテーマ設定）
      // ========================================
      // ThemeData: アプリ全体の色、フォント、形状などのデザイン設定
      theme: ThemeData(
        // ColorScheme.fromSeed(): シード色から調和の取れたカラースキームを自動生成
        // Material Design 3の色システムに基づいた配色が作られる
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),

        // Material Design 3を使用（最新のデザインシステム）
        // false にすると Material Design 2 になる
        useMaterial3: true,

        // アプリ全体で使用するフォントファミリー
        // 日本語フォント 'NotoSansJP' を指定（pubspec.yamlで定義する必要あり）
        fontFamily: 'NotoSansJP',
      ),

      // ========================================
      // home（アプリの最初に表示する画面）
      // ========================================
      // アプリ起動時に表示される最初の画面（ホーム画面）
      // CarouselListScreen: カルーセルとグリッドを表示するメイン画面
      home: const CarouselListScreen(),
    );
  }
}
