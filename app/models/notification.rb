# == Schema information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  recipient_type  :string(255)      not null
#  recipient_id    :bigint           not null
#  type            :string(255)      not null
#  params          :jsonb
#  read_at         :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_notifications_on_read_at          (read_at)
#  index_notifications_on_recipient        (recipient_type,recipient_id)
#

class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true
end
