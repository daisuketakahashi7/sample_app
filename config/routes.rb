Rails.application.routes.draw do
  get 'users/new'
  root 'static_pages#home'
  #getリクエストが　/helpに送信されたとき,　
  #static_pagesコントローラーの　helpアクションが　呼び出される*/
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  #/users/1 のURLを有効にする
  resources :users
end