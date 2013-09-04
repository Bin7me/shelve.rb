#!/bin/env ruby

require 'sqlite3'
require 'nokogiri'

module EbookReader

  class << self
    attr_accessor :ebookdb
    attr_reader :EBOOKDIR
  end

  @EBOOKDIR = "public/ebooks"
  @ebookdb = "#{self.EBOOKDIR}/metadata.db"

  def self.connect()
    @db ||= SQLite3::Database.open(@ebookdb);
  end

  def self.execute(statement)
    @db.execute statement
  end

  def self.author(author_id) 
    author_result = execute("SELECT id, name, sort FROM authors WHERE id = #{author_id} LIMIT 1").flatten

    books_result = execute("SELECT book FROM books_authors_link WHERE author = #{author_id} ORDER BY book").flatten

    author = Author.new
    author.id = author_result[0]
    author.name = author_result[1]
    author.sort = author_result[2]
    author.books = books_result

    author
  end

  def self.all_authors()
    result = execute("SELECT id FROM authors ORDER BY sort").flatten
    authors = []

    result.each do |id|
      authors << author(id)
    end

    authors
  end

  def self.book(book_id)
    book_result = execute("SELECT id, title, sort, path FROM books WHERE id = #{book_id} LIMIT 1").flatten

    authors_result = execute("SELECT author FROM books_authors_link WHERE book = #{book_id} ORDER BY author").flatten

    description = execute("SELECT text FROM comments WHERE book = #{book_id}").flatten[0]

    primary_author = author(authors_result[0]).name

    book = Book.new
    book.id = book_result[0]
    book.title = book_result[1]
    book.sort = book_result[2]
    book.authors = authors_result
    book.description = Nokogiri::HTML(description).inner_text
    book.relative_path = book_result[3]

    book
  end

  def self.all_books()
    result = execute("SELECT id FROM books ORDER BY sort").flatten
    books= []

    result.each do |id|
      books << book(id)
    end

    books
  end

end

class Book
  attr_accessor :id, :title, :sort, :authors, :description, :relative_path

  EBOOK_REGEX = /.epub\z|.mobi\z|.pdf\z/i
  COVER_REGEX = /.jpg\z|.png\z|.gif\z/i

  def path
    path = "#{EbookReader.EBOOKDIR}/#{relative_path}"
    ebook = Dir.glob("#{path}/*").select{ |f| f =~ EBOOK_REGEX }
    ebook.first.gsub('public/', '')
  end

  def cover
    path = "#{EbookReader.EBOOKDIR}/#{relative_path}"
    cover = Dir.glob("#{path}/*").select{ |f| f=~ COVER_REGEX }
    cover.first.gsub('public/', '')
  end
end

class Author
  attr_accessor :id, :name, :sort, :books
end
