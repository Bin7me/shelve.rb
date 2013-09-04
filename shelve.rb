#!/bin/env ruby

require 'sinatra'
require_relative 'ebooks.rb'
require_relative 'music.rb'

before do
  EbookReader.connect
end

get '/' do
  erb :index
end

get '/books' do
  @books= EbookReader.all_books
  erb :books
end

get '/authors' do
  @authors = EbookReader.all_authors
  erb :authors
end

get '/author/:id' do
  @author = EbookReader.author(params[:id])
  @books = []

  @author[:books].each do |book_id|
    @books << EbookReader.book(book_id)
  end

  erb :author
end

get '/book/:id' do
  @book = EbookReader.book(params[:id])
  @authors = []

  @book[:authors].each do |author_id|
    @authors << EbookReader.author(author_id)
  end

  erb :book
end

get '/artists' do
  @artists = MusicReader.artist_names()
  erb :artists
end

get '/artist/:name' do
  @artist = MusicReader.artist(params[:name])
  erb :artist
end

get '/albums' do
  @albums = MusicReader.all_albums
  erb :albums
end
