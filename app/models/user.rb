class User < ApplicationRecord
  #email属性を小文字に変換してメールアドレスの一意性を保証する
  before_save { email.downcase! }
  #name属性の存在性を検証する,50文字まで
  validates :name,  presence: true, length: { maximum: 50 }
  #メールフォーマットを正規表現で検証する
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  #email属性の存在性を検証する,255文字まで
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    #メールアドレスの大文字小文字を無視した一意性の検証
                    uniqueness: { case_sensitive: false }
  #セキュアなパスワードの実装
  has_secure_password
  #6文字分の空白スペースを入れても更新されないようにする
  validates :password, presence: true, length: { minimum: 6 }
end