module Scanner

  # return all files to be imported/scanned(files that contain lit doc)
  # and headers sizes for each file
  # returns array of hashes:
  # [ { file: "file_path", header_sizes: {h: integer} } ]
  def read_source_file(file_path)
    file_paths_and_header_sizes = []
    regular_markdown_lines = []

    File.open(file_path, "r").each_line do |line|
      inspect_line = line.lstrip
      args = inspect_line.split(' ')
      # puts "arguments in source.md: #{args}"
      if args[0] == "@import"
        # see if {h: 1} pattern exists
        header_sizes = inspect_line[/{\s*h:\s*[0-9]\s*}/]
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
      else
        regular_markdown_lines.push(line)
      end
    end

    return file_paths_and_header_sizes, regular_markdown_lines
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

  ############################################################################
  ####### GET RESPONSE AND BODY FROM MODEL
  ### detect lit doc code and process it
  ### lit code syntax:
  ## @h: header text
  ## @b: body
  ## @res: response
  def scan_model_for_body(model_name)
    scan_hash('@b:', "app/models/#{model_name.downcase}.rb")
  end

  def scan_model_for_response(model_name)
    scan_hash('@res:', "app/models/#{model_name.downcase}.rb")
  end

  ############################################################################
  ####### GET RESPONSE AND BODY FROM SERIALIZER
  ### detect lit doc code and process it
  ### lit code syntax:
  ## @h: header text
  ## @b: body
  ## @res: response
  def scan_serializer_for_body(model_name)
    return scan_hash("@b:", "app/serializers/#{model_name.downcase}.rb")
  end

  def scan_serializer_for_response(model_name)
   return scan_hash("@res:", "app/serializers/#{model_name.downcase}.rb")
  end
  
  private

    ############################################################################
    ####### HELPER METHODS
    # scans for hash and turns it to jason
    def scan_hash(switch, path)
      scanned_docs = []
      read_doc_flag = false
      File.open(path, "r").each_line do |line|
        if (line[/^\s*##.*/])
          args = line.strip.split(' ')
          # at start of body doc
          if args[1] == switch
            read_doc_flag = true
            scanned_docs.push("``` json")
          # start writing json
          elsif read_doc_flag
            args.shift(1)
            formatted_json = []
            args.map do |entry|
              if /.*:/ =~ entry
                #format
                formatted_json.push('"'+entry[0..-2]+'"'+':')
              else
                # doesn't need formatting
                formatted_json.push(entry)
              end
            end
            doc = formatted_json.join(' ')
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
