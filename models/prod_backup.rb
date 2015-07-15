require 'yaml'
SERVERS = YAML.load(File.read(File.expand_path('../../lib/servers.yml', __FILE__)))
Backup::Model.new(:prod_backup, 'Production daily database backups') do
  split_into_chunks_of 250

  SERVERS.each do |key, value|
    #puts "creating backup for #{key}"

    Logger.configure do
      logfile.enabled   = true
      logfile.log_path  = "~/test/log/#{key}"
      logfile.max_bytes = 500_000
    end


    begin
      database PostgreSQL, "#{key}" do |db|
        db.name               = "deploy"
        db.username           = "deploy"
        db.password           = "34qn23mn1"
        db.host               = value
        db.port               = 5432
      end
    rescue Model::Error => e
      e.to_s
    end

    compress_with Gzip do |compression|
        compression.level = 9
    end

    store_with SCP, key do |server|
      server.username = 'colton'
      server.password = 'cookie2546'
      server.ip       = '25.134.149.106'
      server.port     = 22
      server.path     = "~/backups/#{key}"
      server.keep     = 5
    end

  end

  emails = ['coltonsealtt@gmail.com']#,'moeed@streetcredsoftware.com','james.jelinek@streetcredsoftware.com','suraj.munta@streetcredsoftware.com']

  notify_by Mail do |mail|
    mail.on_success           = true
    mail.on_warning           = true
    mail.on_failure           = true

    mail.from                 = 'colton.seal@streetcredsoftware.com'
    mail.to                   = emails
    mail.address              = 'smtp.gmail.com'
    mail.port                 = 587
    mail.domain               = 'mail.google.com'
    mail.user_name            = 'colton.seal@streetcredsoftware.com'
    mail.password             = 'Phi2546Delt12'
    mail.authentication       = 'plain'
    mail.encryption           = :starttls
  end

end
