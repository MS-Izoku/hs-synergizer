# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  # need to handle error validation for this end
  PASSWORD_REQUIREMENTS = /\A
  (?=.{8,50}) # length-check , might be unrealistically long
  (?=.*\d) # digit-check
  (?=.*[a-z]) # lower-case check
  (?=.*[A-Z]) # capital check
  (?=.[[:^alnum:]]) # symbol check
  /x.freeze

  def get_password_error # WIP, needs to take specific error into account for string parsing
    'Password must be between 8-50 characters and contain at least 1 number, 1 upper-case letter, 1 lower-case letter, and 1 special character'
  end

  validates_format_of :email, with: Devise.email_regexp, uniqueness: { message: 'Email already exists, did you forget your password?' }
  validates :username, uniqueness: { case_sensative: false , message: 'Username already taken, please try again' }, length: { in: 6..20, message: 'Username must be between 6 and 20 characters' }
  validates :password, format: PASSWORD_REQUIREMENTS
end