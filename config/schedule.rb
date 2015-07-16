
every 1.day, :at => '9:00 pm' do
  command "backup perform --trigger prod_backup"
end
