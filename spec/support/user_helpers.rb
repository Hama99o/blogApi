require 'faker'
require 'factory_bot_rails'

module UserHelpers

  def create_user
    FactoryBot.create(:user,
            email: Faker::Internet.email,
            password: Faker::Internet.password(min_length: 10, max_length: 20, mix_case: true) 
        )
  end

    def build_user
    FactoryBot.build(:user,
            email: Faker::Internet.email,
            password: Faker::Internet.password(min_length: 10, max_length: 20, mix_case: true)
        )
  end

end
