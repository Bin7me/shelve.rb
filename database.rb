#!/bin/env ruby

require 'sqlite3'
require_relative 'music.rb'

module ShelveBase

  def self.create_music_metadata_db(path)
    db = SQLite3::Database.open(path)
    db.execute "DROP TABLE IF EXISTS artists"
    db.execute "DROP TABLE IF EXISTS albums"
    db.execute "DROP TABLE IF EXISTS artists_albums_link"

    db.execute 'CREATE TABLE artists(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL DEFAULT "Various",
      path TEXT NOT NULL DEFAULT "")'

    db.execute "CREATE TABLE albums(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL DEFAULT 'Unknown Album',
      path TEXT NOT NULL DEFAULT '',
      artist INTEGER,
      FOREIGN KEY(artist) REFERENCES artists(id))"

    artist_names = list_subfolders MusicReader.MUSICDIR

    artist_names.each do |artist_name|
      albums = list_subfolders "#{MusicReader.MUSICDIR}/#{artist_name}"

      db.execute("INSERT INTO artists(name, path) VALUES(?, ?)", artist_name, "#{MusicReader.MUSICDIR}/#{artist_name}")

    end

  end

  def self.list_subfolders(path_to_folder)
    folders = Dir.glob("#{path_to_folder}/*").select {|f| File.directory? f}
    folders.map{ |folder| folder.gsub!("#{path_to_folder}/", '') }
    folders.sort
  end

end
