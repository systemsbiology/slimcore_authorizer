# Transfer users, lab groups and lab memberships between in-house db and SLIMcore
namespace :db do
  namespace :migrate do

    desc "Transfer users, lab groups and lab memberships from in-house database to SLIMcore"
    task :slimcore => :environment do
      # custom model declarations here to prevent namespace conflicts
      class CoreUser < ActiveResource::Base
        self.site = APP_CONFIG['slimcore_site']
        self.element_name = "user"
        self.user = APP_CONFIG['slimcore_user']
        self.password = APP_CONFIG['slimcore_password'] 
      end

      class CoreLabGroup < ActiveResource::Base
        self.site = APP_CONFIG['slimcore_site'] 
        self.element_name = "lab_group"
        self.user = APP_CONFIG['slimcore_user']
        self.password = APP_CONFIG['slimcore_password'] 
      end

      class CoreLabMembership < ActiveResource::Base
        self.site = APP_CONFIG['slimcore_site'] 
        self.element_name = "lab_membership"
        self.user = APP_CONFIG['slimcore_user']
        self.password = APP_CONFIG['slimcore_password'] 
      end

      class SoloUser < ActiveRecord::Base
        set_table_name "users"
      end

      class SoloLabGroup < ActiveRecord::Base
        set_table_name "lab_groups"
      end

      class SoloLabMembership < ActiveRecord::Base
        set_table_name "lab_memberships"
      end


      SoloUser.find(:all).each do |u|
        CoreUser.create(:login => u.login, :firstname => u.firstname, :lastname => u.lastname,
                        :email => u.email)
      end

      SoloLabGroup.find(:all).each do |lg|
        CoreLabGroup.create(:name => lg.name)
      end

      SoloLabMembership.find(:all).each do |lm|
        CoreLabMembership.create(:user_id => lm.user_id, :lab_group_id => lm.lab_group_id)
      end
    end

  end
end
