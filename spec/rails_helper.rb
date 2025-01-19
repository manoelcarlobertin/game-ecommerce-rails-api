# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'rspec/rails'
ENV['RAILS_ENV'] ||= 'test'
Rails.application.config.active_support.deprecation = :silence

# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }
Dir[Rails.root.join('spec', 'shared_examples', '**', '*.rb')].each { |f| require f }
# rails_helper.rb
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Carrega automaticamente arquivos em spec/support e subdiretórios
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods

  config.alias_it_behaves_like_to :it_has_behavior_of, 'has behavior of'
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
