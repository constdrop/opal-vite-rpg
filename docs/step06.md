# Ruby RPG 講座 第6回 演出編（DOM操作）

第6回は、プログラムからWeb画面の「見た目」を自由自在に操ります。数字だけでなく、色やバーの長さで状況を伝えることで、一気に「ゲームらしく」なります！

## 今日のゴール

- HPを数字だけでなく「HPバー（グラフ）」で表示する
- 攻撃を受けた時、バーの色を緑から赤に変える
- 画面全体をフラッシュさせてダメージを演出する

## 使うファイル

- Rubyの処理: [app/main.rb](app/main.rb)
- 画面: [index.html](index.html)

## はじめに: step/06 をチェックアウトする

この回の状態に切り替えます。

```bash
git checkout step/06
```

## 1. 画面に「HPバー」を作る (index.html)

数字の代わりに伸び縮みするバーをHTMLで作ります。

```html
<div id="enemy-area"
  style="background-color: #f0f0f0; padding: 10px; margin-bottom: 10px;">
  <strong>モンスター</strong> <br>
  
  <div style="width: 100%; height: 20px; background-color: #ccc;
    border-radius: 10px; overflow: hidden;">
    <div id="enemy-hp-bar"
      style="width: 100%; height: 100%; background-color: #4caf50;
      transition: width 0.3s;"></div>
  </div>

  いまの敵のHP: <span id="enemy-hp">---</span>
</div>

<div id="flash-panel"
  style="position: fixed; top: 0; left: 0;
  width: 100%; height: 100%; background: red; opacity: 0;
  pointer-events: none; transition: opacity 0.1s;"></div>

```

## 2. Rubyから「見た目」を操る (main.rb)

CSSの値をRubyから書き換える処理を追加します。

```ruby
# main.rb に要素の取得を追加
@hp_bar = `document.getElementById('enemy-hp-bar')`
@flash_panel = `document.getElementById('flash-panel')`

# 攻撃メソッドを改造して、見た目を変える処理を入れる
def attack(player, target, min, max)
  damage = rand(min..max)
  target.receive_damage(damage)

  # --- 【今回のポイント：見た目の操作】 ---
  
  # 1. HPバーの長さを計算（現在のHP / 最大HP * 100）
  # ※ 第5回のMonsterクラスに @max_hp を追加しておくと便利です
  percentage = (target.hp.to_f / 30 * 100).to_i # 今回は最大30と仮定
  `#{@hp_bar}.style.width = #{percentage} + "%"`

  # 2. HPが少なくなったらバーの色を赤くする
  if percentage < 30
    `#{@hp_bar}.style.backgroundColor = "red"`
  else
    `#{@hp_bar}.style.backgroundColor = "#4caf50"`
  end

  # 3. ダメージ演出（画面を一瞬赤くする）
  `#{@flash_panel}.style.opacity = 0.5`
  `setTimeout(function() { #{@flash_panel}.style.opacity = 0 }, 100)`

  # --- 見た目の操作ここまで ---

  `#{@enemy_hp_span}.innerText = #{target.hp}`
  # （以下、ログ表示などは前回と同じ）
end
```

## ポイント

- **`style.width`**: CSSの値を書き換えることで、バーを伸ばしたり縮めたりできます。
- **視覚的フィードバック**: 「数字が減る」だけでなく「色が赤くなる」「画面が光る」といった変化は、プレイヤーに緊張感を与えます。
- **`setTimeout`**: JavaScriptのタイマーを使い、「一瞬だけ赤くして、すぐ戻す」という動きを作ります。

## 動作チェック

```bash
npm run dev
```

攻撃ボタンを押した時、スライムのHPバーがスムーズに減り、画面が「ビカッ」と光れば成功です！

## チャレンジ

- **バーの色を3段階に**: HPが半分なら黄色、残りわずかなら赤、となるように `if` 文を増やしてみよう。
- **揺れる演出**: ダメージを受けた時に、モンスターの名前エリアを左右に揺らすことはできるかな？（CSSの `margin-left` などを動かしてみよう）
- **勝利のカラー**: すべての敵を倒した時、背景色を祝福の金色（gold）に変えてみよう。
