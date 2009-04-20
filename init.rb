# Reload models and controllers on every request in development, to prevent association issues
ActiveSupport::Dependencies.load_once_paths.delete(File.expand_path(File.dirname(__FILE__))+'/app/models')
ActiveSupport::Dependencies.load_once_paths.delete(File.expand_path(File.dirname(__FILE__))+'/app/controllers')

# Provide a convenient way for parent app to determine which authorizer 
# engine is being used
AUTHORIZER = 'slimcore'
