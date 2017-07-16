# should be at root of rails app for this to work
namespace :lit_doc do

  directory "doc"
  directory "doc/gen" => "doc"
  directory "doc/source" => "doc"
  file "doc/source/source.md" => ["doc/source", "doc/gen"] do
    touch "doc/source/source.md"
  end

  task :generate => "doc/source/source.md" do
    puts "Reading list of files to scan:"
    # src_files = Dir.glob("*")
    src_files = Dir.glob("app/controllers/*")
    puts "#{src_files}"

    File.open("doc/source/source.md", "r") do |f|
      f.each_line do |line|
        line.lstrip!
        args = line.split(' ')
        if args[0] == "import"
          scan_file(args[1])
        end
      end
    end
  end

  def scan_file(path)
    File.open(path, "r") do |f|
      ##
      ## TODO here is where all the mojo should be
      ## use syntax and keywords the will make generating docs easier and faster
      ##
    end
  end

end
