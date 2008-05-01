# $Id$

require File.join(File.dirname(__FILE__), %w[.. spec_helper])
require 'lib/backup.rb'

include EngineYard

describe Backup do
  
  describe "when initialized" do
    it "should take 1 argument of a filename" do
      lambda { Backup.new }.should raise_error(ArgumentError)
      lambda { Backup.new("something") }.should raise_error("No such file found")
      File.should_receive(:file?).any_number_of_times.and_return(true)
      lambda { Backup.new("something") }.should_not raise_error
    end
    
    describe "and passed a valid filename" do
      before(:each) do
        File.should_receive(:file?).any_number_of_times.and_return(true)
        Dir.stub!(:glob).and_return(
          %w[ my.cnf.20050430185242 my.cnf.20080430185243 my.cnf.20080430185242 
              my.cnf.20060420185242 my.cnf.20070430185242 my.cnf.20060430185242
              my.cnf.20060410185242 my.cnf.20040430185242 my.cnf.20050430185242 ]
        )
        @backup = Backup.new("my.cnf")
      end
      
      it "should save a new file and delete all backups out of the threshold" do
        FileUtils.should_receive(:mv).exactly(1).times
        File.should_receive(:delete).with(/^my.cnf./).exactly(4).times.and_return(1)
        @backup.run
      end
    
      describe "which returns a valid glob of files" do
      
        before(:each) do
          Dir.stub!(:glob).and_return(
            %w[ my.cnf.20050430185242 my.cnf.20080430185243 my.cnf.20080430185242 
                my.cnf.20060420185242 my.cnf.20070430185242 my.cnf.20060430185242
                my.cnf.20060410185242 my.cnf.20040430185242 my.cnf.20050430185241 ]
          )
          @backup = Backup.new("my.cnf")
          @backup.find_all_releases
        end
      
        it "should sort them into chronological order" do
          @backup.backups.should eql(
            %w[ my.cnf.20080430185243 my.cnf.20080430185242 my.cnf.20070430185242
                my.cnf.20060430185242 my.cnf.20060420185242 my.cnf.20060410185242 
                my.cnf.20050430185241 my.cnf.20050430185242 my.cnf.20040430185242 ].reverse
          )
        end
      
        it "should keep the 5 newest releases when creating a new backup" do
          @backup.keep_list.should eql(
            %w[ my.cnf.20080430185243 my.cnf.20080430185242 my.cnf.20070430185242
                my.cnf.20060430185242 my.cnf.20060420185242 ].reverse
          )
        end
        
        it "should keep the 3 newest releases when creating a new backup that has releases set to 3" do
          @backup.releases = 3
          @backup.keep_list.should eql(
            %w[ my.cnf.20080430185243 my.cnf.20080430185242 my.cnf.20070430185242 ].reverse
          )
        end
        
        it "should keep the 4 newest releases when creating a new backup that has a releases parameter of 4" do
          backup = Backup.new("my.cnf", 4)
          backup.find_all_releases
          backup.keep_list.should eql(
            %w[ my.cnf.20080430185243 my.cnf.20080430185242 my.cnf.20070430185242 my.cnf.20060430185242 ].reverse
          )
        end
      
      end
      
      describe "which returns an invalid glob of files" do
      
        before(:each) do
          Dir.stub!(:glob).and_return(
            %w[ my.cnf.2005a85242 my.cnf.20080430185243 my.cnf.20080430185242 ]
          )
        end
      
        it "should handle incorrectly named files gracefully" do
          lambda { Backup.new("my.cnf") }.should_not raise_error(ArgumentError)
        end
      
      end
      
    end
    
  end
  
end

# EOF