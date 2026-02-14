# Ruby RPG 講座 第2回 条件分岐編

第2回は、条件分岐（if/else）を使って、入力やHPによって表示が変わる仕組みを作ります。前回のセットアップが終わっている前提です。

## 今日のゴール

- if/else で分かれ道を作れる
- 条件によってログの内容を変えられる
- 入力チェックができる

## 使うファイル

- 画面: [index.html](index.html)
- Rubyの処理: [app/main.rb](app/main.rb)
- Rubyの読み込み: [app/main_loader.js](app/main_loader.js)

## はじめに: step/02 をチェックアウトする

この回の状態に切り替えます。

```bash
git checkout step/02
```

## 1. 条件分岐の基本

Rubyの if/else は「もし〜なら／そうでなければ」を作る文法です。

```ruby
hp = 10

if hp <= 0
  puts "やられた！"
else
  puts "まだ元気！"
end
```

## 2. 名前チェックで分岐しよう

入力が空かどうかで、ログの内容を切り替えます。

```ruby
`#{button}.addEventListener('click', function() {`
  player_name = `#{player_name_input}.value`

  if player_name == ""
    `#{log_area}.innerHTML = "名前を入力してください！"`
  else
    `#{log_area}.innerHTML = "--- 冒険スタート！ ---<br>"`
    `#{enemy_hp_span}.innerText = 30`
  end
`})`
```

ポイント:

- 空文字 `""` は「何も入っていない」状態
- 条件が true のときだけ上の処理が動く

## 3. HPで分岐しよう（追加例）

敵のHPが0以下になったら、ログに勝利メッセージを出す例です。

補足: `@` がついた変数は、次にボタンを押した時も **「前の値を覚えている」** 魔法の変数です。

```ruby
if @enemy_hp <= 0
  `#{log_area}.innerHTML += "<b>スライムをたおした！</b><br>"`
else
  `#{log_area}.innerHTML += "まだ敵がいるぞ！<br>"`
end
```

```ruby
`#{button}.addEventListener('click', function() {`
  player_name = `#{player_name_input}.value`

  if player_name == ""
    `#{log_area}.innerHTML = "名前を入力してください！"`
  else
    `#{log_area}.innerHTML = "--- 冒険スタート！ ---<br>"`
    `#{enemy_hp_span}.innerText = 30`
  end
`})`
```

## 動作チェック

```bash
npm run dev
```

名前を入れたときと入れないときで、ログの内容が変われば成功です。

## 次回予告

次回は、タイマーを使ってくり返し攻撃が進むバトルを作ります。
