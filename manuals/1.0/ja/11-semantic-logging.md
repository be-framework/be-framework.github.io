---
layout: docs-ja
title: "11. 意味的ログ"
category: Manual
permalink: /manuals/1.0/ja/11-semantic-logging.html
---

# 意味的ログ

> 「すべての変容は物語を語ります。意味的ログはその物語を捉えます。」

Beフレームワークの意味的ログは、完全な変容の旅路を自動的に捉え、オブジェクト変容への深い観測可能性を提供します。

## 意味的ログとは何か？

従来のログはイベントを捉えます。**意味的ログは意味を捉えます** - オブジェクトがその変容を通して辿る存在論的旅路を。

Beフレームワークは、コードの変更を一切必要とせずに、すべての変容を自動的にログします。

## 自動ログ構造

### オープンコンテキスト（変容開始）
```json
{
  "open": {
    "context": {
      "fromClass": "UserInput",
      "beAttribute": "#[Be(RegisteredUser::class)]",
      "immanentSources": {
        "email": "user@example.com"
      },
      "transcendentSources": {
        "UserRepository": "App\\Repository\\UserRepository"
      }
    }
  }
}
```

### クローズコンテキスト（変容完了）
```json
{
  "close": {
    "context": {
      "be": "FinalDestination",
      "properties": {
        "userId": "user_123",
        "email": "user@example.com"
      }
    }
  }
}
```

## 設定と使用方法

### 意味的ログの有効化
Beフレームワークは構造化された意味的ログのために[Koriym.SemanticLogger](https://github.com/koriym/Koriym.SemanticLogger)を自動的に使用します。

**TBD** - ログ出力の有効化/無効化のための設定詳細

### スキーマ検証されたログ
意味的ログは型安全性とAI分析のためのJSONスキーマに従います：

- 検証付きの**型安全構造化ログ**
- **AIネイティブ分析**機能
- **階層ワークフロー文脈**（意図 → イベント → 結果）

### カスタムログコンテキスト
**TBD** - 変容ログにカスタムコンテキストを追加する方法

### ログ処理
**TBD** - 監視ツールおよびログ集約との統合

## ログ分析例

```bash
# 失敗した変容を見つける
jq '.close.context.be == "DestinationNotFound"' logs/semantic.log

# 特定のユーザーの旅路を追跡する
jq '.open.context.immanentSources.email == "user@example.com"' logs/semantic.log
```

## 存在論的観測可能性の力

意味的ログはデバッグを**「何が起こったか？」**から**「何になったか？」**に変換します。

メソッド呼び出しを追跡する代わりに、オブジェクトが意図された形態を通して自然に進化することを追跡します - アプリケーションの真の動作への前例のない洞察を提供します。

---

*「従来のログでは、イベントを追跡します。意味的ログでは、成長を目撃します。」*