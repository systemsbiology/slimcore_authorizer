class LabMembership < ActiveRecord::Base
  establish_connection "slimcore_#{Rails.env}"

  belongs_to :user
  belongs_to :lab_group
end
