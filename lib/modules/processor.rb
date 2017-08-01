require 'modules/scanner'

module Processor
  def process_regular_markdown_lines(lines, generated_file_path)
    File.open(generated_file_path, 'a') do |f|
      lines.each do |line|
        f << line.to_s
      end
    end
  end
  ##############################################################################
  ### detect lit doc code and process it
  ### lit code syntax:
  ## @h: header text
  ## @r: http_method route
  ## @b-model: path to model
  ## @b-serializer: path to serializer
  ## @res-model: path to model
  ## @res-serializer: path to serializer
  ## regular markdown
  def process_lit_doc_lines(files_and_header_sizes, generated_file_path)
    files_and_header_sizes.each do |entry|
      entry[:file][:lines].each do |line|
        args = line.split(' ')

        File.open(generated_file_path, 'a') { |f| f << "\n" }

        # args.shift(2) = remove first 2 entries in array
        case args[1]
        when '@h:'
          args.shift(2)
          header_size = entry[:file][:sizes][:h]
          process_header(args, generated_file_path, header_size)
        when '@r:'
          args.shift(2)
          process_route(args, generated_file_path)
        when '@b-model:'
          args.shift(2)
          process_body_model(args, generated_file_path)
        when '@res-model:'
          args.shift(2)
          process_response_model(args, generated_file_path)
        when '@b-serializer:'
          args.shift(2)
          process_body_serializer(args, generated_file_path)
        when '@res-serializer:'
          args.shift(2)
          process_response_serializer(args, generated_file_path)
        else
          args.shift
          process_markdown(args, generated_file_path)
        end
      end
    end
  end

  def process_header(args, file_path, header_size)
    # puts "args: #{args}"
    args = args.join(' ')
    File.open(file_path, 'a') do |f|
      str = " #{args}"
      header_size.to_i.times { str.insert(0, '#') }
      # write to file
      f << str
      f << "\n"
    end
  end

  # args = http_method url
  def process_route(args, file_path)
    File.open(file_path, 'a') do |f|
      # write to file
      str = "`#{args[0].upcase} #{args[1]}`"
      f << str
      f << "\n"
    end
  end

  def process_body_model(args, file_path)
    # puts "args: #{args}"
    args = args.join(' ').strip
    lines = scan_model_for_body(args)
    File.open(file_path, 'a') do |f|
      lines.each do |l|
        f << l
        f << "\n"
      end
    end
  end

  def process_response_model(args, file_path)
    # puts "args: #{args}"
    args = args.join(' ').strip
    lines = Scanner.scan_model_for_response(args)
    File.open(file_path, 'a') do |f|
      lines.each do |l|
        f << l
        f << "\n"
      end
    end
  end

  def process_body_serializer(args, file_path)
    # puts "args: #{args}"
    args = args.join(' ').strip
    lines = Scanner.scan_serializer_for_body(args)
    File.open(file_path, 'a') do |f|
      lines.each do |l|
        f << l
        f << "\n"
      end
    end
  end

  def process_response_serializer(args, file_path)
    # puts "args: #{args}"
    args = args.join(' ').strip
    lines = Scanner.scan_serializer_for_response(args)
    File.open(file_path, 'a') do |f|
      lines.each do |l|
        f << l
        f << "\n"
      end
    end
  end

  def process_markdown(args, file_path)
    # puts "args: #{args}"
    args = args.join(' ')
    File.open(file_path, 'a') do |f|
      f << args.to_s
      f << "\n"
    end
  end
end
