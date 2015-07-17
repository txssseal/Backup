server = "gatesville"
MyModel.new(:prod_backup, "#{server.capitalize} production daily database backups") do

  database PostgreSQL do |db|
    db.host               = SERVERS["#{server}"]
  end

  store_with SCP, "#{server}" do |s|
    s.path     = "~/backups/#{server}"
  end

  sync_with RSync::Pull do |rsync|
    rsync.host = SERVERS["#{server}"]
    rsync.mode = :ssh
    rsync.ssh_user = "deploy"
    rsync.compress = true
    rsync.directories do |directory|
      directory.add "/var/www/vhosts/streetcred/shared/public/images/fugitive-images/*"
    end
    rsync.path = "~/backups/#{server}/fugitive-images-backup"
  end

end
