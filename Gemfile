source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.6.1'

# infrastructure
gem 'sqlite3'
gem 'puma', '~> 4.3'

# frameworks
gem 'devise'
gem 'granite'
gem 'uuidtools'

# front
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

# api
gem 'jbuilder', '~> 2.5'

group :development, :test do
  # debugging
  gem 'pry-rails'
  gem 'pry-stack_explorer'

  # testing
  gem 'rspec-rails', '~> 3.7'
end

group :test do
  gem 'simplecov', :require => false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end
