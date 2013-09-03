#!/bin/env ruby

module MusicReader
  MUSICDIR = "music"

  def self.all_artists()
    artists = Dir["#{MUSICDIR}/*"]
    artists.map{ |artist| artist.gsub!("#{MUSICDIR}/", '') }
    artists.sort!
  end

  def self.artist_albums(artist_name)
    albums = Dir["#{MUSICDIR}/#{artist_name}/*"]
  end
end
