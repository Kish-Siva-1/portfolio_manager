class UsersController < ApplicationController
  
  get '/signup' do 
    if logged_in? 
      redirect to '/portfolio'
    else
      erb :'users/create_user'
    end
  end

  post '/signup' do 
    if !logged_in?
      @user = User.new(params)
      if @user.save 
        session[:user_id] = @user.id
        redirect to '/portfolio'
      else 
        redirect to '/signup'
      end
    else 
      redirect to '/portfolio'
    end 
  end
  
  get '/login' do 
    if logged_in?
      redirect to '/portfolio'
    else 
      erb :'users/login'
    end 
  end
  
  post '/login' do 
    user = User.find_by(username: params[:username])
    if user.authenticate(params[:password]) && (user.username == params[:username]) 
      session[:user_id] = user.id
      redirect to '/portfolio'
    end
  end
  
  get '/logout' do 
    if logged_in?
      session.clear
    end
    redirect to '/login'
  end
  
  post '/logout' do 
    redirect to '/login'
  end
  
end 