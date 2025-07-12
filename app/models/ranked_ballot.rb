class RankedBallot < ApplicationRecord
  belongs_to :user
  belongs_to :election
  validates :rankings, presence: true # rankings will be stored as a serialized array of candidate IDs

  serialize :rankings, coder: JSON
end
