Rails.application.routes.draw do
  root 'static_pages#home'
  # getリクエストが　/helpに送信されたとき,　
  # static_pagesコントローラーの　helpアクションが　呼び出される*/
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  # リソースを追加して標準的なRESTfulアクションをgetできるようにする
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  # /users/1 のURLを有効にする
  resources :users
end