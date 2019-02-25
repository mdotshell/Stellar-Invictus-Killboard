class Kill < ApplicationRecord
  serialize :killers
  serialize :loot
  serialize :corporation
  
  def self.items
    YAML.load_file("#{Rails.root.to_s}/config/variables/items.yml")
  end
  
  def self.spaceships
    YAML.load_file("#{Rails.root.to_s}/config/variables/spaceships.yml")
  end
  
  def self.systems
    YAML.load_file("#{Rails.root.to_s}/config/variables/systems.yml")
  end
  
  after_create_commit do
    ActionCable.server.broadcast 'kill_notifications_channel', message: ApplicationController.renderer.render(partial: 'killboard/feed', locals: { last_kill: self })
  end
end
