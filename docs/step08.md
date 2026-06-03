# Ruby RPG 講座 第8回 演出編（CSSクラス切り替え）

第8回は、HTMLの見た目をガラッと変える「CSSのクラス」をRubyからコントロールします。
第6回では「バーの長さ」などの数字を直接変えましたが、今回はあらかじめ用意したデザイン（CSSクラス）を、状況に合わせて「着せ替え」させるテクニックを学びます。

## 今日のゴール

* HPが減ってピンチ（20%以下）になったら、画面やメーターに「ピンチ用CSSクラス」をつける
* ピンチのときに画面が赤くピコピコ点滅するアニメーションを作る
* 安全な状態に戻ったら（回復したら）、自動で元のデザインの服に着せ替える

## 使うファイル

* Rubyの処理: [app/main.rb](app/main.rb)
* 画面とデザイン: [index.html](index.html)

## はじめに: step/08 をチェックアウトする

この回の状態に切り替えます。

```bash
git checkout step/08

```

---

## 1. HTMLに「ピンチ用のデザイン」を準備する (index.html)

まずは、HPが減ったとき用の特別なデザイン（CSS）を `<style>` タグの中に追加します。今回は「赤く点滅するアニメーション」を用意します。

```html
<head>
  <meta charset="UTF-8">
  <title>Ruby RPG 第8回</title>
  <style>
    /* 通常時のプレイヤーエリア */
    #player-area {
      background-color: #e0f0ff;
      padding: 10px;
      margin-bottom: 10px;
      border: 1px solid #2196f3;
      transition: background-color 0.5s; /* 色の変化をなめらかに */
    }

    /* ★追加：HPがピンチ（危険）なときのデザイン */
    #player-area.danger-state {
      animation: blink-red 1s infinite alternate; /* 1秒ごとに赤く点滅 */
    }

    /* ★追加：ピンチのときのHPメーターの色 */
    .bar-danger {
      background-color: #f44336 !important; /* 強制的に赤色にする */
    }

    /* 点滅アニメーションのルール */
    @keyframes blink-red {
      0% { background-color: #e0f0ff; }
      100% { background-color: #ffcccc; border-color: red; }
    }
  </style>
</head>

```

---

## 2. Ruby側でプレイヤーエリアを取得する (main.rb)

着せ替えを指示するために、プレイヤーエリアとHPバーの要素を新しく変数に登録します。

```ruby
# 1. HTMLの要素を見つける（前回のコードに追加）
@heal_button = `document.getElementById('heal-btn')`
@player_area = `document.getElementById('player-area')`
@player_hp_bar = `document.getElementById('player-hp-bar')`

```

---

## 3. HPをチェックしてクラスを切り替える (main.rb)

第7回で作った「敵の反撃（`enemy_turn`）」と、新しく作る「回復」の処理のあとに、「HPが20%以下ならピンチの服を着せる、そうじゃなければ脱がせる」という条件分岐を入れます。

```ruby
# プレイヤーの見た目をアップデートする新しいメソッド
def update_player_style
  return unless @player

  percent = (@player.hp.to_f / @player.max_hp * 100).to_i

  if percent <= 20
    # ★20%以下なら「danger-state」と「bar-danger」のクラス（衣装）をつける
    `#{@player_area}.classList.add('danger-state')`
    `#{@player_hp_bar}.classList.add('bar-danger')`
  else
    # ★回復して安全になったら、ピンチの衣装を脱がせる
    `#{@player_area}.classList.remove('danger-state')`
    `#{@player_hp_bar}.classList.remove('bar-danger')`
  end
end

# 敵の反撃（ enemy_turn メソッドの中身を改造 ）
def enemy_turn
  return if @enemy.hp <= 0

  damage = rand(Math.floor(@enemy.power * 0.8)..Math.floor(@enemy.power * 1.2))
  @player.receive_damage(damage)
  
  percent = (@player.hp.to_f / @player.max_hp * 100).to_i
  `#{@player_hp_bar}.style.width = #{percent} + "%"`
  `document.getElementById('player-hp').innerText = #{@player.hp}`
  
  # ★ここで見た目のチェックを呼び出す！
  update_player_style()

  `#{@log_area}.innerHTML += "敵の反撃！#{damage}のダメージ！<br>"`
  
  if @player.hp <= 0
    `#{@log_area}.innerHTML += "<h2 style='color:red;'>GAME OVER...</h2>"`
    `document.getElementById('command-menu').style.display = 'none'`
  end
end

# 回復（ heal-btn ）の中でも見た目チェックを呼ぶ
`#{@heal_button}.addEventListener('click', function() {`
  if @player && @enemy && @player.hp > 0 && @enemy.hp > 0
    heal_amount = rand(8..15)
    @player.heal(heal_amount)

    percent = (@player.hp.to_f / @player.max_hp * 100).to_i
    `#{@player_hp_bar}.style.width = #{percent} + "%"`
    `document.getElementById('player-hp').innerText = #{@player.hp}`

    # ★回復したあとも必ず見た目を更新
    update_player_style()
  end
`})`

```

---

## ポイント

* **`classList.add` と `classList.remove`**:
JavaScriptのこの命令を使うと、HTML要素にCSSのクラス名をつけたり消したりできます。Rubyの中に直接「背景を赤くして、枠線を太くして…」とたくさん書くよりも、CSSにまとめておいて「クラス名だけを切り替える」ほうが、コードが圧倒的にスッキリします。
* **アニメーションの連動**:
CSS側で `infinite`（無限ループ）の点滅アニメーションを設定しておくことで、Rubyからは「ピンチだよ」と1回クラスをつけるだけで、画面がずっとピコピコ警告を出し続けてくれるようになります。

---

## 動作チェック

```bash
npm run dev

```

1. 冒険をスタートし、「こうげき」を押してわざと敵の反撃を受けます。
2. 自分のHPが減っていき、残り10（20%以下）になった瞬間に、プレイヤーのエリアが赤く点滅し、青かったHPバーが赤色に変われば大成功です！

---

## チャレンジ

* **「かいふく」での復活**: 第7回のチャレンジで作った「かいふくボタン」を押してHPが20%より多くなったとき、ちゃんと赤色の点滅が止まって元の青い画面に戻るか確かめてみよう（回復処理のあとにも `update_player_style()` を呼び出す必要があります）。
* **モンスターのピンチ演出**: モンスターのHPも少なくなったら、モンスターエリアが弱々しく「半透明（opacity: 0.5）」になるクラスを作って、切り替えてみよう。
* **ピンチの時の文字変化**: CSSの `.danger-state` の中に `color: red;` や `font-weight: bold;` を追加して、ピンチのときは文字の見た目も変わるようにしてみよう。
