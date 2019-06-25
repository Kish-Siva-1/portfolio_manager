class StockController < ApplicationController
  
  get '/stocks/:id' do
    if logged_in?
      @stocks = Stock.all
      @id = params[:id]
      erb :"stock/new"
    else 
      redirect to '/login'
    end 
  end
  
  post '/stocks/:id' do 
    if logged_in?
      stock_names = []
      portfolio_weight = []
      params.each do |x,y|
        break if x == "id"
        n = 0
        while n < y.length 
          if !y[n].values[0].empty?   
            if x == "stock"
              stock_names << y[n]
            elsif x == "weight" 
              portfolio_weight << y[n]
            end 
          end
          n+=1 
        end
      end 
      
      @id = params[:id]
      
      k = 0
      while k < stock_names.length
        portfolio = current_user.portfolios.find(@id)
        portfolio.stocks.create(stock_names[k]).weights.create(portfolio_weight[k])
        k += 1
      end 
      
      erb :"/portfolio/index"
    
    else 
      redirect to '/login'
    end
  end
  
  get '/stocks/:id/edit' do
    if logged_in?
      @id = params[:id]
      @portfolio = current_user.portfolios.find(@id)
      if current_user.id == @portfolio.user_id.to_i
        erb :"stock/edit"
      else 
        redirect to '/login'
      end
    else 
      redirect to '/login'
    end 
  end
  
  get '/stocks/:port/:id' do
    if logged_in? 
      @stock = Portfolio.find(params[:port]).stocks[params[:id].to_i]
      @portfolio = Portfolio.find(params[:port])
      if current_user.id == @portfolio.user_id.to_i
        @id = params[:port]
        @stock.delete
        redirect to "stocks/#{@id}/edit"
      else 
        redirect to "/portfolios/#{current_user.id}/edit"
      end 
    else 
      redirect to '/login'
    end
  end 
  
  patch '/stocks/:id' do
    @portfolio = Portfolio.find(params[:id])
    if current_user.id == @portfolio.user_id.to_i
      stock_names = []
      portfolio_weight = []
      params.each do |x,y|
      
        break if x == "id" 
        next if x == "_method"
        n = 0
        while n < y.length 
          if !y[n].values[0].empty?   
            if x == "stock"
              stock_names << y[n]
            elsif x == "weight" 
              portfolio_weight << y[n]
            end 
          end
          n+=1 
        end
      end 
      
      @id = params["id"]
        
      k = 0
      while k < stock_names.length
        current_user.portfolios.find(@id).stocks[k].update(name: stock_names[k]["name"])
        current_user.portfolios.find(@id).stocks[k].weights.last.update(portfolio_weight: portfolio_weight[k]["portfolio_weight"])
        k += 1
      end
      
      redirect to "/portfolios"
    end 
  end
  
end 