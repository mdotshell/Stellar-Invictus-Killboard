class KillboardController < ApplicationController
  include KillboardHelper
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def index
    if params[:search]
      @upcase = params[:search].split.map(&:capitalize).join(' ')
      @kills = Kill.where("full_name LIKE ?", "%#{@upcase}%")
                   .order('created_at DESC')
                   .first(50)
    else
      @kills = Kill.all #.where(created_at: (Time.now - 1.days)..Time.now)
                   .order('created_at DESC')
                   .first(20)
    end
                 
    @wall_of_shame = Kill.select("full_name, count(full_name) AS count, avatar, identifier")
                         .where(created_at: (Time.now - 7.days)..Time.now)
                         .group("full_name, kills.avatar, kills.identifier")
                         .order('count DESC')
                         .first(10)

    killers = Kill.select("killers")
    top_killers = []
    killers.each do |t|
      if t.killers[0] != "npc"
        k = { :id => t.killers[0]['id'], :name => t.killers[0]['name'] }
        top_killers.push(k)
      end
    end
    
    @top_killers = Hash.new 0
    top_killers.each do |x|
      @top_killers[x] += 1
    end
    @top_killers = @top_killers.sort_by{|k,v| v }.reverse[0..9]
  end

  def create 
      kill_params[:identifier] = kill_params[:id]
      
      # Safety check because some kills come in multiple times
      return if Kill.where(created_at: (Time.now - 1.minutes)..Time.now, identifier: kill_params[:identifier]).present?
      
      @kill = Kill.new(kill_params.except(:id))
      if @kill.save
        render plain: "Success\n" 
      else
        render plain: "Failed to add new record. Errors: #{@kill.errors.full_messages}\n"
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
