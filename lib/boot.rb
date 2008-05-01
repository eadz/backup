$:.unshift(File.dirname(__FILE__)) unless  
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))  

APP_ROOT = File.expand_path('../') unless defined?(APP_ROOT)

require 'date'
require 'fileutils'

require 'backup/backup.rb'