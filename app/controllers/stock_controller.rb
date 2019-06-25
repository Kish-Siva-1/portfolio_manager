class StockController < ApplicationController
  
  get '/stock/new/:id' do
    if logged_in?
      @stocks = Stock.all
      @id = params[:id]
      erb :"stock/new"
    else 
      redirect to '/login'
    end 
  end
  
  post '/stock/new/:id' do 
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
        stock_store = Stock.create(stock_names[k])
        weight_store = Weight.create(portfolio_weight[k])
        portfolio.stocks << stock_store 
        stock_store.weights << weight_store
        k += 1
      end 
      
      erb :"/portfolio/index"
    
    else 
      redirect to '/login'
    end
  end
  
  get '/stock/edit/:id' do
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
  
  get '/stock/:port/:id/delete' do
    if logged_in? 
      @stock = Portfolio.find(params[:port]).stocks[params[:id].to_i]
      @portfolio = Portfolio.find(params[:port])
      if current_user.id == @portfolio.user_id.to_i
        @id = params[:port]
        @stock.delete
        redirect to "stock/edit/#{@id}"
      else 
        redirect to "/portfolio/#{current_user.id}/edit"
      end 
    else 
      redirect to '/login'
    end
  end 
  
  patch '/stock/:id' do
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
      
      redirect to "/portfolio"
    end 
  end
  
end 