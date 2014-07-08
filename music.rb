#!/bin/env ruby

module MusicReader
  @MUSICDIR = "public/music"
  MUSIC_REGEX = /.mp3\z|.ogg\z|.wav\z|.flac\z/i
  COVER_REGEX = /.jpg\z|.png\z|.gif\z/i

  class << self
    attr_reader :MUSICDIR
  end

  def self.all_artists()
    names = list_subfolders(self.MUSICDIR).sort
    artists = []

    names.each do |name|
      artist = Hash.new([])
      artist[:name] = name
      artist[:albums] = artist_albums name
      artist[:single_tracks] = artist_single_tracks name

      artists << artist
    end

    artists
  end

  def self.artist_names()
    list_subfolders self.MUSICDIR
  end

  def self.artist(name)
    artist = Hash.new([])
    artist[:name] = name
    artist[:albums] = artist_albums name
    artist[:single_tracks] = artist_single_tracks name

    artist
  end

  def self.all_albums()
    albums = []

    artist_names.each do |artist_name|
      album_names = artist_albums artist_name

      album_names.each do |album_name|
        album = Hash.new
        album[:artist] = artist_name
        album[:name] = album_name
        album[:tracks] = album_tracks(artist_name, album_name)
        album[:cover] = album_cover(artist_name, album_name)

        albums << album
      end
    end

    albums = albums.sort_by { |a| a[:name] }
  end

  def self.album(artist_name, album_name)
    album = Hash.new
    album[:artist] = artist_name
    album[:name] = album_name
    album[:tracks] = album_tracks(artist_name, album_name)
    album[:cover] = album_cover(artist_name, album_name)

    album
  end
  
  ##################
  # HELPER METHODS #
  ##################

  def self.artist_albums(artist_name)
    list_subfolders "#{self.MUSICDIR}/#{artist_name}"
  end

  def self.artist_single_tracks(artist_name)
    list_files_in_folder("#{self.MUSICDIR}/#{artist_name}").select { |track| track =~ MUSIC_REGEX }
  end

  def self.album_tracks(artist_name, album_name)
    list_files_in_folder("#{self.MUSICDIR}/#{artist_name}/#{album_name}").select { |track| track =~ MUSIC_REGEX }
  end

  def self.album_cover(artist_name, album_name)
    covers = list_files_in_folder("#{self.MUSICDIR}/#{artist_name}/#{album_name}").select { |f| f =~ COVER_REGEX }
    "#{self.MUSICDIR}/#{artist_name}/#{album_name}/#{covers.first}".gsub('public/', '')
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
