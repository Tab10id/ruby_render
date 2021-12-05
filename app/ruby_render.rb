# frozen_string_literal: true

require 'faye/websocket'
require 'permessage_deflate'

require_relative 'controllers/render'

# simple rack app that render html canvas and
# serve websocket for transfer render data
class RubyRender
  def call(env)
    if Faye::WebSocket.websocket?(env)
      serve_websocket(env)
    else
      [200, { 'Content-Type' => 'text/plain' }, ['Hello']]
    end
  end

  private

  def serve_websocket(env)
    ws = Faye::WebSocket.new(env, [], extensions: [PermessageDeflate])

    ws.on :message do |_event|
      ws.send(Controllers::Render.new.ray_tracing)
    end

    loop =
      EM.add_periodic_timer(0.01) do
        ws.send(Controllers::Render.new.ray_tracing)
      end

    ws.on :close do |_event|
      EM.cancel_timer(loop)
      ws = nil
    end

    ws.rack_response
  end
end
