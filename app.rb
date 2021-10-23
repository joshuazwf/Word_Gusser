require 'sinatra/base'
require 'sinatra/flash'
require_relative './lib/wordguesser_game.rb'

class WordGuesserApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || WordGuesserGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word #游戏开始时选定的单词
    # NOTE: don't change previous line - it's needed by autograder!
    @game = WordGuesserGame.new(word)#根据初始的单词创建游戏
    redirect '/show'
  end
  
  # Use existing methods in WordGuesserGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s #获取用户输入的字母
    if letter<'a'||letter>'z'
      flash[:message]="Invalid guess."
      redirect "/show"
    end
    @game.guess(letter) #进行猜测
    #判断状态
    if @game.check_win_or_lose==:win
      redirect "/win"
    elsif @game.check_win_or_lose==:lose
      redirect "/lose"
    else
      if @game.repeated
        flash[:message]="You have already used that letter."
      end
    end
    ### YOUR CODE HERE ###
    redirect '/show'
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in WordGuesserGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    ### YOUR CODE HERE ###
    erb :show # You may change/remove this line
  end
  
  get '/win' do
    if @game.check_win_or_lose==:play
      redirect "/show"
    end
    ### YOUR CODE HERE ###
    erb :win # You may change/remove this line
  end
  
  get '/lose' do
    if @game.check_win_or_lose==:play
      redirect "/show"
    end
    ### YOUR CODE HERE ###
    erb :lose # You may change/remove this line
  end
end