require 'ffaker'

namespace :spree_aplipay do
  desc 'Loads extra payment method'
  task :load_extra_payment_method do
    #Spree::Core::Fixtures.reset_cache # some_table.yml maybe cached
    sample_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'samples')

    Rake::Task['db:load_dir'].reenable
    Rake::Task['db:load_dir'].invoke(sample_path)
  end
end


Rake::Task['spree_sample:load'].enhance do
  Rake::Task['spree_aplipay:load_extra_payment_method'].invoke
end
