class Competition < ApplicationRecord
  belongs_to :show
  has_many :entries
end
