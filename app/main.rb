# backtick_javascript: true
require 'opal'
require 'native'

# 1. HTMLの要素を見つける
log_area = `document.getElementById('log-area')`
button = `document.getElementById('action-button')`
player_name_input = `document.getElementById('player-name')`
enemy_hp_span = `document.getElementById('enemy-hp')`

# 2. ボタンが押された時の処理（イベント）
`#{button}.addEventListener('click', function() {`
  
  # ユーザーが入力した名前を取得する
  player_name = `#{player_name_input}.value`

  # 判断1：名前が入っているか？
  if player_name == ""
    `#{log_area}.innerHTML = "名前を入力してください！"`
  else
    # バトルの初期設定（インスタンス変数 @ を使って値を保持する）
    `#{log_area}.innerHTML = "--- 冒険スタート！ ---<br>"`
    `#{button}.disabled = true`
    
    @enemy_count = 1
    @enemy_hp = 30

    # ★ 0.5秒ごとに実行するタイマー
    timer = `setInterval(function() {`
      
      # 攻撃のダメージ計算
      damage = rand(5..15)
      @enemy_hp -= damage
      @enemy_hp = 0 if @enemy_hp < 0
      
      # 画面を更新（一度Rubyでメッセージを作ってから渡す！）
      `#{enemy_hp_span}.innerText = #{@enemy_hp}`
      
      msg = "#{player_name}の攻撃！#{damage}のダメージ！(残りHP:#{@enemy_hp})<br>"
      `#{log_area}.innerHTML += #{msg}`
      `#{log_area}.scrollTop = #{log_area}.scrollHeight`

      # 判断2：敵を倒したか？
      if @enemy_hp <= 0
        finish_msg = "<b>スライム#{@enemy_count}をたおした！</b><br>"
        `#{log_area}.innerHTML += #{finish_msg}`
        
        if @enemy_count < 3
          # まだ次の敵がいる場合
          @enemy_count += 1
          @enemy_hp = 30 + (@enemy_count * 10)
          next_msg = ">> 次の敵があらわれた！<br>"
          `#{log_area}.innerHTML += #{next_msg}`
        else
          # すべて倒した場合：ループを止める
          `clearInterval(#{timer})`
          complete_msg = "<b>★すべての敵を撃破した！★</b>"
          `#{log_area}.innerHTML += #{complete_msg}`
          `#{log_area}.scrollTop = #{log_area}.scrollHeight`
          `#{button}.disabled = false`
        end
      end

    `}, 500)` # 500ミリ秒ごとに繰り返す

  end
  
`})`
