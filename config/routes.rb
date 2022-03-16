Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
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
  # usersのブロック作成
  resources :users do
    # memberのブロック作成
    member do
      # followingとfollowersにgetのルーティング作成
      get :following, :followers
    end
  end
  # アカウント有効化に使うリソース（editアクション）を追加する
  resources :account_activations, only: [:edit]
  # パスワード再設定用リソースを追加する
  resources :password_resets,     only: [:new, :create, :edit, :update]
  # マイクロポストリソースのルーティング（newやcreateなどは不要）
  resources :microposts,          only: [:create, :destroy]
  # relationshipsのcreateとdestroyのルーティングを生成
  resources :relationships,       only: [:create, :destroy]
end