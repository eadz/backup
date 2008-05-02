module EngineYard
  class Backup
    include FileUtils
        
    attr_reader :filename, :backups
    attr_accessor :releases
    
    VERSION   = "0.0.1"
    TIMESTAMP = "%Y%m%d%H%M%S"
    
    # Pass in a filename, Backup will set the directory it works in from this file
    #   # default to keeping 5 releases
    #   Backup.new("/my/file")
    #   # adjust the class to keep 3 releases
    #   Backup.new("/my/file", 3)
    def initialize(file, releases = 5)
      raise "No such file found" unless File.file?(file)
      @filename, @backups = file, []
      @releases = releases
    end
    
    # Backup the current file, and keep X number of older versions
    def run
      backup_current
      delete_old_backups
    end
    
    # Backup the current file only
    def backup_current
      FileUtils.mv(@filename, "#{@filename}.#{Time.now.strftime(TIMESTAMP)}")
    end
    
    # Look for releases and delete the oldest ones outside of the X releases threshold
    def delete_old_backups
      find_all_releases
      delete_list = @backups - keep_list
      delete_list.each {|f| File.delete(f) }
    end
    
    # Returns the list of files that will be kept
    def keep_list
      @backups.empty? ? [] : @backups[-@releases..-1]
    end

    # Returns all versions of our backup filename, which match file.TIMESTAMP
    def find_all_releases
      Dir.chdir(File.dirname(@filename))
      backups = Dir.glob("#{File.basename(@filename)}.*")
      remove_faults(backups)
      backups.sort! do |x,y| 
        Date.strptime(x.split(".").last, TIMESTAMP) <=> Date.strptime(y.split(".").last, TIMESTAMP)
      end
      @backups = backups
    end

  private    

    def remove_faults(backups)
      backups.each do |backup|
        begin
          Date.strptime(backup.split(".").last, TIMESTAMP)
        rescue ArgumentError
          backups.delete(backup)
        end
      end
      backups
    end
        
  end
end