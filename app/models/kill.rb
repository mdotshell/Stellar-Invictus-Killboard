class Kill < ApplicationRecord
  serialize :killers
  serialize :loot
  serialize :corporation
  @items = YAML.load_file("#{Rails.root.to_s}/config/variables/items.yml")
  @spaceships = YAML.load_file("#{Rails.root.to_s}/config/variables/spaceships.yml")
  @systems = YAML.load_file("#{Rails.root.to_s}/config/variables/systems.yml")

  def self.items
    @items
  end

  def self.spaceships
    @spaceships
  end

  def self.systems
    @systems
  end

  after_create_commit do
    ActionCable.server.broadcast 'kill_notifications_channel', message: ApplicationController.renderer.render(partial: 'killboard/feed', locals: { last_kill: self })
  end
end
