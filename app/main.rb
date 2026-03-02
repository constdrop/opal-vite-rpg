# backtick_javascript: true
require 'opal'
require 'native'

# 1. HTMLの要素を見つける（メソッドの中でも使うので @ をつけます）
@log_area = `document.getElementById('log-area')`
@button = `document.getElementById('action-button')`
@special_button = `document.getElementById('special-button')`
@player_name_input = `document.getElementById('player-name')`
@enemy_hp_span = `document.getElementById('enemy-hp')`

# 攻撃のダメージを計算する部品
def calculate_damage(min, max)
  rand(min..max)
end

# 「攻撃して、HPを減らして、ログを出す」という一連の動きをまとめた部品
def attack(player_name, min, max)
  # ダメージを計算する
  damage = calculate_damage(min, max)
  
  # HPを減らす
  @enemy_hp -= damage
  @enemy_hp = 0 if @enemy_hp < 0
  
  # 画面（HP表示）を更新
  `#{@enemy_hp_span}.innerText = #{@enemy_hp}`
  
  # ログを表示
  msg = "#{player_name}の攻撃！#{damage}のダメージ！(残りHP:#{@enemy_hp})<br>"
  `#{@log_area}.innerHTML += #{msg}`
  `#{@log_area}.scrollTop = #{@log_area}.scrollHeight`
end

# 2. ボタンが押された時の処理（イベント）
`#{@button}.addEventListener('click', function() {`
  player_name = `#{@player_name_input}.value`

  if player_name == ""
    `#{@log_area}.innerHTML = "名前を入力してください！"`
  else
    `#{@log_area}.innerHTML = "--- 冒険スタート！ ---<br>"`
    `#{@button}.disabled = true`
    
    @enemy_count = 1
    @enemy_hp = 30

    timer = `setInterval(function() {`
      
      # ★作った「attack」メソッドを呼び出す！
      attack(player_name, 5, 15)

      if @enemy_hp <= 0
        finish_msg = "<b>スライム#{@enemy_count}をたおした！</b><br>"
        `#{@log_area}.innerHTML += #{finish_msg}`
        
        if @enemy_count < 3
          @enemy_count += 1
          @enemy_hp = 30 + (@enemy_count * 10)
          next_msg = ">> 次の敵があらわれた！<br>"
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

# 必殺技ボタン（クリックした瞬間に強い攻撃！）
`#{@special_button}.addEventListener('click', function() {`
  player_name = `#{@player_name_input}.value`
  
  # 名前がないときや、敵がいないときは何もしない
  if player_name != "" && @enemy_hp && @enemy_hp > 0
    `#{@log_area}.innerHTML += "<b>【必殺】ギガRubyスラッシュ！！</b><br>"`
    # ★通常攻撃より強いダメージ（30〜50）で attack メソッドを呼び出す
    attack(player_name, 30, 50)
  end
`})`
