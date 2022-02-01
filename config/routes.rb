Rails.application.routes.draw do
  root 'static_pages#home'
  #getリクエストが　/helpに送信されたとき,　
  #static_pagesコントローラーの　helpアクションが　呼び出される*/
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
end