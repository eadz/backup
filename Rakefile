require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'
require 'spec/rake/spectask'
require 'lib/backup.rb'

GEM = "backup"
GEM_VERSION = EngineYard::Backup::VERSION
AUTHOR = "Engine Yard Development Team"
EMAIL = "dev@engineyard.com"
HOMEPAGE = "http://labs.engineyard.com"
SUMMARY = "A class that can keep X number of backups of a file"

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  
  # Uncomment this to add a dependency
  # s.add_dependency "foo"
  
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,specs}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc 'Run all specs with basic output'
Spec::Rake::SpecTask.new(:spec) do |t|
# t.ruby_opts = '-w'
  t.spec_opts = []
  t.spec_files = FileList['spec/**/*_spec.rb']
end

task :default => :spec
