# Ruby RPG 講座 第7回 コマンド選択編

第7回は、バトルの主導権をコンピュータからプレイヤーの手に取り戻します。タイマーによる自動実行を止め、ボタンが押されたときだけ話が進む「ターン制」の仕組みを作ります。

## 今日のゴール

- オートバトルのタイマー（`setInterval`）を削除する
- 「こうげき」ボタンを押したときだけ攻撃し、そのあと敵が「反撃」してくるようにする
- プレイヤーのHPを作り、0になったら「ゲームオーバー」を表示する
- 「冒険の準備（リセット）」で勇者HPと各バー表示を初期状態に戻す

## 使うファイル

- Rubyの処理: [app/main.rb](app/main.rb)
- 画面: [index.html](index.html)

## はじめに: step/07 をチェックアウトする

```bash
git checkout step/07
```

---

## 1. 画面を「コマンド式」に書き換える (index.html)

自分のHP状況がわかるように「プレイヤーエリア」を作り、行動を選ぶためのボタンを用意します。

```html
<div id="player-area" style="background-color: #e0f0ff; padding: 10px; margin-bottom: 10px; border: 1px solid #2196f3;">
  <strong>勇者（あなた）</strong> <br>
  <div style="width: 100%; height: 15px; background-color: #ccc; border-radius: 5px; overflow: hidden; margin: 5px 0;">
    <div id="player-hp-bar" style="width: 100%; height: 100%; background-color: #2196f3; transition: width 0.3s;"></div>
  </div>
  HP: <span id="player-hp">---</span>
</div>

<div id="enemy-area" ...> (略) </div>

<div id="command-menu" style="display: flex; gap: 10px;">
  <button id="attack-btn" style="padding: 10px 20px;">こうげき</button>
  <button id="heal-btn" style="padding: 10px 20px;">かいふく</button>
</div>

<button id="action-button" style="margin-top: 10px;">冒険の準備（リセット）</button>
```

## 2. 設計図をアップデートする (main.rb)

プレイヤーもダメージを受けるようになるので、HPの仕組みを `Player` クラスにも追加します。

```ruby
class Player
  attr_accessor :name, :hp, :max_hp
  def initialize(name)
    @name = name
    @max_hp = 50
    @hp = @max_hp # 最初は満タン
  end

  def receive_damage(amount)
    @hp -= amount
    @hp = 0 if @hp < 0
  end

  # 第7回では未使用。チャレンジで「かいふく」を作るときに使う
  def heal(amount)
    @hp += amount
    @hp = @max_hp if @hp > @max_hp
  end
end

class Monster
  # モンスターには「攻撃力(power)」を追加してみましょう
  attr_accessor :name, :hp, :power
  def initialize(name, hp, power)
    @name = name
    @hp = hp
    @power = power
  end
  # ...receive_damageなどは前回と同じ
end
```

## 3. ターンの流れを作る (main.rb)

第3回で使った `setInterval`（タイマー）を思い切って**削除**します。その代わりに、ボタンが押された時の「流れ」を定義します。

```ruby
# 敵の反撃（敵のターン）
def enemy_turn
  return if !@player || !@enemy
  return if @enemy.hp <= 0 || @player.hp <= 0

  damage = rand(5..15)
  @player.receive_damage(damage)
  
  # 画面の更新（プレイヤーのHPバー）
  percent = (@player.hp.to_f / @player.max_hp * 100).to_i
  `#{@player_hp_bar}.style.width = #{percent} + "%"`
  `#{@player_hp_span}.innerText = #{@player.hp}`
  
  msg = "<b>#{@enemy.name}のはんげき！#{@player.name}は#{damage}のダメージを受けた！</b><br>"
  `#{@log_area}.innerHTML += #{msg}`
  
  if @player.hp <= 0
    `#{@log_area}.innerHTML += "<h2 style='color:red;'>GAME OVER...</h2>"`
    `document.getElementById('command-menu').style.display = 'none'` # ボタンを消す
  end
end

# プレイヤーの攻撃（ボタンが押されたとき）
`#{@attack_button}.addEventListener('click', function() {`
  if @player && @enemy && @player.hp > 0 && @enemy.hp > 0
    # 1. 自分の攻撃
    attack(@player, @enemy, 5, 15)

    # 2. 0.8秒待ってから敵が反撃してくる演出
    if @enemy.hp > 0
      `setTimeout(function() {`
        enemy_turn()
      `}, 800)`
    end
  end
`})`
```

## 4. リセット時の初期化を入れる (main.rb)

「冒険の準備（リセット）」を押したら、プレイヤーと敵のインスタンスを作り直し、表示も初期化します。

```ruby
`#{@button}.addEventListener('click', function() {`
  name = `#{@player_name_input}.value`

  if name == ""
    `#{@log_area}.innerHTML = "名前を入力してください！"`
  else
    `#{@log_area}.innerHTML = "--- 冒険スタート！ ---<br>"`

    @player = Player.new(name)
    @enemy_count = 1
    @enemy = Monster.new("スライム#{@enemy_count}", 30, 10)

    `#{@enemy_hp_span}.innerText = #{@enemy.hp}`
    `#{@hp_bar}.style.width = "100%"`
    `#{@hp_bar}.style.backgroundColor = "#4caf50"`
    `#{@player_hp_bar}.style.width = "100%"`
    `#{@player_hp_span}.innerText = #{@player.hp}`
    `document.getElementById('command-menu').style.display = 'flex'`
  end
`})`
```

## ポイント

- **脱・自動化**: `setInterval` を消すことで、自分のペースで戦えるようになります。
- **ターンの演出**: `setTimeout` を使うことで、攻撃の直後に反撃がくる「バトルのリズム」が生まれます。
- **条件チェック**: 「もし敵が死んでいたら反撃しない」「もし自分が死んでいたら攻撃できない」という `if` 文が、ゲームのルールを守ります。

## 動作チェックと操作方法

1. **名前を入力**: テキストボックスに名前を入れます。
2. **「冒険の準備」ボタン**: 勇者とスライムが登場します。
3. **「こうげき」ボタン**: 
   - 自分が攻撃します（スライムのHPが減る）。
   - 少し待つとスライムが反撃してきます（自分のHPが減る）。
4. **リセット確認**: もう一度「冒険の準備（リセット）」を押すと、勇者HPが満タン（50）に戻ります。
5. **決着**: どちらかのHPが0になるまでボタンを押して戦います。

## チャレンジ

- **かいふくの実装**: `main.rb` の `heal-btn` のイベントは今コメントアウトされています。コメントを外して、回復処理を動かしてみよう（ただし最大HPを超えないように注意！）。
- **連打禁止**: 敵が反撃している間（`setTimeout` の間）、ボタンを押せなくするにはどうすればいいかな？
- **背景演出**: 自分のHPが 20% 以下になったら、プレイヤーエリアの背景色を黄色（警告色）に変えてみよう。
- **逃げるボタン**: 50%の確率でバトルを終了させる「にげる」を作ってみよう。
- **敵のバリエーション**: `Monster.new` する時に、攻撃力が高い敵やHPが高い敵など、性格を変えてみよう。
