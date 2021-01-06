require 'aws-sdk'
module ApplicationHelper

    def publish_message(message_text)
        puts "Going to publish the message"
        puts "--------------------------"
        mh = MessageHelper.new
        mh.send(message_text)
        puts "--------------------------"
    end

    class MessageHelper

        AK = ENV["DB_AK"]
        SK = ENV["DB_SK"]
        URL = "https://sqs.us-east-2.amazonaws.com/162174280605/DarrensQueue.fifo"

        @@sqs = Aws::SQS::Client.new(region: 'us-east-2', credentials: Aws::Credentials.new(AK, SK))

        def send(message_text)
            puts "Sending ..."
            puts message_text
            @@sqs.send_message(queue_url: URL, message_body: message_text, message_group_id: "quiz")
            puts "Sent."
        end
    end
end
