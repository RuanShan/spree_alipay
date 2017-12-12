require 'ffaker'

namespace :spree_alipay do
  desc 'Loads extra payment method'
  task :load do
    #Spree::Core::Fixtures.reset_cache # some_table.yml maybe cached
    Rake::Task["spree_sample:load"].invoke    
    Rake::Task['spree_theme:load_seed'].invoke
  end
end


#Rake::Task['spree_sample:load'].enhance do
#  Rake::Task['spree_aplipay:load_extra_payment_method'].invoke
#end
