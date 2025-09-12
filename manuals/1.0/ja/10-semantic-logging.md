---
layout: docs-ja
title: "10. 意味的ログ"
category: Manual
permalink: /manuals/1.0/ja/10-semantic-logging.html
---

# 意味的ログ

> 「記録されるものは記憶となり、記憶されるものは真実となる」
>
> 　　—オーウェル『1984年』の概念より（1949年）

## 概要

Beフレームワークは、オブジェクトの変容プロセスを構造化されたログとして自動記録する**意味的ログ**機能を実装しています。

### 基本コンセプト

**従来のログ**：イベントの断片的な記録  
**意味的ログ**：オブジェクトの完全な変容ストーリーの記録

```php
// オブジェクトの変容が...
#[Be(RegisteredUser::class)]
final class UserInput { /* ... */ }

final class RegisteredUser { /* ... */ }

// 自動的に構造化ログとして記録される
{
  "metamorphosis": {
    "from": "UserInput",
    "to": "RegisteredUser",
    // 完全な変容情報...
  }
}
```

## 技術的基盤

[Koriym.SemanticLogger](https://github.com/koriym/Koriym.SemanticLogger)と統合：

- **型安全な構造化ログ**
- **Open/Event/Close パターン**
- **JSONスキーマ検証**
- **階層的操作追跡**

## 提供価値

### 開発・デバッグ
オブジェクト変容の完全な追跡により、複雑な処理フローの理解と問題特定が容易になります。

### 監査・コンプライアンス
すべての変容が構造化データとして記録されるため、完全な監査証跡を提供できます。

### システム分析
オブジェクトの成長パターンと処理効率の分析が可能になります。

---

**詳細な使用方法、設定例、実践的なサンプルについては、ドキュメントを後日整備します。**

