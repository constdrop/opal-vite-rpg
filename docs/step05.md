# Ruby RPG 講座 第5回 クラスとオブジェクト編

第5回は、冒険の設計図である「クラス」を学びます。「スライム」という種類のデータと動きをひとつにまとめて、何体でも同じ種類の敵を生み出せるようにします。

## 今日のゴール

* **クラス (class)** を作って、キャラクターの設計図を定義する
* 設計図から **インスタンス（実体）** を作る
* モンスターごとに違うHPや名前をスマートに管理する

## 使うファイル

* Rubyの処理: [app/main.rb](https://www.google.com/search?q=app/main.rb)
* 画面: [index.html](https://www.google.com/search?q=index.html)

## はじめに: step/05 をチェックアウトする

この回の状態に切り替えます。

```bash
git checkout step/05

```

## 1. モンスターの設計図（クラス）を作る

まずは、モンスターが共通して持つ「名前」や「HP」をまとめた設計図を作ります。ファイルの上のほうに書きます。

```ruby
class Monster
  # 作った瞬間に動く「初期化」の魔法
  def initialize(name, hp)
    @name = name
    @hp = hp
  end

  # 外から名前やHPを見たり変えたりできるようにする
  attr_accessor :name, :hp

  # モンスターがダメージを受ける仕組み（メソッド）
  def receive_damage(amount)
    @hp -= amount
    @hp = 0 if @hp < 0
  end
end

```

## 2. プレイヤーの設計図も作る

勇者も同じように設計図にまとめましょう。

```ruby
class Player
  def initialize(name)
    @name = name
  end
  attr_accessor :name
end

```

## 3. 設計図から「実体」を生み出す

ボタンが押されたとき、設計図をもとに本物のモンスターを作ります。

```ruby
`#{@button}.addEventListener('click', function() {`
  name = `#{@player_name_input}.value`
  return if name == ""

  # ★勇者とスライムを設計図から作る（インスタンス化）
  @player = Player.new(name)
  @enemy = Monster.new("スライム1号", 30)

  # （中略：バトルの開始処理）
`})`

```

## 4. クラスを使ってバトルを動かす

これまでの `attack` メソッドを、クラス（オブジェクト）を使う形に書き換えます。

```ruby
def attack(player, target, min, max)
  damage = rand(min..max)
  
  # ★オブジェクトに「ダメージを受けてね」と命令する
  target.receive_damage(damage)
  
  # 画面の更新
  `#{@enemy_hp_span}.innerText = #{target.hp}`
  
  msg = "#{player.name}の攻撃！#{target.name}に#{damage}のダメージ！(残りHP:#{target.hp})<br>"
  `#{@log_area}.innerHTML += #{msg}`
  `#{@log_area}.scrollTop = #{@log_area}.scrollHeight`
end

```

ポイント:

* **クラス (Class)**: たい焼きの「型（設計図）」。
* **インスタンス (Instance)**: 型から焼かれた「たい焼き（実体）」。
* **initialize**: `Monster.new` した瞬間に、名前やHPをセットする特別なメソッド。
* **カプセル化**: 「ダメージを受ける」という処理をモンスター自身に任せることで、外側のコードがスッキリする。

## 動作チェック

```bash
npm run dev

```

これまでと同じように動けば成功です！中身のプログラムが「変数」の集まりから「生き物（オブジェクト）」の集まりに進化しました。

## チャレンジ

* **新しい敵**: `Monster.new("ドラゴン", 100)` を作って戦ってみよう。
* **レベルアップ**: `Player` クラスに `@level` を追加して、敵を倒したらレベルが上がるようにしてみよう。
* **自己紹介**: `Monster` クラスに `say_hello` メソッドを作って、登場したときに「グチャグチャッ！（スライムが現れた！）」と喋らせてみよう。

---

### 第5回 main.rb の全体イメージ

（抜粋して構成を整理したもの）

```ruby
# backtick_javascript: true
require 'opal'
require 'native'

# --- 設計図エリア ---
class Monster
  attr_accessor :name, :hp
  def initialize(name, hp)
    @name = name
    @hp = hp
  end
  def receive_damage(amount)
    @hp -= amount
    @hp = 0 if @hp < 0
  end
end

class Player
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

# --- メイン処理エリア ---
@log_area = `document.getElementById('log-area')`
@button = `document.getElementById('action-button')`
# ...他の要素取得...

def attack(player, target, min, max)
  damage = rand(min..max)
  target.receive_damage(damage)
  # ...画面更新とログ表示...
end

`#{@button}.addEventListener('click', function() {`
  name = `#{@player_name_input}.value`
  return if name == ""

  @player = Player.new(name)
  @enemy = Monster.new("スライム", 30)
  @enemy_count = 1

  timer = `setInterval(function() {`
    attack(@player, @enemy, 5, 15)

    if @enemy.hp <= 0
      # ...次の敵を作る処理: @enemy = Monster.new("スライム#{@enemy_count}", 40)...
    end
  `}, 500)`
`})`

```

クラスを理解すると、この先の「グラフィカルなゲーム」で大量のキャラクターを動かす時に、驚くほど楽にコードが書けるようになります。

次回の第6回は、いよいよ**「画面を書き換える（DOM操作）」**を詳しく学び、文字だけでなく色や形を変える「脱テキストベース」の準備に入ります！
