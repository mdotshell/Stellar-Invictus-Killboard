class KillboardController < ApplicationController
  include KillboardHelper
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def index
    if params[:search]
      @kills = Kill.where("full_name LIKE ?", "%#{params[:search]}%").where(created_at: (Time.now - 30.days)..Time.now)
                   .order('created_at DESC')
                   .first(50)
    else
      @kills = Kill.where(created_at: (Time.now - 1.days)..Time.now)
                   .order('created_at DESC')
                   .first(50) 
    end
                 
    @wall_of_shame = Kill.select("full_name, count(full_name) AS count, avatar, identifier")
                         .where(created_at: (Time.now - 7.days)..Time.now)
                         .group(:full_name)
                         .order('count DESC')
                         .first(10)
                    
    @top_killers = Kill.select("killers, count(killers) AS count, avatar, identifier")
                       .where(created_at: (Time.now - 7.days)..Time.now)
                       .group(:killers)
                       .order('count DESC')
                       .first(10)
  end

  def create 
    @allowed_ips = ["168.30.200.214","54.229.252.32","209.50.61.92", "127.0.0.1","75.91.105.88"]
    if @allowed_ips.include?(request.remote_ip)
      # Weird params stuff
      kill_params[:identifier] = kill_params[:id]
      
      # Safety check because some kills come in multiple times
      return if Kill.where(created_at: (Time.now - 1.minutes)..Time.now, identifier: kill_params[:identifier]).present?
      
      @kill = Kill.new(kill_params.except(:id))
      if @kill.save
        render plain: "Success\n" 
      else
        render plain: "Failed to add new record. Errors: #{@kill.errors.full_messages}\n"
      end
    else
      render plain: "Forbidden\n"
    end
  end
  
  def show
    @kill = Kill.find(params[:id])
    @total_deaths =  Kill.where(full_name: @kill.full_name).count
  end
  
  def user
    if params[:id]
      @kills = Kill.where(identifier: params[:id]).order('created_at DESC').first(30) + Kill.where("killers LIKE ?", "%id: #{params[:id]}\n%").order('created_at DESC').first(30)
      @id = params[:id]
    end
  end
  
  def system
    if params[:name]
      @kills = Kill.where(system_name: params[:name]).order('created_at DESC').first(30)
    end  
  end

  def corporation
    if params[:id]
      @kills = Kill.where("corporation LIKE ?", "%id: #{params[:id]}\n%").order('created_at DESC').first(30) + Kill.where("killers LIKE ?", "%id: #{params[:id]}\n%").order('created_at DESC').first(30)
      @id = params[:id]
    end
  end

  def kill_params
    params.require(:kill).permit!
  end

end
