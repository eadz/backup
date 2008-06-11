Gem::Specification.new do |s|
  s.name = "backup"
  s.version = "0.0.4"
  s.date = "2008-06-11"
  s.summary = "A library that allows you to backup a file from within your own code."
  s.email = "jvandyke@engineyard.com"
  s.homepage = "http://github.com/engineyard/backup"
  s.description = "Backup is a Ruby library to ease the backup of files, keeping the latest X releases.  Just require it and go."
  s.has_rdoc = true
  s.authors = ["Jamie van Dyke", "Edward Muller"]
  s.files = %w[History.txt LICENSE Manifest.txt README.txt Rakefile lib/backup.rb lib/backup/backup.rb spec/backup/backup_spec.rb spec/spec.opts spec/spec_helper.rb tasks/ann.rake tasks/bones.rake tasks/gem.rake tasks/manifest.rake tasks/notes.rake tasks/post_load.rake tasks/rdoc.rake tasks/rubyforge.rake tasks/setup.rb tasks/spec.rake tasks/svn.rake tasks/test.rake]
  s.test_files = ["spec/backup/backup_spec.rb"]
  s.rdoc_options = ["--main", "README.txt"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
end