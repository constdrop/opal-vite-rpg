# Ruby RPG 講座 第4回 メソッド編

第4回は、プログラムを整理整頓する「メソッド」を学びます。バラバラに書いていた「攻撃」の仕組みに名前をつけて、いつでも呼び出せる「部品」にします。

## 今日のゴール

* ダメージ計算を専用のメソッドにする
* 「攻撃〜画面更新」のセットを `attack` メソッドにまとめる
* 同じメソッドを使って「通常攻撃」と「必殺技」の2種類を作る

## 使うファイル

* Rubyの処理: [app/main.rb](https://www.google.com/search?q=app/main.rb)
* 画面: [index.html](https://www.google.com/search?q=index.html)

## はじめに: step/04 をチェックアウトする

この回の状態に切り替えます。

```bash
git checkout step/04

```

## 1. ダメージ計算をメソッドにする

まずはダメージを決めるだけの小さな部品を作ります。

```ruby
def calculate_damage(min, max)
  rand(min..max)
end

```

## 2. 攻撃の一連の流れをまとめる

「計算する」「HPを減らす」「画面を書き換える」「ログを出す」というセットを `attack` メソッドにまとめます。

```ruby
def attack(player_name, min, max)
  # 1. 上で作った計算メソッドを呼び出す
  damage = calculate_damage(min, max)
  
  # 2. HPを減らす
  @enemy_hp -= damage
  @enemy_hp = 0 if @enemy_hp < 0
  
  # 3. 画面（HP表示）を更新
  `#{@enemy_hp_span}.innerText = #{@enemy_hp}`
  
  # 4. ログを表示
  msg = "#{player_name}の攻撃！#{damage}のダメージ！(残りHP:#{@enemy_hp})<br>"
  `#{@log_area}.innerHTML += #{msg}`
  `#{@log_area}.scrollTop = #{@log_area}.scrollHeight`
end

```

## 3. タイマーの中でメソッドを使う

オートバトルのループを、作ったメソッドでスッキリ書き換えます。

```ruby
timer = `setInterval(function() {`
  # ★ attackメソッドを呼び出すだけでよくなった！
  attack(player_name, 5, 15)

  if @enemy_hp <= 0
    # （中略：敵を倒したときの処理）
  end
`}, 500)`

```

## 4. 必殺技ボタンを追加する

同じ `attack` メソッドを使って、大ダメージを与える必殺技ボタンを作ります。

```ruby
`#{@special_button}.addEventListener('click', function() {`
  player_name = `#{@player_name_input}.value`
  return if player_name == "" || @enemy_hp <= 0

  `#{@log_area}.innerHTML += "<b>【必殺】ギガRubyスラッシュ！</b><br>"`
  # ★ 強さを変えて attack メソッドを呼び出す
  attack(player_name, 50, 100)
`})`

```

ポイント:

* **引数（ひきすう）**: メソッドに渡す数字を変えるだけで、弱攻撃にも強攻撃にもなる
* **再利用**: 同じ仕組みを2回書かなくて済む（DRYの原則）
* **読みやすさ**: 何をしているか（attack）が名前でわかるようになる

## 動作チェック

```bash
npm run dev

```

オートバトル中に「必殺技」ボタンを押して、スライムに大ダメージを与えられれば大成功です！

## チャレンジ

* **会心の一撃**: `calculate_damage` の中で `if` を使い、たまにダメージが2倍になるようにしてみよう
* **回復魔法**: HPを増やす `heal` メソッドを自分で作ってみよう
* **守備力**: 引数に「敵のまもり」を追加して、ダメージを減らす計算を入れてみよう
