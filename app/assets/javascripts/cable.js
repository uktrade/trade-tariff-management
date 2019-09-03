// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

(function() {
  this.App || (this.App = {});

  if(window.action_cable_url) {
    App.cable = ActionCable.createConsumer(window.action_cable_url);
  } else {
    App.cable = ActionCable.createConsumer();
  }

}).call(this);
