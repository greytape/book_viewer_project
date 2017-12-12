CHAPTER_NUMS = ["chp1.txt", "chp2.txt", "chp3.txt", "chp4.txt", "chp5.txt", "chp6.txt", "chp7.txt", "chp8.txt", "chp9.txt", "chp10.txt", "chp11.txt", "chp12.txt"]

CHAPTER_TITLES = File.read("data/toc.txt").split("\n")

CHAPTER_TITLES_NUMS = Hash[CHAPTER_NUMS.zip(CHAPTER_TITLES)]

search_string = "copper"
results_array = []
CHAPTER_TITLES_NUMS.each do |file_name, title|
  chapter_text = File.read("data/#{file_name}")
  if chapter_text =~ /#{search_string}/ 
    results_array << title
  end
end

results_array