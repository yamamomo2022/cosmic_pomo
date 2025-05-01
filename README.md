# cosmic_pomo

**cosmic_pomo** は、時間経過を惑星運動で表現する新感覚のポモドーロタイマーです。

## 概要

- ポモドーロテクニックをサポートするタイマーアプリです。
- タイマーの進行状況を惑星の軌道運動として可視化します。
- ワークモード（25分）とブレイクモード（3分）を切り替え可能です。
- 惑星をドラッグしてタイマーの残り時間を直感的に調整できます。
- サウンド通知、バナー広告、Firebase Analytics対応。

## 主な機能

- 惑星の軌道アニメーションによる時間の可視化
- ワーク／ブレイクモードの切り替え
- タイマーの開始・停止・リセット
- 惑星ドラッグによるタイマー調整
- サウンド通知
- バナー広告表示（AdMob）
- Firebase Analyticsによる利用状況の記録

## インストール

### 1. 必要条件

- Flutter 3.7.0 以上
- Dart 3.7.0 以上

### 2. 依存パッケージの取得

```sh
flutter pub get
```

### 3. 実行

```sh
flutter run
```

### 4. ビルド

- Android: `flutter build apk`
- iOS: `flutter build ios`
- Web: `flutter build web`

## 依存パッケージ

- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
- [wakelock_plus](https://pub.dev/packages/wakelock_plus)
- [logger](https://pub.dev/packages/logger)
- [audioplayers](https://pub.dev/packages/audioplayers)
- [google_mobile_ads](https://pub.dev/packages/google_mobile_ads)
- [firebase_core](https://pub.dev/packages/firebase_core)
- [firebase_analytics](https://pub.dev/packages/firebase_analytics)
- [hooks_riverpod](https://pub.dev/packages/hooks_riverpod)
- [cupertino_icons](https://pub.dev/packages/cupertino_icons)

## 使い方

1. アプリを起動すると、ワークモード（25分）が表示されます。
2. 「Start」ボタンでタイマーを開始します。
3. 惑星が軌道上を移動し、時間経過を視覚的に確認できます。
4. 「Stop」「Reset」ボタンでタイマー操作が可能です。
5. モード切り替えボタンでワーク／ブレイクを変更できます。
6. 惑星をドラッグして残り時間を調整できます。

## ライセンス

本アプリは MIT ライセンスのもとで公開されています。  
詳細は [LICENSE](LICENSE) ファイルをご覧ください。

---

Made with Flutter 🚀
