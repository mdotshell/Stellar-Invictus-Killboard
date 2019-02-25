class KillNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "kill_notifications_channel"
  end

  def unsubscribed

  end
end
