# Load the rails application
require File.expand_path('../application', __FILE__)
Dir.glob(File.join(Rails.root.to_s, 'vendor', '*', 'lib')) do |path|
    $LOAD_PATH << path
 end
# Initialize the rails application
Site::Application.initialize!
