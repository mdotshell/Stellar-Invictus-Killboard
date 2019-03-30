App.room = App.cable.subscriptions.create "KillNotificationsChannel",
  received: (data) -> $('.killfeed').prepend data['message']
