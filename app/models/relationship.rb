class Relationship < ApplicationRecord
  # Relationshipとfollowerは1対1の関係にある　クラスはUser
  belongs_to :follower, class_name: "User"
  # Relationshipとfollowedは1対1の関係にある　クラスはUser
  belongs_to :followed, class_name: "User"
  # follower_idが存在する
  validates :follower_id, presence: true
  # followed_idが存在する
  validates :followed_id, presence: true
end
