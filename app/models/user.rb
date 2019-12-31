# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

    # need to handle error validation for this end, might do that on the front-end
    PASSWORD_REQUIREMENTS = /\A
    (?=.{8,50}) # length-check , might be unrealistically long
    (?=.*\d) # digit-check
    (?=.*[a-z]) # lower-case check
    (?=.*[A-Z]) # capital check
    (?=.[[:^alnum:]]) # symbol check
    /x.freeze

  validates_format_of :email, with: Devise.email_regexp
  validates :username, uniqueness: true, length: { in: 6..20 }
  validates :password, length: { in: 6..20 }, format: PASSWORD_REQUIREMENTS


end
