# イベント参加申込

## ユーザーストーリー

ユーザーとして、
イベントの参加申込をしたい。
なぜなら、興味のあるワークショップやセミナーに参加したいから。

## 受け入れ条件

### 入力
- イベント名（eventName）
- 参加者メール（participantEmail）
- 参加者年齢（participantAge）
- イベントタイプ（eventType: `workshop` または `seminar`）

### Semantic検証
- **eventName**: 空不可、最大100文字
- **participantEmail**: 有効なメール形式
- **participantAge**: 0〜150

### クロスフィールド検証
- `workshop`は13歳以上
- `seminar`は18歳以上
- 違反時は拒否

### 分岐（申込確定）
- `seminar` → 有料申込（PaidRegistration） — 参加費 5000円
- `workshop` → 無料申込（FreeRegistration）

## エンティティ

- イベント名（string）
- メール（string）
- 年齢（int）
- イベントタイプ（string）
- 参加費（int）

## 試したいパターン

- 複数のSemantic変数（Email、Age、EventName、EventType）
- クロスフィールド検証（age × eventType）
- 分岐（無料/有料）
- Reason経由でのfee計算
