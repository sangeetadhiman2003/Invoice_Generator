class Product < ApplicationRecord

  include ActiveModel::Serializers::JSON

  has_many :items, dependent: :destroy
end
