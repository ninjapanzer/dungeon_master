source 'https://rubygems.org'

gem 'haml',       '~> 4.0.3'

# Manage Sass and Compass extensions as Gems.
gem 'sass',           '~> 3.3.7'          # Sassy CSS
gem 'compass',        '~> 1.0.0.alpha.19' # Sass framework needed for glob extension
gem 'sass-globbing',  '~> 1.1.1'          # Globs in @imports
gem 'bourbon',        '~> 4.0.1'          # Sass mixins
gem 'neat',           '~> 1.6.0'          # Grid on top of bourbon
gem 'jacket',         '~> 1.0.0'          # Conditional styles from a single stylesheet

group :test do
  gem 'rspec',             '~> 2.14.1' # Integration tests
  gem 'ci_reporter_rspec', '~> 1.0.0' # JUnit reporting for RSpec + Jenkins
  gem 'capybara',          '~> 2.1.0' #Browser driver
  gem 'capybara-webkit',   '~> 1.1.1'  # Headless javascript-capable browser
  gem 'launchy',           '~> 2.3.0'  # save_and_open_page from capybara
  gem 'puffing-billy',     github: 'thinkthroughmath/puffing-billy', :require => 'billy' # Stubbing proxy server. Forked to handle //:0 URLs.
  gem 'pry'
end
