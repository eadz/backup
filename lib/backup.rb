$:.unshift(File.dirname(__FILE__)) unless  
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))  

APP_ROOT = File.expand_path('../') unless defined?(APP_ROOT)

require 'date'
require 'fileutils'
require 'highline/import'

require 'backup/backup.rb'

# Set debug options
debug = {
  "1" => "DEBUG",
  "2" => "STANDARD"
}
puts "DEBUG IS TURNED TO #{debug[ENV['DEBUG']]}" if ENV['DEBUG']
$debug = ENV['DEBUG']

# Debug command defined
def debug(text)
  say text if $debug
end

# Highline options
SEP = '='*72 unless defined? SEP
CLEAR = "\e[H\e[2J" unless defined? CLEAR
HighLine.track_eof = false # highline has an issue with threading
ft = HighLine::ColorScheme.new do |cs|
       cs[:headline]        = [ :bold, :yellow, :on_black ]
       cs[:horizontal_line] = [ :bold, :white ]
       cs[:even_row]        = [ :red ]
       cs[:odd_row]         = [ :yellow ]
       cs[:debug]           = [ :yellow ]
       cs[:warn]            = [ :cyan ]
       cs[:info]            = [ :white ]
       cs[:critical]        = [ :red ]
       cs[:pass]            = [ :green ]
       cs[:fail]            = [ :red ]
     end
HighLine.color_scheme = ft