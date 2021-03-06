require 'yaml'
SERVERS = YAML.load(File.read(File.expand_path('../lib/servers.yml', __FILE__)))
SECRETS = YAML.load(File.read(File.expand_path('../lib/secrets.yml', __FILE__)))
preconfigure 'MyModel' do
  split_into_chunks_of 250

  Logger.configure do
    logfile.enabled   = true
    logfile.log_path  = "log/#{Time.now}_backup_log"
    logfile.max_bytes = 500_000
  end

  compress_with Gzip do |compression|
      compression.level = 9
  end

  emails = ['coltonsealtt@gmail.com','moeed@streetcredsoftware.com','james.jelinek@streetcredsoftware.com','suraj.munta@streetcredsoftware.com']

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
    mail.password             = SECRETS['gmail_password']
    mail.authentication       = 'plain'
    mail.encryption           = :starttls
  end

end

Backup::Database::PostgreSQL.defaults do |db|
  db.name               = "streetcred_production"
  db.username           = "deploy"
  db.password           = "34qn23mn1"
  db.port               = 5432
  db.skip_tables        = ['change_log']
end

Backup::Storage::SCP.defaults do |s|
  s.username = 'deploy'
  s.password = SECRETS['bud_server_pw']
  s.ip       = '25.162.227.70'
  s.port     = 22
  s.keep     = 5
end

Utilities.configure do
  pg_dump     '/usr/pgsql-9.3/bin/pg_dump'
end


# encoding: utf-8

##
# Backup v4.x Configuration
#
# Documentation: http://backup.github.io/backup
# Issue Tracker: https://github.com/backup/backup/issues

##
# Config Options
#
# The options here may be overridden on the command line, but the result
# will depend on the use of --root-path on the command line.
#
# If --root-path is used on the command line, then all paths set here
# will be overridden. If a path (like --tmp-path) is not given along with
# --root-path, that path will use it's default location _relative to --root-path_.
#
# If --root-path is not used on the command line, a path option (like --tmp-path)
# given on the command line will override the tmp_path set here, but all other
# paths set here will be used.
#
# Note that relative paths given on the command line without --root-path
# are relative to the current directory. The root_path set here only applies
# to relative paths set here.
#
# ---
#
# Sets the root path for all relative paths, including default paths.
# May be an absolute path, or relative to the current working directory.
#
# root_path 'my/root'
#
# Sets the path where backups are processed until they're stored.
# This must have enough free space to hold apx. 2 backups.
# May be an absolute path, or relative to the current directory or +root_path+.
#
# tmp_path  'my/tmp'
#
# Sets the path where backup stores persistent information.
# When Backup's Cycler is used, small YAML files are stored here.
# May be an absolute path, or relative to the current directory or +root_path+.
#
# data_path 'my/data'

##
# Utilities
#
# If you need to use a utility other than the one Backup detects,
# or a utility can not be found in your $PATH.
#
#   Utilities.configure do
#     tar       '/usr/bin/gnutar'
#     redis_cli '/opt/redis/redis-cli'
#   end

##
# Logging
#
# Logging options may be set on the command line, but certain settings
# may only be configured here.
#
#   Logger.configure do
#     console.quiet     = true            # Same as command line: --quiet
#     logfile.max_bytes = 2_000_000       # Default: 500_000
#     syslog.enabled    = true            # Same as command line: --syslog
#     syslog.ident      = 'my_app_backup' # Default: 'backup'
#   end
#
# Command line options will override those set here.
# For example, the following would override the example settings above
# to disable syslog and enable console output.
#   backup perform --trigger my_backup --no-syslog --no-quiet

##
# Component Defaults
#
# Set default options to be applied to components in all models.
# Options set within a model will override those set here.
#
#   Storage::S3.defaults do |s3|
#     s3.access_key_id     = "my_access_key_id"
#     s3.secret_access_key = "my_secret_access_key"
#   end
#
#   Notifier::Mail.defaults do |mail|
#     mail.from                 = 'sender@email.com'
#     mail.to                   = 'receiver@email.com'
#     mail.address              = 'smtp.gmail.com'
#     mail.port                 = 587
#     mail.domain               = 'your.host.name'
#     mail.user_name            = 'sender@email.com'
#     mail.password             = 'my_password'
#     mail.authentication       = 'plain'
#     mail.encryption           = :starttls
#   end

##
# Preconfigured Models
#
# Create custom models with preconfigured components.
# Components added within the model definition will
# +add to+ the preconfigured components.
#
#   preconfigure 'MyModel' do
#     archive :user_pictures do |archive|
#       archive.add '~/pictures'
#     end
#
#     notify_by Mail do |mail|
#       mail.to = 'admin@email.com'
#     end
#   end
#
#   MyModel.new(:john_smith, 'John Smith Backup') do
#     archive :user_music do |archive|
#       archive.add '~/music'
#     end
#
#     notify_by Mail do |mail|
#       mail.to = 'john.smith@email.com'
#     end
#   end
