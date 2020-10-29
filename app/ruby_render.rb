# frozen_string_literal: true

require 'faye/websocket'

# simple rack app that render html canvas and
# serve websocket for transfer render data
class RubyRender
  def call(env)
    if Faye::WebSocket.websocket?(env)
      serve_websocket(env)
    elsif env['PATH_INFO'] == '/favicon.ico'
      [200, { 'Content-Type' => 'image/ico' }, File.open(File.expand_path('public/favicon.ico'))]
    else
      [200, { 'Content-Type' => 'text/plain' }, ['Hello']]
    end
  end

  private

  def serve_websocket(env)
    ws = Faye::WebSocket.new(env)

    ws.on :message do |event|
      ws.send(event.data)
    end

    ws.on :close do |_event|
      ws = nil
    end

    ws.rack_response
  end
end
