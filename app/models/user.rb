class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, presence: true, uniqueness: true, format: { with: /\A\+?[0-9]{10,15}\z/, message: "must be a valid phone number" }

  # Generates a 6-digit code, stores it, and logs it (simulates SMS send)
  def send_phone_verification_code!
    code = rand(100_000..999_999).to_s
    update!(phone_verification_code: code, phone_verification_sent_at: Time.current)
    Rails.logger.info "[SMS] Verification code for #{phone_number}: #{code}"
  end

  # Checks if the code is valid and not expired (10 min expiry)
  def verify_phone_code(submitted_code)
    return false if phone_verification_code.blank? || phone_verification_sent_at.blank?
    return false if phone_verification_sent_at < 10.minutes.ago
    if ActiveSupport::SecurityUtils.secure_compare(phone_verification_code, submitted_code)
      update!(phone_verified: true, phone_verification_code: nil, phone_verification_sent_at: nil)
      true
    else
      false
    end
  end

  # Rate limiting: allow sending a new code only every 60 seconds
  def can_resend_verification_code?
    phone_verification_sent_at.nil? || phone_verification_sent_at < 1.minute.ago
  end
end
