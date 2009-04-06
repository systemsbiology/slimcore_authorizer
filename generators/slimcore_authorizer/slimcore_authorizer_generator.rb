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

      # assets for tinytable JS sorting/pagination
      m.file "tinytable.css", "public/stylesheets/tinytable.css"
      m.file "tinytable-packed.js", "public/javascripts/tinytable-packed.js"
      m.file "asc.gif", "public/images/asc.gif"
      m.file "bg.gif", "public/images/bg.gif"
      m.file "desc.gif", "public/images/desc.gif"
      m.file "first.gif", "public/images/first.gif"
      m.file "header-bg.gif", "public/images/header-bg.gif"
      m.file "header-selected-bg.gif", "public/images/header-selected-bg.gif"
      m.file "last.gif", "public/images/last.gif"
      m.file "next.gif", "public/images/next.gif"
      m.file "previous.gif", "public/images/previous.gif"
      m.file "sort.gif", "public/images/sort.gif"
    end
  end
end
