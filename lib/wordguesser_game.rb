class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_accessor:guesses
  attr_accessor:wrong_guesses
  attr_accessor:word
  attr_accessor:word_with_guesses
  attr_accessor:check_win_or_lose
  attr_accessor:repeated
  attr_accessor:valid



  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses='-'*word.to_s.length
    @check_win_or_lose= :play
    @repeated=false
    @valid=true
  end


  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(ch)
    if ch==''
      @valid=false
      raise ArgumentError 
    end
    ch=ch.to_s.downcase
    if ch<'a'||ch>'z'
      @valid=false
      raise ArgumentError 
    end
    if !ch
      @valid=false
      raise ArgumentError 
    end
    if @word.to_s.index(ch)
      if !@guesses.index(ch)
        @guesses=@guesses.to_s+ch.to_s
      else
        @repeated=true
        return false#重复正确猜测
      end
    else
      if !@wrong_guesses.index(ch)
        @wrong_guesses=@wrong_guesses.to_s+ch.to_s
      else
        @repeated=true
        return false#重复错误猜测
      end
    end
    #显示目前已经猜测可显示的词
    for i in 0...@word.to_s.length
      if @guesses.include?(@word.to_s[i])
        @word_with_guesses[i]=@word.to_s[i]
      end
    end
    #目前猜测的词语与给出的词语一致，游戏胜利
    if @word_with_guesses==@word
      @check_win_or_lose= :win
    end
    #错误次数已经超过7次，游戏结束
    if @wrong_guesses.to_s.length>=7
      @check_win_or_lose= :lose
    end
    return true
  end
end