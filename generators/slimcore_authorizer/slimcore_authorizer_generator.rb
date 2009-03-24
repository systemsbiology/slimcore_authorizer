class SlimcoreAuthorizerGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # models
      m.directory "app/models"
      m.file 'user_profile.rb', "app/models/user_profile.rb"
      m.file 'lab_group_profile.rb', "app/models/lab_group_profile.rb"

      # configuration/initializers
      m.file "application.yml", "config/application.yml"
      m.file "1-load_application_config.rb", "config/initializers/1-load_application_config.rb"
      m.file "cas_server.rb", "config/initializers/cas_server.rb"

      # migration
      m.migration_template 'migration.rb',"db/migrate", :migration_file_name => "add_slimcore_authorizer"
      
      # specs
      m.directory "spec/models"
      m.file "user_profile_spec.rb", "spec/models/user_profile_spec.rb"
      m.file "lab_group_profile_spec.rb", "spec/models/lab_group_profile_spec.rb"

      # views
      m.directory "app/views/user_profiles"
      m.directory "app/views/lab_group_profiles"
      m.file "user_profiles/_form.html.erb", "app/views/user_profiles/_form.html.erb"
      m.file "lab_group_profiles/_form.html.erb", "app/views/lab_group_profiles/_form.html.erb"
    end
  end
end
