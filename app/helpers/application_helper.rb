module ApplicationHelper
  
  def get_total_value_of_kill(kill)
    cost = 0
    
    return 0 unless kill.loot
    
    kill.loot.each do |l|
      cost += (Kill.items[l['name']]['price'] rescue 0) * l['amount'].to_i
    end
    cost += Kill.spaceships[kill.ship_name]['price']
    cost.round
  end
  
  def get_dropped_value_of_kill(kill)
    cost = 0
    
    return 0 unless kill.loot
    
    kill.loot.each do |l|
      cost += (Kill.items[l['name']]['price'] rescue 0) * l['amount'].to_i if l['dropped']
    end
    cost.round
  end
  
  def get_destroyed_value_of_kill(kill)
    cost = 0
    
    return 0 unless kill.loot
    
    
    kill.loot.each do |l|
      cost += (Kill.items[l['name']]['price'] rescue 0) * l['amount'].to_i unless l['dropped']
    end
    cost += Kill.spaceships[kill.ship_name]['price']
    cost.round
  end
end
