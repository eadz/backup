module EngineYard
  class Backup
    include FileUtils
        
    attr_reader :filename, :backups
    attr_accessor :releases
    
    VERSION   = "0.0.3"
    TIMESTAMP = "%Y%m%d%H%M%S"
    
    # Pass in a filename, Backup will set the directory it works in from this file
    #   # default to keeping 5 releases
    #   Backup.new("/my/file")
    #   # adjust the class to keep 3 releases
    #   Backup.new("/my/file", 3)
    def initialize(file, releases = 5)
      raise Errno::ENOENT, "#{file}", caller unless File.file?(file)
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
      delete_list.each {|f| File.delete(f) }
    end
    
    # Returns an array of files that will be kept
    def keep_list
      @backups.first(@releases)
    end
    
    # Returns an array of files that will be deleted
    def delete_list
      @backups - keep_list
    end

    # Returns all versions of our backup filename that match file.TIMESTAMP
    # Optional return format (:datetime)
    def find_all_releases(format = :filename)
      Dir.chdir(File.dirname(@filename))
      backups = Dir.glob("#{File.basename(@filename)}.*")
      remove_faults(backups)
      backups.sort! { |x,y| date_from(y.split(".").last) <=> date_from(x.split(".").last) }
      @backups = backups
      case format
      when :datetime
        @backups.collect { |b| d = date_from(b.split(".").last); d.strftime("%Y/%m/%d %H:%M:%S") }
      when :filename
        backups
      end
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
    
    def date_from(string)
      DateTime.strptime(string, TIMESTAMP)
    end
        
  end
end