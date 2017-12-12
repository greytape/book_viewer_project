require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do 
  @contents = File.read('data/toc.txt').split(/\n/)
end

get "/" do
  @title = "The Adventures of Merlock Moans"
  erb :home
end

get "/chapters/:number" do
  @title = "Chapter #{params['number']}"
  @chapter_text = File.read("data/chp#{params['number']}.txt")
  @chapter_text = in_paragraphs(@chapter_text)
  erb :chapter
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end

not_found do 
  redirect "/"
end

helpers do 
  def in_paragraphs(text)
    text.split("\n\n").map.with_index do |paragraph, index|
      "<p id= \"#{index + 1}\">#{paragraph}</p>"
    end.join
  end

  def each_chapter(&block)
    @contents.each_with_index do |name, index|
      number = index + 1
      contents = File.read("data/chp#{number}.txt")
      yield number, name, contents
    end
  end

  def chapters_matching(query)
    results = []

    return results if !query || query.empty?

    each_chapter do |number, name, contents|
      if contents.include?(query)
        contents = contents.split(/\n\n/)
        matching_paras = []
        contents.each_with_index do |para, index|
          matching_paras << {index: index + 1, text: para} if para.include?(query) 
        end
        results << {number: number, name: name, paras: matching_paras} 
      end
    end

    results
  end

  def make_query_bold(text, query)
    text.gsub(query, "<strong>#{query}</strong>")
  end
end
