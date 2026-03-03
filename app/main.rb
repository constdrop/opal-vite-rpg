# backtick_javascript: true
require 'opal'
require 'native'

# --- 1. 設計図（クラス）の作成 ---

# プレイヤーの設計図
class Player
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

# モンスターの設計図
class Monster
  attr_accessor :name, :hp
  def initialize(name, hp)
    @name = name
    @hp = hp
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
@special_button = `document.getElementById('special-button')`
@player_name_input = `document.getElementById('player-name')`
@enemy_hp_span = `document.getElementById('enemy-hp')`

# --- 3. 攻撃の仕組み（メソッド） ---
# 引数に「playerオブジェクト」と「target（モンスター）オブジェクト」を渡すように変更
def attack(player, target, min, max)
  damage = rand(min..max)
  
  # モンスターにダメージを与える命令を出す
  target.receive_damage(damage)
  
  # 画面（HP表示）を更新
  `#{@enemy_hp_span}.innerText = #{target.hp}`
  
  # ログを表示
  msg = "#{player.name}の攻撃！#{target.name}に#{damage}のダメージ！(残りHP:#{target.hp})<br>"
  `#{@log_area}.innerHTML += #{msg}`
  `#{@log_area}.scrollTop = #{@log_area}.scrollHeight`
end

# --- 4. ボタンが押された時の処理 ---
`#{@button}.addEventListener('click', function() {`
  name = `#{@player_name_input}.value`

  if name == ""
    `#{@log_area}.innerHTML = "名前を入力してください！"`
  else
    `#{@log_area}.innerHTML = "--- 冒険スタート！ ---<br>"`
    `#{@button}.disabled = true`
    
    # ★ 設計図から実体（インスタンス）を作る！
    @player = Player.new(name)
    @enemy_count = 1
    @enemy = Monster.new("スライム#{@enemy_count}", 30)
    
    `#{@enemy_hp_span}.innerText = #{@enemy.hp}`

    timer = `setInterval(function() {`
      
      # オブジェクトを渡して攻撃！
      attack(@player, @enemy, 5, 15)

      if @enemy.hp <= 0
        finish_msg = "<b>#{@enemy.name}をたおした！</b><br>"
        `#{@log_area}.innerHTML += #{finish_msg}`
        
        if @enemy_count < 3
          @enemy_count += 1
          # 新しいモンスターを生成して入れ替える
          @enemy = Monster.new("スライム#{@enemy_count}", 30 + (@enemy_count * 10))
          
          next_msg = ">> 次の敵、#{@enemy.name}があらわれた！<br>"
          `#{@log_area}.innerHTML += #{next_msg}`
        else
          `clearInterval(#{timer})`
          `#{@log_area}.innerHTML += "<b>★すべての敵を撃破した！★</b>"`
          `#{@log_area}.scrollTop = #{@log_area}.scrollHeight`
          `#{@button}.disabled = false`
        end
      end
    `}, 500)`
  end
`})`

# 必殺技ボタン
`#{@special_button}.addEventListener('click', function() {`
  # @player と @enemy が存在し、敵が生きているときだけ発動
  if @player && @enemy && @enemy.hp > 0
    `#{@log_area}.innerHTML += "<b>【必殺】ギガRubyスラッシュ！！</b><br>"`
    attack(@player, @enemy, 30, 50)
  end
`})`
