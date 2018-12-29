class TweetsController < ApplicationController

  get '/tweets' do
    # binding.pry
    if Helpers.is_logged_in? session
      @user = Helpers.current_user session
      erb :"tweets/tweets"
    else
      redirect "/login"
    end
  end

  get '/tweets/new' do
   if Helpers.is_logged_in? session
     erb :'tweets/new_tweet'
   else
     redirect to '/login'
   end
  end

  post '/tweets' do
    # binding.pry
    if Helpers.is_logged_in? session
      tweet = Helpers.current_user(session).tweets.build(content: params[:content])
      if tweet.save
        redirect to "/tweets/#{tweet.id}"
      else
        redirect to "/tweets/new"
      end
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id' do
    if Helpers.is_logged_in? session
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do
   if Helpers.is_logged_in? session
     @tweet = Tweet.find(params[:id])
     if @tweet && @tweet.user == Helpers.current_user(session)
       erb :'tweets/edit_tweet'
     else
       redirect to '/tweets'
     end
   else
     redirect to '/login'
   end
  end

  patch '/tweets/:id' do
    if Helpers.is_logged_in? session
      tweet = Tweet.find_by_id(params[:id])
      if tweet && tweet.user == Helpers.current_user(session)
        if tweet.update(content: params[:content])
          redirect to "/tweets/#{tweet.id}"
        else
          redirect to "/tweets/#{tweet.id}/edit"
        end
      else
        redirect to '/tweets'
      end
    else
      redirect to '/login'
    end
  end

  delete '/tweets/:id/delete' do
    if Helpers.is_logged_in? session
      tweet = Tweet.find_by_id(params[:id])
      if tweet && tweet.user == Helpers.current_user(session)
        tweet.delete
      end
      redirect to '/tweets'
    else
      redirect to '/login'
    end
  end
end
