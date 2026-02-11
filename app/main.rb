require 'opal'
require 'native' # ブラウザの機能を使うためのライブラリ

# 1. HTMLの要素を見つける
message_div = `document.getElementById('message-area')`
button = `document.getElementById('action-button')`
player_name_input = `document.getElementById('player-name')`

# 2. ボタンが押された時の処理（イベント）
`#{button}.addEventListener('click', function() {`
  
  # ユーザーが入力した名前を取得する
  player_name = `#{player_name_input}.value`
  
  # Rubyのコードでメッセージを作成
  greeting = "#{player_name}は 旅に 出た！"
  
  # 画面を書き換える
  `#{message_div}.innerText = #{greeting}`
  
  # コンソール（開発者ツール）にも出してみる
  puts "ボタンが押されました！"
  
`})`
