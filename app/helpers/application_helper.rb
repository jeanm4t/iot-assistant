module ApplicationHelper
  # Private: Cross-platform `which` command.
  # Source: http://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
  #
  # Example - 
  #   which('ruby') #=> /usr/bin/ruby
  # 
  # Returns the path of the executable.
  def which(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      exts.each { |ext|
        exe = "#{path}/#{cmd}#{ext}"
        return exe if File.executable? exe
      }
    end
    return nil
  end
  
  def fortune
    if f = which("fortune")
      ascii(%x[#{f} -n 100 -s]).gsub("\t", "")
    end
  end

  def greeting
    @greetings ||= ['Aloha', 'Bonjour', 'Guten-Tag', 'Hello', 'Oh Hai', 'Hallo', 'Hola', 'Hej', 'Hey', 'Hi', 'Salut', 'Zdravstvuyte']
    @greetings[Random.rand(@greetings.length)]
  end

  def ascii(str)
    # See String#encode
    encoding_options = {
      :invalid           => :replace,  # Replace invalid byte sequences
      :undef             => :replace,  # Replace anything not defined in ASCII
      :replace           => '',        # Replace above with this
      :universal_newline => true       # Always break lines with \n
    }
    str.encode Encoding.find('ASCII'), encoding_options
  end

  def wrap(format, str)
    format + " " + word_wrap(str, :line_width => 32).split("\n").join("\n#{format} ")
  end

  # Public: Fetch recent stories from The Times
  def recent_stories(count=3)
    response = Typhoeus::Request.get("http://www.thetimes.co.uk/tto/news/rss")
    if response.success?
      doc = Nokogiri::XML.parse(response.body)
      doc.css("item").map{|story| story.at_css("title").text}.slice(0,count)
    else
      []
    end
  end

  # Pass in a string and it sortens it to the desired number of words with the possibility to define custom ending.
  def truncate_words(text, length = 3, end_string = ' ...')
    return if text == nil
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
end
