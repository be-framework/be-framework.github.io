---
layout: docs-ja
title: "1. 概要"
category: Manual
permalink: /manuals/1.0/ja/01-overview.html
---

# 新しい考え方

> 「真の発見の航海は、新しい風景を求めることではなく、新しい目を持つことにある。」
> 
> 　　—マルセル・プルースト『囚われの女』（À la recherche du temps perdu 第5巻）1923年

## まず、これを見てください

```php
// 従来のユーザー削除方法
$user = User::find($id);
$user->delete();

// 異なるユーザー削除方法
$activeUser = User::find($id);
$deletedUser = new DeletedUser($activeUser);
```

「`DeletedUser`」って何？と思いましたか？

実はこの疑問が、プログラミングの新しい世界への入り口なんです。これまで**考えてもみなかった方法**で、プログラミングを考えてみましょう。

## 『何をするか』から『何であるか』へ

従来のプログラミングは**DOING（何をするか）**に着目します：
```php
$user->validate();
$user->save();
$user->notify();
```

Beフレームワークは**BEING（何であるか）**に着目します：
```php
$rawData = new UserInput($_POST);
$validatedUser = new ValidatedUser($rawData);
$savedUser = new SavedUser($validatedUser);
```

前者はオブジェクトに対して「何をしろ」と指示します。
後者はオブジェクトが「どのような状態になるか」を表現します。

## なぜこれが重要なのか

**DOING**に着目すると：
- 実行前に「このアクションは可能か？」を毎回チェックする必要があります
- 様々なエラーケースに対処しなければなりません
- 不正な状態を防ぐための処理が常に必要です

**BEING**に着目すると：
- 不正な状態のオブジェクトは最初から存在しません
- オブジェクトが存在すること自体が「正しい状態」の証明になります
- その時にできることだけに集中できます。できないことはそもそも実行できません

違いは型そのものにあります：
```php
// 従来型：汎用的な型
function processUser(User $user) { }

// Beフレームワーク：特定の存在状態
function processUser(ValidatedUser $user) { }
function saveUser(SavedUser $user) { }
function archiveUser(DeletedUser $user) { }
```

各型はただのデータではなく、オブジェクトの特定の状態を表現しています。つまり、オブジェクトの時間的な変化が型で表されていて、その時に可能なことだけが行えます。例えば、存在しないオブジェクトに削除を命じることはできません。

## このマニュアルで学べること

以下の新しいプログラミング手法を身につけることができます：

1. **「何をするか」ではなく「何であるか」を設計する**
2. **不正な状態をチェックするのではなく、最初から作れないようにする**
3. **オブジェクトを無理に変更するのではなく、自然な変容（自己変容）を表現する**
4. **エラーを防ぐのではなく、正しい状態を信頼する**

## さあ、始めましょう

基礎から学んでいきます：[入力クラス →]({{ '/manuals/1.0/ja/02-input-classes.html' | relative_url }})

最初のオブジェクトを作りながら、なぜ『`DeletedUser`』なのかを体感してください。
