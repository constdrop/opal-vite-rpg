# backtick_javascript: true
require 'opal'
require 'native'

# --- 1. 設計図（クラス）の作成 ---

# プレイヤーの設計図
class Player
  attr_accessor :name, :hp, :max_hp
  def initialize(name)
    @name = name
    @max_hp = 50
    @hp = @max_hp
  end

  def receive_damage(amount)
    @hp -= amount
    @hp = 0 if @hp < 0
  end

  def heal(amount)
    @hp += amount
    @hp = @max_hp if @hp > @max_hp
  end
end

# モンスターの設計図
class Monster
  attr_accessor :name, :hp, :max_hp, :power
  def initialize(name, hp, power)
    @name = name
    @hp = hp
    @max_hp = hp
    @power = power
  end

  # ダメージを受けるという「動き」も設計図に入れておく
  def receive_damage(amount)
    @hp -= amount
    @hp = 0 if @hp < 0
  end
end

# --- 2. HTML要素の取得 ---
@log_area = `document.getElementById('log-area')`
@button = `document.getElementById('action-button')`
@attack_button = `document.getElementById('attack-btn')`
@heal_button = `document.getElementById('heal-btn')`
@player_name_input = `document.getElementById('player-name')`
@enemy_hp_span = `document.getElementById('enemy-hp')`
@hp_bar = `document.getElementById('enemy-hp-bar')`
@flash_panel = `document.getElementById('flash-panel')`
@player_area = `document.getElementById('player-area')`
@player_hp_bar = `document.getElementById('player-hp-bar')`
@player_hp_span = `document.getElementById('player-hp')`

# --- 3. 攻撃の仕組み（メソッド） ---
def attack(player, target, min, max)
  damage = rand(min..max)
  target.receive_damage(damage)

  percentage = (target.hp.to_f / target.max_hp * 100).to_i
  enemy_label = "#{target.name} (HP: #{target.hp})"
  `#{@enemy_hp_span}.innerText = #{enemy_label}`
  `#{@hp_bar}.style.width = #{percentage} + "%"`

  if percentage < 30
    `#{@hp_bar}.style.backgroundColor = "red"`
  else
    `#{@hp_bar}.style.backgroundColor = "#4caf50"`
  end

  # 3. ダメージ演出（画面を一瞬赤くする）
  `#{@flash_panel}.style.opacity = 0.5`
  `setTimeout(function() { #{@flash_panel}.style.opacity = 0 }, 100)`

  # --- 見た目の操作ここまで ---

  # ログを表示
  msg = "#{player.name}の攻撃！#{target.name}に#{damage}のダメージ！(残りHP:#{target.hp})<br>"
  `#{@log_area}.innerHTML += #{msg}`
  `#{@log_area}.scrollTop = #{@log_area}.scrollHeight`
end

# プレイヤーHPの割合に合わせて見た目を切り替える
def update_player_style
  return unless @player

  percent = (@player.hp.to_f / @player.max_hp * 100).to_i

  if percent <= 20
    `#{@player_area}.classList.add('danger-state')`
    `#{@player_hp_bar}.classList.add('bar-danger')`
  else
    `#{@player_area}.classList.remove('danger-state')`
    `#{@player_hp_bar}.classList.remove('bar-danger')`
  end
end

# 敵の攻撃（敵のターン）の処理
def enemy_turn
  return if !@player || !@enemy
  return if @enemy.hp <= 0 || @player.hp <= 0

  min_damage = [(@enemy.power * 0.6).to_i, 3].max
  max_damage = @enemy.power
  damage = rand(min_damage..max_damage)
  @player.receive_damage(damage)
  
  # プレイヤーのHPバーを更新
  percent = (@player.hp.to_f / @player.max_hp * 100).to_i
  `#{@player_hp_bar}.style.width = #{percent} + "%"`
  `#{@player_hp_span}.innerText = #{@player.hp}`

  update_player_style()
  
  msg = "<b>#{@enemy.name}のはんげき！#{@player.name}は#{damage}のダメージを受けた！</b><br>"
  `#{@log_area}.innerHTML += #{msg}`
  `#{@log_area}.scrollTop = #{@log_area}.scrollHeight`

  if @player.hp <= 0
    `#{@log_area}.innerHTML += "<h2 style='color:red;'>GAME OVER...</h2>"`
    `document.getElementById('command-menu').style.display = 'none'`
  end
end

# こうげきボタンが押されたとき
`#{@attack_button}.addEventListener('click', function() {`
  if @player && @enemy && @player.hp > 0 && @enemy.hp > 0
    # 1. プレイヤーの攻撃
    attack(@player, @enemy, 5, 15)

    if @enemy.hp > 0
      # 2. 少し遅れて敵のターンが来る
      `setTimeout(function() {`
        enemy_turn()
      `}, 800)`
    else
      # 3. 倒した敵の表示と次の敵への切り替え
      defeat_msg = "<b>#{@enemy.name}をたおした！</b><br>"
      `#{@log_area}.innerHTML += #{defeat_msg}`

      if @enemy_count < @enemy_total_count
        @enemy_count += 1

        enemies = [
          ["スライム", 26, 8],
          ["ゴブリン", 34, 10],
          ["ドラゴンのこども", 42, 12]
        ]
        enemy_data = enemies[@enemy_count - 1] || enemies[-1]
        @enemy = Monster.new(enemy_data[0], enemy_data[1], enemy_data[2])

        `#{@log_area}.innerHTML += ">> 次の敵があらわれた！<br>"`

        next_percentage = (@enemy.hp.to_f / @enemy.max_hp * 100).to_i
        next_enemy_label = "#{@enemy.name} (HP: #{@enemy.hp})"
        `#{@enemy_hp_span}.innerText = #{next_enemy_label}`
        `#{@hp_bar}.style.width = #{next_percentage} + "%"`
        `#{@hp_bar}.style.backgroundColor = "#4caf50"`
      else
        `#{@log_area}.innerHTML += "<b>★すべての敵を撃破した！★</b>"`
        `document.getElementById('command-menu').style.display = 'none'`
      end

      `#{@log_area}.scrollTop = #{@log_area}.scrollHeight`
    end
  end
`})`

# 冒険スタートボタンが押された時の処理
`#{@button}.addEventListener('click', function() {`
  name = `#{@player_name_input}.value`

  if name == ""
    `#{@log_area}.innerHTML = "名前を入力してください！"`
  else
    `#{@log_area}.innerHTML = "--- 冒険スタート！ ---<br>"`
    
    # ★ 設計図から実体（インスタンス）を作る！
    @player = Player.new(name)
    @enemy_count = 1
    @enemy_total_count = 3
    @enemy = Monster.new("スライム", 26, 8)
    
    enemy_label = "#{@enemy.name} (HP: #{@enemy.hp})"
    `#{@enemy_hp_span}.innerText = #{enemy_label}`
    `#{@hp_bar}.style.width = "100%"`
    `#{@hp_bar}.style.backgroundColor = "#4caf50"`
    `#{@player_hp_bar}.style.width = "100%"`
    `#{@player_hp_span}.innerText = #{@player.hp}`
    `document.getElementById('command-menu').style.display = 'flex'`
    update_player_style()
  end
`})`

# かいふくボタン
`#{@heal_button}.addEventListener('click', function() {`
  if @player && @enemy && @player.hp > 0 && @enemy.hp > 0
    heal_amount = rand(8..15)
    @player.heal(heal_amount)

    percent = (@player.hp.to_f / @player.max_hp * 100).to_i
    `#{@player_hp_bar}.style.width = #{percent} + "%"`
    `#{@player_hp_span}.innerText = #{@player.hp}`
    update_player_style()

    msg = "#{@player.name}は#{heal_amount}かいふくした！ (HP:#{@player.hp}/#{@player.max_hp})<br>"
    `#{@log_area}.innerHTML += #{msg}`
    `#{@log_area}.scrollTop = #{@log_area}.scrollHeight`

    if @enemy.hp > 0
      `setTimeout(function() {`
        enemy_turn()
      `}, 800)`
    end
  end
`})`
