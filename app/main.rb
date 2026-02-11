require 'opal'
require 'native' # ブラウザの機能を使うためのライブラリ

# 1. HTMLの要素を見つける
# $はJavaScriptのグローバル変数（windowやdocument）にアクセスする記号
message_div = `document.getElementById('message-area')`
button = `document.getElementById('action-button')`

# 2. ボタンが押された時の処理（イベント）
`#{button}.addEventListener('click', function() {`
  
  # Rubyのコードでメッセージを作成
  player_name = "勇者"
  greeting = "#{player_name}は 旅に 出た！"
  
  # 画面を書き換える
  `#{message_div}.innerText = #{greeting}`
  
  # コンソール（開発者ツール）にも出してみる
  puts "ボタンが押されました！"
  
`})`
