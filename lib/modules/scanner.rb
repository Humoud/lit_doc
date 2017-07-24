module Scanner

  # return all files to be imported/scanned(files that contain lit doc)
  # and headers sizes for each file
  # returns array of hashes:
  # [ { file: "file_path", header_sizes: {h: integer} } ]
  def read_source_file(file_path)
    file_paths_and_header_sizes = []

    File.open(file_path, "r").each_line do |line|
      line.lstrip!
      args = line.split(' ')
      # puts "arguments in source.md: #{args}"
      if args[0] == "@import"
        # see if {h: 1} pattern exists
        header_sizes = line[/{\s*h:\s*[0-9]\s*}/]
        header_hash = Hash.new
        # if user passed sizes
        if header_sizes
          # convert str to ruby hash
          header_hash = eval header_sizes
        # set default size
        else
          header_hash = {h: 2}
        end
        file_path = args[1][/".*"/]

        hash = {file: file_path.gsub('"', ''), header_sizes: header_hash}
        file_paths_and_header_sizes.push(hash)
      end
    end

    return file_paths_and_header_sizes
  end

  # go through imported files and return lines that contain lit doc code
  # returns an array of hashes with the following format:
  # {
  #   file:
  #   {
  #       sizes: {h: integer},
  #       lines: ["line of lit doc code"]
  #   }
  # }
  def scan_file(file_paths_and_sizes, root_path=Rails.root)
    lines_and_header_sizes = []

    file_paths_and_sizes.each do |path_and_size|
      lines_with_doc = []
      
      File.open("#{root_path}/#{path_and_size[:file]}", "r").each_line do |line|
        # regex: lines that satisfy the following conditions:
        # 1. can start with a white space
        # 2. start with 2 hashtags
        if (line[/^\s*##.*/])
          # remove trailing and leading white space and add to array
          lines_with_doc.push(line.strip)
        end
      end

      lines_and_header_sizes.push(
        {
          file:
          {
              sizes: path_and_size[:header_sizes],
              lines: lines_with_doc
          }
        }
      )
    end

    return lines_and_header_sizes
  end
  ##############################################################################
  ### detect lit doc code and process it
  ### lit code syntax:
  ## @h: header text
  ## @r: http method route
  ## @b-model: path to model
  ## @b-serializer: path to serializer
  ## @res-model: path to model
  ## @res-serializer: path to serializer
  ## regular markdown
  def process_lines(files_and_header_sizes, generated_file_path)
    files_and_header_sizes.each do |entry|
      entry[:file][:lines].each do |line|
        args = line.split(' ')
        case args[1]
        when "@h:"
          # puts "this is a header"
          # remove first 2 entries in array
          args.shift(2)
          header_size = entry[:file][:sizes][:h]
          process_header(args, generated_file_path, header_size)
        when "@b-model:"
          # puts "this is a body"
          # remove first 2 entries in array
          args.shift(2)
          process_body_model(args, generated_file_path)
        when "@res-model:"
          # puts "this is a response"
          # remove first 2 entries in array
          args.shift(2)
          process_response_model(args, generated_file_path)
        else
          # puts "this is regular markdown"
          # remove first entry in array
          args.shift
          process_markdown(args, generated_file_path)
        end
      end
    end
  end

  private
    ############################################################################
    #### FORMAT:
    # TODO user passes size of headers(number of # to print) when importing
    #
    def process_header(args, file_path, header_size)
      # puts "args: #{args}"
      args = args.join(' ')
      File.open(file_path, "a") do |f|
        str = " #{args}"
        header_size.to_i.times{ str.insert(0, "#")}
        # write to file
        f << str
        f << "\n"
      end
    end

    def process_body_model(args, file_path)
      # puts "args: #{args}"
      args = args.join(' ').strip
      lines = scan_model_for_body(args)
      File.open(file_path, "a") do |f|
        lines.each do |l|
          f << l
          f << "\n"
        end
      end
    end

    def process_response_model(args, file_path)
      # puts "args: #{args}"
      args = args.join(' ').strip
      lines = scan_model_for_response(args)
      File.open(file_path, "a") do |f|
        lines.each do |l|
          f << l
          f << "\n"
        end
      end
    end

    def process_markdown(args, file_path)
      # puts "args: #{args}"
      args = args.join(' ')
      File.open(file_path, "a") do |f|
        f << "#{args}"
        f << "\n"
      end
    end

    ############################################################################
    ####### GET RESPONSE AND BODY FROM MODEL
    ### detect lit doc code and process it
    ### lit code syntax:
    ## @h: header text
    ## @b: body
    ## @res: response
    def scan_model_for_body(model_name)
      return scan_model("@b:", model_name)
    end

    def scan_model_for_response(model_name)
     return scan_model("@res:", model_name)
    end

    def scan_model(switch, model_name)
      path = "app/models/#{model_name.downcase}.rb"
      scanned_docs = []
      read_doc_flag = false
      File.open(path, "r").each_line do |line|
        if (line[/^\s*##.*/])
          args = line.strip.split(' ')
          # at start of body doc
          if args[1] == switch
            read_doc_flag = true
            scanned_docs.push("``` json")
          elsif read_doc_flag
            args.shift(1)
            doc = args.join(' ')
            scanned_docs.push("#{doc}")
          end
        else
          # line has no ##, switch read flag off
          if read_doc_flag
            read_doc_flag = false
            scanned_docs.push("```")
          end
        end
      end
      return scanned_docs
    end
end
