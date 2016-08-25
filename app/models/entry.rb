class Entry < ApplicationRecord
  belongs_to :competition
  belongs_to :rider, class_name: 'Person'
  belongs_to :horse
end
