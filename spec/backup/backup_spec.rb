# $Id$

require File.join(File.dirname(__FILE__), %w[ .. spec_helper ])
require File.join(File.dirname(__FILE__), %w[ backup_helper ])
require 'lib/backup.rb'

include EngineYard

describe Backup do
  include BackupHelper
  
  describe "when initialized" do
    it "should take 1 argument of a filename" do
      lambda { Backup.new }.should raise_error( ArgumentError )
      lambda { Backup.new( "something" ) }.should raise_error( Errno::ENOENT )
      File.expects( :file? ).returns( true )
      lambda { Backup.new( "something" ) }.should_not raise_error
    end
    
    describe "and passed a valid filename" do
      before( :each ) do
        File.expects( :file? ).at_least_once.returns( true )
        Dir.stubs( :glob ).returns( valid_backups )
        @backup = Backup.new( "ey_my.cnf" )
      end
      
      it "should save a new file and delete all backups out of the threshold" do
        FileUtils.expects( :mv ).times( 0 )
        FileUtils.expects( :cp ).times( 1 )
        valid_backups( 9, :chronological ).last( 4 ).each do |backup|
          File.expects( :delete ).with( backup ).returns( 1 )
        end
        @backup.run
      end
      
      it "should not raise errors with zero current backups" do
        FileUtils.expects( :mv ).times( 0 )
        FileUtils.expects( :cp ).times( 1 )
        Dir.stubs( :glob ).returns( [] )
        File.expects( :delete ).times( 0 ).returns( 1 )
        @backup.run
      end
    
      describe "which returns a valid glob of files" do
        before( :each ) do
          Dir.stubs(:glob).returns( valid_backups )
          @backup = Backup.new( "ey_my.cnf" )
          @backup.find_all_releases
        end
      
        it "should sort them into chronological order" do
          @backup.backups.should == valid_backups( 9, :chronological )
        end
              
        it "should keep the 5 newest releases when creating a new backup" do
          @backup.keep_list.should == valid_backups( 5, :chronological )
        end
        
        it "should keep the 3 newest releases when creating a new backup that has releases set to 3" do
          @backup.releases = 3
          @backup == valid_backups( 3, :chronological )
        end
        
        it "should keep the 4 newest releases when creating a new backup that has a releases parameter of 4" do
          backup = Backup.new( "ey_my.cnf", 4 )
          backup.find_all_releases
          backup.keep_list.should == valid_backups( 4, :chronological )
        end
        
        it "should by default, copy the file not move" do
          FileUtils.expects( :mv ).times( 0 )
          FileUtils.expects( :cp ).times( 1 )
          File.expects( :delete ).times( 4 )
          @backup.run
        end
        
        it "should delete the original file if told to move instead of copy" do
          FileUtils.expects( :mv ).times( 1 )
          FileUtils.expects( :cp ).times( 0 )
          File.expects( :delete ).times( 4 )
          @backup.run( :move )
        end
      end
      
      describe "which returns an invalid glob of files" do
        it "should handle incorrectly named files gracefully" do
          Dir.stubs( :glob ).returns( invalid_backups( 3 ) )
          lambda { Backup.new( "ey_my.cnf" ) }.should_not raise_error( ArgumentError )
        end
      end
      
    end
    
  end
  
end

# EOF
