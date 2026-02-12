# backtick_javascript: true
require 'opal'
require 'native'

# 1. HTMLの要素を見つける
message_div = `document.getElementById('message-area')`
button = `document.getElementById('action-button')`
player_name_input = `document.getElementById('player-name')`
enemy_hp_span = `document.getElementById('enemy-hp')`

# ゲームのデータ
@enemy_hp = 30

# 2. ボタンが押された時の処理（イベント）
`#{button}.addEventListener('click', function() {`
  
  # ユーザーが入力した名前を取得する
  player_name = `#{player_name_input}.value`

  # 判断1：名前が入っているか？
  if player_name == ""
    `#{message_div}.innerText = "名前を入力してください！"`
  else
    # --- 名前がある時だけ、以下のバトル処理を実行する ---
    
    damage = 10
    @enemy_hp -= damage
    
    # HPがマイナスにならないようにする（第2回のポイント！）
    @enemy_hp = 0 if @enemy_hp < 0
    `#{enemy_hp_span}.innerText = #{@enemy_hp}`

    # 判断2：敵を倒したか？
    if @enemy_hp <= 0
      message = "#{player_name}の攻撃！スライムをたおした！"
      `#{button}.disabled = true`
    else
      message = "#{player_name}の攻撃！スライムに #{damage} のダメージ！"
    end
    
    `#{message_div}.innerText = #{message}`
  end
  
`})`
