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
        # regex: lines that satisfy the following conditions:
        # 1. can start with a white space
        # 2. start with 2 hashtags
        if (line[/^\s*##.*/])
          # remove trailing and leading white space and add to array
          puts lines_with_doc.push(line.strip)
        end
      end
    end

    return lines_with_doc
  end
  ##############################################################################
  ### detect lit doc code and process it
  ### lit code syntax:
  ## @h: header text
  ## @r: http method route
  ## @b: dictionary
  ## @b-model: path to model
  ## @res: dictionary
  ## @res-serializer: path to serializer
  ## @res-model: path to model
  ## regular markdown
  def process_lines(lines, generated_file_path)
    lines.each do |line|
      args = line.split(' ')
      case args[1]
      when "@h:"
        puts "this is a header"
        # remove first 2 entries in array
        args.shift(2)
        process_header(args, generated_file_path)
      when "@b:"
        puts "this is a body"
        # remove first 2 entries in array
        args.shift(2)
        process_body(args, generated_file_path)
      when "@res:"
        puts "this is a response"
        # remove first 2 entries in array
        args.shift(2)
        process_response(args, generated_file_path)
      else
        puts "this is regular markdown"
        # remove first entry in array
        args.shift
        process_markdown(args, generated_file_path)
      end
    end
  end

  private
    ############################################################################
    #### FORMAT:
    # TODO user passes size of headers(number of # to print) when importing
    #
    def process_header(args, file_path)
      puts "args: #{args}"
      args = args.join ' '
      File.open(file_path, "a") do |f|
        f << "#### #{args}"
      end
    end

    def process_body(args, file_path)
      puts "args: #{args}"
    end

    def process_response(args, file_path)
      puts "args: #{args}"
    end

    def process_markdown(args, file_path)
    end
end
