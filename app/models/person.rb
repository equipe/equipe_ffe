class Person < ApplicationRecord
  belongs_to :club, optional: true
  belongs_to :region, optional: true
end
