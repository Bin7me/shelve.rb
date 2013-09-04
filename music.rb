#!/bin/env ruby

module MusicReader
  MUSICDIR = "music"
  MUSIC_REGEX = /.mp3\z|.ogg\z|.wav\z|.flac\z/i
  COVER_REGEX = /.jpg\z|.png\z|.gif\z/i

  def self.all_artists()
    list_subfolders MUSICDIR
  end

  def self.artist_albums(artist_name)
    list_subfolders "#{MUSICDIR}/#{artist_name}"
  end

  def self.artist_single_tracks(artist_name)
    list_files_in_folder("#{MUSICDIR}/#{artist_name}").select { |track| track =~ MUSIC_REGEX }
  end

  def self.album_tracks(artist_name, album_name)
    list_files_in_folder("#{MUSICDIR}/#{artist_name}/#{album_name}").select { |track| track =~ MUSIC_REGEX }
  end

  def self.album_cover(artist_name, album_name)
    covers = list_files_in_folder("#{MUSICDIR}/#{artist_name}/#{album_name}").select { |f| f =~ COVER_REGEX }
    covers.first
  end

  def self.list_subfolders(path_to_folder)
    folders = Dir.glob("#{path_to_folder}/*").select {|f| File.directory? f}
    folders.map{ |folder| folder.gsub!("#{path_to_folder}/", '') }
    folders.sort
  end

  def self.list_files_in_folder(path_to_folder)
    files = Dir.glob("#{path_to_folder}/*").select {|f| !File.directory? f}
    files.map{ |file| file.gsub!("#{path_to_folder}/", '') }
    files.sort
  end
end
