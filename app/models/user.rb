class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
  /x.freeze

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  validates :email,
            presence: true,
            format: { with: VALID_EMAIL_REGEX },
            on: :create

  validates :email,
            allow_nil: true,
            format: { with: VALID_EMAIL_REGEX },
            on: :update

  validates :password,
            presence: true,
            length: { in: Devise.password_length },
            format: { with: PASSWORD_FORMAT },
            confirmation: true,
            on: :create

  validates :password,
            allow_nil: true,
            length: { in: Devise.password_length },
            format: { with: PASSWORD_FORMAT },
            confirmation: true,
            on: :update

  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  def update_if_user_info_changed(resource, params)
    resource.update!(params) if resource[:email] != params[:email] || !resource.valid_password?(params[:password])
  end
end
