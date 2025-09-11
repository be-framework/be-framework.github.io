---
layout: docs-ja
title: "1. 概要"
category: Manual
permalink: /manuals/1.0/ja/01-overview.html
---

# 概要: コードについて異なる思考法

## まず、これを見てください

```php
// 従来のユーザー削除方法
$user = User::find($id);
$user->delete();

// 異なるユーザー削除方法
$activeUser = User::find($id);
$deletedUser = new DeletedUser($activeUser);
```

**DeletedUser?**

「削除なのに新しいオブジェクトを作る？」そう感じるのは当然です。

この違和感は大切なことを教えてくれます。私たちはプログラミングに対して無意識の思い込みを持っており、それを疑うことはほとんどないのです。

## 違い

従来のプログラミングは**アクション（何をするか）**に着目します：
```php
$user->validate();
$user->save();
$user->notify();
```

Beフレームワークは**状態（何であるか）**に着目します：
```php
$rawData = new UserInput($_POST);
$validatedUser = new ValidatedUser($rawData);
$savedUser = new SavedUser($validatedUser);
```

前者はオブジェクトに対して「何をしろ」と指示します。
後者はオブジェクトが「どのような状態になるか」を表現します。

## なぜこれが重要なのか

**アクション中心**のプログラミングでは：
- 実行前に「このアクションは可能か？」を毎回チェックする必要があります
- 様々なエラーケースに対処しなければなりません
- 不正な状態を防ぐための処理が常に必要です

**状態中心**のプログラミングでは：
- 不正な状態のオブジェクトは最初から存在しません
- オブジェクトが存在すること自体が「正しい状態」の証明になります
- エラーハンドリングが大幅に簡単になります

違いは型そのものにあります：
```php
// 従来型：汎用的な型
function processUser(User $user) { }

// Beフレームワーク：特定の存在状態
function processUser(ValidatedUser $user) { }
function saveUser(SavedUser $user) { }
function archiveUser(DeletedUser $user) { }
```

各型はただのデータではなく、オブジェクトの特定の状態を表現しています。

## このマニュアルで学べること

以下の新しいプログラミング手法を身につけることができます：

1. **「何をするか」ではなく「何であるか」を設計する**
2. **不正な状態をチェックするのではなく、最初から作れないようにする**
3. **オブジェクトを無理に変更するのではなく、自然な変化を表現する**
4. **エラーを防ぐのではなく、正しい状態を信頼する**

## さあ、始めましょう

基礎から学んでいきます：[入力クラス →](./02-input-classes.html)

最初のオブジェクトを作りながら、なぜ`DeletedUser`が理にかなっているのかを体感してください。