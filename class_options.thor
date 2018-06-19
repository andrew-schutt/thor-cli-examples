class Volume < Thor
  class_option :yelling, :type => :boolean,
                         :default => false,
                         :desc => "engage yelling mode",
                         :aliases => "-y"

  desc "yell", "yell it!"
  def yell
      msg = "I am not yelling! You're yelling!"
      if options[:yelling]
        puts msg.upcase
      end
      puts msg
  end

  desc "whisper", "shhhh"
  def whisper
      if options[:yelling]
        msg = "please stop yelling. whisper time"
      else
        msg = "shhh, whisper, whisper"
      end
      puts msg
  end
end
