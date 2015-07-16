
every 1.day, :at => '9:00 pm' do
  command "cd /home/deploy/backup_app && backup perform --trigger prod_backup"
end
