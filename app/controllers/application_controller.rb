class ApplicationController < ActionController::Base
  # ApplicationコントローラにSessionヘルパーモジュールを読み込む
  include SessionsHelper
end