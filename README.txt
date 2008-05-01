backup
    by Jamie van Dyke - Engine Yard Inc.

== DESCRIPTION:

A library to keep the latest X number of a file as backups

== FEATURES/PROBLEMS:

FIXME: The spec for checking it backs up the latest X files, passes no matter what
FIXME: Make releases an instance variable, not a constant

== SYNOPSIS:

  # Take the file and create a timestamped version of it
  # Keeping only the latest X number of backups
  backup = Backup.new("/my/file")
  backup.run

== REQUIREMENTS:

None

== INSTALL:

RubyGems >= 1.1.1

  $ sudo gem sources -a http://gems.github.com/ (you only need to do this once)
  $ sudo gem install fearoffish-backup

RubyGems < 1.1.1

  $ sudo gem install fearoffish-backup --source=http://gems.github.com


== LICENSE:

(The GPL v.2 License)

Copyright (C) 2008  Engine Yard Inc.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
