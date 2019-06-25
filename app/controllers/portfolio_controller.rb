class PortfolioController < ApplicationController
  
  get '/portfolios' do 
    if logged_in?
      @portfolios = Portfolio.all
      erb :"/portfolio/index"
    else 
      redirect to '/login'
    end 
  end 
  
  get '/portfolios/new' do 
    if logged_in?
      @stocks = current_user.portfolios.collect{|x| x.stocks.collect{|y| y}}.flatten
      @portfolios = Portfolio.all
      erb :"portfolio/new"
    else 
      redirect to '/login'
    end 
  end 
  
  post '/portfolios' do 
    if logged_in?  
      if !params[:portfolio].empty?
        params[:portfolio][:name].tr!(" ","_")
        portfolio = current_user.portfolios.create(params[:portfolio])
        if !params[:stock][:name].empty?
          portfolio.stocks.create(params[:stock]).weights.create(params[:weight])
        end 
      end 
        erb :"/portfolio/index"
    else 
      redirect to '/login'
    end
    
  end 
  
  get '/portfolios/:id' do 
    @portfolio = Portfolio.find(params[:id])
    if logged_in?
      erb :'portfolio/show'
    else 
      redirect to '/users/login'
    end 
  end
  
  get '/portfolios/:id/edit' do 
    if logged_in?
      @portfolio = Portfolio.find(params[:id])
      @stocks = current_user.portfolios.collect{|x| x.stocks.collect{|y| y}}.flatten
      erb :'portfolio/edit'
    else 
      redirect to '/login'
    end 
  end
  
  patch '/portfolios/:id' do
    if logged_in?  
      if !params[:portfolio][:name].empty?
        @portfolio = Portfolio.find(params[:id])
        @stock = Stock.find(params[:portfolio][:stock_ids])[0]
        @portfolio.stocks.first.update(name: @stock.name, description: @stock.description)
        @portfolio.stocks.first.weights.first.update(params[:weight])
        @portfolio.update(name: params[:portfolio][:name])
      end 
        erb :"/portfolio/index"
    else 
      redirect to '/login'
    end
  end
  
  delete '/portfolios/:id' do
    if logged_in? 
      @portfolio = Portfolio.find(params[:id])
      if current_user.id == @portfolio.user_id.to_i
        @portfolio.delete
        redirect to "/portfolios"
      else 
        redirect to "/portfolios/#{current_user.id}/edit"
      end 
    else 
      redirect to '/login'
    end
  end
  
  get '/resetall' do 
    Portfolio.destroy_all
    User.destroy_all
    Weight.destroy_all
    Stock.destroy_all
  end 
  
end 