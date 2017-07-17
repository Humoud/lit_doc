# should be at root of rails app for this to work
namespace :lit_doc do

  directory "doc"
  directory "doc/gen" => "doc"
  directory "doc/source" => "doc"
  file "doc/source/source.md" => ["doc/source", "doc/gen"] do
    touch "doc/source/source.md"
  end

  task :prepare => "doc/source/source.md"

  task :generate => :prepare do
    puts "Reading list of files to scan:"
    # src_files = Dir.glob("*")
    # src_files = Dir.glob("app/controllers/*")
    # puts "#{src_files}"

    File.open("doc/source/source.md", "r").each_line do |line|
      line.lstrip!
      args = line.split(' ')
      puts "arguments in source.md: #{args}"
      if args[0] == "@import"
        scan_file(args[1].gsub('"', ''))
      end
    end
  end

  def scan_file(path)
    File.open("#{Rails.root}/#{path}", "r").each_line do |line|
      ##
      ## TODO here is where all the mojo should be
      ## use syntax and keywords the will make generating docs easier and faster
      ##
      # regex: lines that satisfy the following conditions:
      # can start with a white space
      # start with 2 ##
      puts line if (line[/^\s*##.*/])
    end
  end

end
####################################################################
# end goal usage scenario:
# in source.md:
#
# have a mixture of markdown syntax and "@import 'rails.root/path_to_file'" statements
#
# in the imported file:
#
# above each action that the user wishes to document, he/she will use the following syntax
# it starts with 2 ## hashtags
## h: header text
## route: http method route
## body: dictionary
## body-model: path to model
## response: dictionary
## response-serializer: path to serializer
## response-model: path to model

# RegEx used to detect if this line is to be analyzed: /^\s*##.*/
