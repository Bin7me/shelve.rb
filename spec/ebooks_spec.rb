#!/bin/env ruby

require_relative '../ebooks.rb'

describe EbookReader, "authors_names" do
  before do
    EbookReader.connect
  end

  it "should return an array of author names" do
    names = EbookReader.author_names

    expect(names).to be_a_kind_of(Array)
  end
end

describe EbookReader, "book_titles" do
  before do
    EbookReader.connect
  end

  it "should return an array of book titles" do
    titles = EbookReader.book_titles

    expect(titles).to be_a_kind_of(Array)
  end
end
