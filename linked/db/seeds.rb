# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

if Admin.count < 1
  adm = Admin.create(
    :login => "admin",
    :password => "1234",
    :password_confirm => "1234"
  )
end

if Resort.count < 1
  [
    { :name => "highone", :display_name => "하이원" },
    { :name => "yongpyong", :display_name => "용평" },
    { :name => "bokwang", :display_name => "보광 휘닉스" },
    { :name => "daemyung", :display_name => "대명 비발디" },
    { :name => "sungwoo", :display_name => "현대 성우" },
    { :name => "jisan", :display_name => "지산" }
  ].each do |resort_params|
    Resort.create(resort_params)
  end
end
