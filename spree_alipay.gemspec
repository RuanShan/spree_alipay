# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_alipay'
  s.version     = '3.0.0'
  s.summary     = 'integrate china payment with spree'
  s.description = 'integrate china payment with spree, like alipay,tenpay'
  s.required_ruby_version = '>= 2.0.0'

  s.author            = 'qinghe'
  s.email             = 'areq22@aliyun.com'
  s.homepage          = 'http://www.github.com/RuanShan/spree_alipay'

  #s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 3.0.0'
  s.add_dependency 'alipay', '~> 0.7.0'

  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.1'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
# s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'poltergeist', '~> 1.6.0'
end
