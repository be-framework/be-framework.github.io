---
layout: docs-ja
title: "8. 存在理由層"
category: Manual
permalink: /manuals/1.0/ja/08-reason-layer.html
---

# 存在理由層: 存在論的能力

> 「文脈は装飾ではありません—それは存在の条件そのものです。」

存在理由層は**超越的**な力—存在の変容を形成する文脈的能力を体現します。

## 単純なサービスを超えて

従来の依存性注入はツールを提供します：

```php
public function __construct(
    EmailService $emailService,     // ただのツール
    DatabaseService $database       // ただのツール
) {}
```

## 存在論的能力

存在理由層は**文脈的存在能力**を提供します：

```php
public function __construct(
    #[Input] string $message,                    // 内在的
    #[Inject] #[English] CulturalGreeting $greeting,  // 超越的能力
    #[Inject] #[Formal] BusinessProtocol $protocol     // 超越的文脈
) {
    // 能力と文脈が変容を形成する
}
```

## 存在理由クラス: 存在の方法

存在理由クラスは**サービスではありません**—文脈的な存在の方法です：

```php
namespace App\Reason;

final class CasualStyle
{
    public function format(string $message): string
    {
        return strtolower($message) . " 😊";
    }
    
    public function getGreeting(): string
    {
        return "やあ！";
    }
}

final class FormalStyle  
{
    public function format(string $message): string
    {
        return ucfirst($message) . "。";
    }
    
    public function getGreeting(): string
    {
        return "おはようございます。";
    }
}
```

これらは**存在論的モード**—特定の文脈で存在する異なる方法です。

## 文脈駆動変容

同じオブジェクトが文脈的能力に基づいて異なって変容します：

```php
final class FormattedGreeting
{
    public readonly string $greeting;
    public readonly string $signature;
    
    public function __construct(
        #[Input] string $name,
        #[Input] string $message,
        #[Inject] StyleReason $style       // 文脈が変容を形成する
    ) {
        $this->greeting = $style->getGreeting() . " " . $name;
        $this->signature = $style->format($message);
    }
}
```

## 文化的文脈存在論

アプリケーションは自然に文化的文脈に適応します：

```php
final class JapaneseEtiquette
{
    public function addHonorific(string $name): string
    {
        return $name . "さん";
    }
    
    public function formatGreeting(string $message): string
    {
        return "いつもお世話になっております。" . $message;
    }
}

final class AmericanEtiquette
{
    public function addHonorific(string $name): string
    {
        return $name;  // 敬語は不要
    }
}
```

## 存在論としての戦略

戦略パターンとは異なり、存在理由クラスはアルゴリズムではなく**存在の方法**を表します：

```php
interface PricingOntology
{
    public function interpretValue(Money $price): PriceCategory;
}

final class LuxuryMarketOntology implements PricingOntology
{
    // 高級文脈では、高価格は独占性を意味する
}

final class MassMarketOntology implements PricingOntology  
{
    // 大衆市場では、高価格は障壁を意味する
}
```

## 複数の文脈的能力

```php
final class InternationalMessage
{
    public function __construct(
        #[Input] string $recipientName,
        #[Input] string $message,
        #[Inject] CulturalEtiquette $culture,     // 文化的文脈
        #[Inject] CommunicationProtocol $protocol, // コミュニケーション文脈
        #[Inject] FormalityLevel $formality       // 形式レベル文脈
    ) {
        $name = $culture->addHonorific($recipientName);
        $greeting = $culture->formatGreeting($message);
        $styled = $formality->apply($greeting);
        
        $this->content = $protocol->format($styled);
    }
}
```

## 依存性解決

依存性注入による文脈認識バインディング：

```php
$injector->bind(PaymentGateway::class)
    ->annotatedWith(Production::class)
    ->to(StripeGateway::class);
    
$injector->bind(PaymentGateway::class)
    ->annotatedWith(Testing::class)
    ->to(MockGateway::class);
```

## 革命

存在理由層は依存性注入を**ツール提供**から**存在論的文脈**に変換します。

オブジェクトは単にサービスを受け取るのではなく、環境に適した**存在の方法**を受け取ります。

---

**次へ**: 意味的例外が意味を保持する[エラーハンドリング & 検証](09-error-handling.html)について学びましょう。

*「存在理由層は世界の能力がオブジェクトの性質と出会う場所—意味のある成長のための文脈的条件として。」*
