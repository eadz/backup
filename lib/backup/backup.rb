module EngineYard
  class Backup
    include FileUtils
        
    attr_reader :filename, :backups
    
    VERSION   = "0.0.1"

    RELEASES  = 5
    TIMESTAMP = "%Y%m%d%H%M%S"
    
    def initialize(file)
      raise "No such file found" unless File.file?(file)
      @filename, @backups = file, []
    end
    
    def run
      backup_current
      delete_old_backups
    end
    
    def backup_current
      FileUtils.mv(@filename, "#{@filename}.#{Time.now.strftime(TIMESTAMP)}")
    end
    
    # Look for releases and delete the oldest ones outside of our RELEASES threshold
    def delete_old_backups
      find_all_releases
      delete_list = @backups - keep_list
      delete_list.each {|f| File.delete(f) }
    end
    
    def keep_list
      @backups[-RELEASES..-1]
    end

    # Find all versions of our backup filename, which match file.TIMESTAMP
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