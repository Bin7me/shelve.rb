#!/bin/env ruby

require 'sqlite3'
require 'nokogiri'

module EbookReader

  EBOOKDIR = "ebooks"
  @ebookdb = "#{EBOOKDIR}/metadata.db"

  class << self
    attr_accessor :ebookdb
  end

  def self.connect()
    @db ||= SQLite3::Database.open(@ebookdb);
  end

  def self.execute(statement)
    @db.execute statement
  end

  def self.all_authors()
    result = execute "SELECT id, name, sort FROM authors ORDER BY sort"
    authors = []

    author_id_book_id = execute "SELECT author, book FROM books_authors_link ORDER BY author" 

    author_book_hash = Hash.new()

    author_id_book_id.each do |author_book|
      author_book_hash[author_book[0]] ||= []
      author_book_hash[author_book[0]] << author_book[1]
    end

    result.each do |entry|
      author = Hash.new
      author[:id] = entry[0]
      author[:name] = entry[1]
      author[:sort] = entry[2]
      author[:books] = author_book_hash[author[:id]]
      authors << author
    end

    authors
  end

  def self.author(author_id) 
    author_result = execute("SELECT id, name, sort FROM authors WHERE id = #{author_id} LIMIT 1").flatten

    books_result = execute("SELECT book FROM books_authors_link WHERE author = #{author_id} ORDER BY book").flatten

    author = Hash.new
    author[:id] = author_result[0]
    author[:name] = author_result[1]
    author[:sort] = author_result[2]
    author[:books] = books_result

    author
  end

  def self.all_books()
    result = execute "SELECT id, title, sort FROM books ORDER BY sort"
    books= []

    book_id_author_id = execute "SELECT book, author FROM books_authors_link ORDER BY book" 

    book_author_hash = Hash.new()

    book_id_author_id.each do |book_author|
      book_author_hash[book_author[0]] ||= []
      book_author_hash[book_author[0]] << book_author[1]
    end

    result.each do |entry|
      book = Hash.new
      book[:id] = entry[0]
      book[:title] = entry[1]
      book[:sort] = entry[2]
      book[:authors] = book_author_hash[book[:id]]
      books << book
    end

    books
  end

  def self.book(book_id)
    book_result = execute("SELECT id, title, sort FROM books WHERE id = #{book_id} LIMIT 1").flatten

    authors_result = execute("SELECT author FROM books_authors_link WHERE book = #{book_id} ORDER BY author").flatten

    description = execute("SELECT text FROM comments WHERE book = #{book_id}").flatten[0]

    book = Hash.new
    book[:id] = book_result[0]
    book[:title] = book_result[1]
    book[:sort] = book_result[2]
    book[:authors] = authors_result
    book[:description] = description

    book
  end

end
