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
    src_files = Dir.glob("*")
    puts "#{src_files}"
  end
end
