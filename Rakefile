# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

require 'lib/backup/backup.rb'
ENV['VERSION'] = EngineYard::Backup::VERSION
load 'tasks/setup.rb'

ensure_in_path 'lib'

task :default => 'spec:run'

PROJ.name = 'backup'
PROJ.authors = 'Jamie van Dyke'
PROJ.email = 'jvandyke@engineyard.com'
# PROJ.url = ''
# PROJ.rubyforge.name = 'backup'

PROJ.spec.opts << '--color'

# EOF
