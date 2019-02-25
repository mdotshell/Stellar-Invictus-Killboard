namespace :refresh do
  
  desc "Refresh Users"
  task :users => :environment do
    kills = Kill.all.pluck(:identifier).uniq!
    kills.each do |umb|
      
      # Update Losses
      master = Kill.where(identifier: umb).order('created_at DESC').first
      slaves = Kill.where(identifier: umb).where.not(id: master.id)
      
      slaves.each do |slave|
        slave.update_columns(full_name: master.full_name, corporation: master.corporation, avatar: master.avatar)
      end
      
      # Update Kills
      Kill.where("killers LIKE ?", "%id: #{umb}\n%").each do |tmb|
        new_killers = tmb.killers.dup
        new_killers.each do |killer|
          if killer['id'] == umb
            killer['full_name'] = master.full_name
            killer['name'] = master.full_name
            killer['corporation'] = master.corporation
            killer['avatar'] = master.avatar
          end
        end
        
        tmb.update_columns(killers: new_killers) and next
      end
      
    end
  end
end