class Show < ApplicationRecord
  belongs_to :organizer
  has_many :competitions
  has_many :entries, through: :competitions
  has_many :people, through: :entries, source: :rider
  has_many :horses, through: :entries
  has_many :clubs, through: :people
end
