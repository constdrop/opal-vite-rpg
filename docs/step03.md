# Ruby RPG 講座 第3回 ループ編

第3回は、タイマーを使ってバトルが自動で進むようにします。第2回で作った画面とボタンを使い、敵を3体倒したらクリアになる仕組みを作ります。

## 今日のゴール

- 0.5秒ごとに攻撃ログが増える
- 敵のHPが0になったら次の敵に切り替わる
- 3体倒したらバトルが終了する

## 使うファイル

- Rubyの処理: [app/main.rb](app/main.rb)
- 画面: [index.html](index.html)

## はじめに: step/03 をチェックアウトする

この回の状態に切り替えます。

```bash
git checkout step/03
```

## 1. 名前チェックを入れる

名前が空なら、バトルを始めないようにします。

```ruby
player_name = `#{player_name_input}.value`

if player_name == ""
  `#{log_area}.innerHTML = "名前を入力してください！"`
else
  `#{log_area}.innerHTML = "--- 冒険スタート！ ---<br>"`
  `#{button}.disabled = true`
end
```

## 2. バトルの準備

敵の数とHPを覚えておくため、`@` で始まる変数に入れます。

```ruby
@enemy_count = 1
@enemy_hp = 30
```

## 3. タイマーでくり返す

`setInterval` で0.5秒ごとに攻撃します。

```ruby
timer = `setInterval(function() {`
  damage = rand(5..15)
  @enemy_hp -= damage
  @enemy_hp = 0 if @enemy_hp < 0

  `#{enemy_hp_span}.innerText = #{@enemy_hp}`

  msg = "#{player_name}の攻撃！#{damage}のダメージ！(残りHP:#{@enemy_hp})<br>"
  `#{log_area}.innerHTML += #{msg}`
  `#{log_area}.scrollTop = #{log_area}.scrollHeight`

  if @enemy_hp <= 0
    finish_msg = "<b>スライム#{@enemy_count}をたおした！</b><br>"
    `#{log_area}.innerHTML += #{finish_msg}`

    if @enemy_count < 3
      @enemy_count += 1
      @enemy_hp = 30 + (@enemy_count * 10)
      next_msg = ">> 次の敵があらわれた！<br>"
      `#{log_area}.innerHTML += #{next_msg}`
    else
      `clearInterval(#{timer})`
      complete_msg = "<b>★すべての敵を撃破した！★</b>"
      `#{log_area}.innerHTML += #{complete_msg}`
      `#{log_area}.scrollTop = #{log_area}.scrollHeight`
      `#{button}.disabled = false`
    end
  end
`}, 500)`
```

ポイント:

- `rand(5..15)` で毎回違うダメージにする
- HPがマイナスにならないように0で止める
- ログは `innerHTML +=` で追記する
- `clearInterval` でループを止める

## 動作チェック

```bash
npm run dev
```

ボタンを押して、敵を3体倒したらクリア表示が出れば成功です。

## チャレンジ

- 敵の名前を「スライム」以外にも変えてみよう
- ダメージの最大値を `rand(5..20)` に変えるとどうなる？
- クリアしたときに「もう一度」ボタンを出してみよう
