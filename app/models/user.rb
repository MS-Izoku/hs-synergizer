# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates_format_of :email, with: Devise.email_regexp
  validates :username, uniqueness: true, length: { in: 6..20 }
  validates :password, legnth: { in: 6..20 }
  validate :validate_password_regex

  def validate_password_regex
    unless password.include?('special character') # regex to get special characters
      errors.add(:password, 'Password Needs at Least 1 special character')
    end
    unless password.include?('number') # regex to get digits
      errors.add(:password, 'Password needs to contain at least 1 number')
    end
    unless password.include?('capital_letter') # regex to get capital letters
      errors.add(:password, 'Password needs to contain at least 1 capital letter')
    end
    unless password.include?('lower_case_letter') # regex to get lower-case letters
      errors.add(:password, 'Password needs to contain at least 1 lower-case letter')
    end
  end
  
end
