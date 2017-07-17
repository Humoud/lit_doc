module Scanner

  # return all files to be imported/scanned(files that contain lit doc)
  def read_source_file(file_path)
    import_file_paths = []

    File.open(file_path, "r").each_line do |line|
      line.lstrip!
      args = line.split(' ')
      puts "arguments in source.md: #{args}"
      if args[0] == "@import"
        import_file_paths.push(args[1].gsub('"', ''))
      end
    end

    return import_file_paths
  end

  # go through imported files and return lines that contain lit doc code
  def scan_file(file_paths)
    lines_with_doc = []

    file_paths.each do |path|
      File.open("#{Rails.root}/#{path}", "r").each_line do |line|
        ##
        ## TODO here is where all the mojo should be
        ## use syntax and keywords the will make generating docs easier and faster
        ##
        # regex: lines that satisfy the following conditions:
        # can start with a white space
        # start with 2 ##
        if (line[/^\s*##.*/])
          # remove trailing and leading white space and add to array
          puts lines_with_doc.push(line.strip)
        end
      end
    end

    return lines_with_doc
  end
end
