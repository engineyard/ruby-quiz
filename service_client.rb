require 'net/http'
require 'json'
require 'date'
require 'highline'

def red(text)
    HighLine::color(text, :red)
end
def cyan(text)
    HighLine::color(text, :cyan)
end
def get_data_from_website(url)
    Net::HTTP.get(URI(url))
end

def call_summary_service(thread_id)
    puts "[Thread #{thread_id}]  Calling summary service ..."
    begin
        data = get_data_from_website("http://summaryservice.prod-clstr.thebroemmergroupllc.ey.io/")
        puts cyan "[Thread #{thread_id}]  call success: #{data}"

    rescue => e 
        puts red "[Thread #{thread_id}]  call FAILED: #{e}" 
    end 
end


def do_the_work(thread_id)
    100.times do
        call_summary_service(thread_id)
        sleep_time = rand 
        puts "[Thread #{thread_id}]  Sleeping for #{sleep_time}"
        sleep sleep_time 
    end
end 

def load_test
    threads = []
    200.times {
        threads << Thread.new { do_the_work(rand(200)) }
    }
    threads.each(&:join)
end


load_test
#call_summary_service(1)
