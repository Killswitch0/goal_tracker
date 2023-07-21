FactoryBot.define do
  factory :group do
      sequence(:name) { |n| "Group #{n}" }
      user_id { FactoryBot.create(:user).id } # Используем фабрику для создания объекта User и берем его идентификатор

      # Дополнительные атрибуты и связи, если они присутствуют в вашей модели
    end
end
