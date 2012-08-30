# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# notice loading order,  site, default data, user


#load self default
default_path = File.join(File.dirname(__FILE__), 'default')
Rake::Task['db:load_dir'].reenable
Rake::Task['db:load_dir'].invoke(default_path)