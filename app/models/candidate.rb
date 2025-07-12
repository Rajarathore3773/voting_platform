class Candidate < ApplicationRecord
  belongs_to :election
  validates :name, presence: true
end
