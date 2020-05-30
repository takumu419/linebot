class LinebotController < ApplicationController
    require "Line/bot"
    
    protect_form_forgery :except => [:callback]
    
    def client
        @client ||= line::Bot::Client.new{|config|config.channel_secret = ENV ["LINE_CHANNEL_SECRET"]
            cofig.channel_token = ENV["LINE_CHANNEL_TOKEN"]
        }
    end


    def callback
        @post=Post.offset(rand(POst.count)).first
        body = request.body.read
        
        signature = request.env["HTTP_X_LINE_SIGNATURE"]
        unless client.validate_signature(body,signature)
        head :bad_request
        end
        
        events.each { |event|
        
        if event.message["text"].include?("にゅん")
            response = "お、ぬべか"
            
        elsit event.message["text"].include?("にゅんめ")
            response ="ぬべめ"
            
        elsit event.message["text"].include?("ばかめ")
            response ="ぬべはドジ"
        
        elsit event.message["text"].include?("くだらない")
            response ="ばかめぬべ"
            
        
        elsit event.message["text"].include?("つかれた")
            response ="おつかれぬべ！"
            
        elsit event.message["text"].include?("うるさい")
            response ="ぬべはおしっこをびじゃびじゃとする"
            
        elsit event.message["text"].include?("おやすみ")
            response ="おやすみ"    
            
        elsit event.message["text"].include?("にゅんか")
            response ="にゅんです"
            
        else
            response = @post.name
        end

        case event
        when Line::Bot::Event::Message
            case event.type
            when Line::Bot::Event::MessageType::Text
                message = {
                    type: "text",
                    text: response
                }
                client.reply_message(event["replyToken"],message)
            end
        end
        }
        
        head :ok
    end
end