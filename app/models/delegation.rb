class Delegation < ApplicationRecord
  belongs_to :election
  belongs_to :delegator, class_name: 'User'
  belongs_to :delegate, class_name: 'User'

  validate :cannot_delegate_to_self

  def cannot_delegate_to_self
    errors.add(:delegate, "can't be yourself") if delegator_id == delegate_id
  end
end
