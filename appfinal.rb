require 'net/http'
require 'uri'
require 'json'
require 'dotenv/load'

class Translation
    def initialize (text, o_lang, f_lang)
        @text = text
        @original_lang = o_lang
        @final_lang = f_lang
        @api_begin_url = '/api/v1.5/tr.json/'
        @api_key = ENV['API_KEY']
        @url_host = 'translate.yandex.net'
        @time = Time.now
        @translated = translated

        puts "#{@original_lang} -> #{@final_lang}"
        puts "Original text: #{@text}"
        print "Translated text: "
        puts @translated

        file_name = Time.now.strftime('%d-%m-%y_%Hh%M').to_s

        File.open("#{file_name}.txt", "a") do |line|
            line.puts "#{@original_lang} -> #{@final_lang}\n"
            line.puts "Original text: #{@text}"
            line.puts "Translated text: #{@translated}"
        end
    end

    private

    def requistion url
        req = Net::HTTP::Post.new(url)
        Net::HTTP.start(@url_host, use_ssl: true) do |http|
            return http.request(req)
        end
    end

    def lang_identifier lang
        api_url = "#{@api_begin_url}getLangs?ui=en&key=#{@api_key}"
        response = requistion(api_url)
        langs = JSON.parse(response.body)["langs"]
        langs.each do |key, value|
            if value == lang
                return key
            end
        end
    end

    def translated
        @textCONVERT = URI.encode_www_form_component(@text)
        @original_langID = lang_identifier(@original_lang)
        @final_langID = lang_identifier(@final_lang)
        api_url = "#{@api_begin_url}translate?lang=#{@original_langID}-#{@final_langID}&text=#{@textCONVERT}&key=#{@api_key}"
        response = requistion(api_url)
        response = JSON.parse(response.body)["text"][0].to_s
        return response
    end

    
end

puts 'Hello! Enter the text that you want to translate'
texto = gets.chomp
print 'Now, enter the language of your text: '
original_lang = gets.chomp
print 'Now, enter the language that you want your text translated: '
final_lang = gets.chomp

traducao = Translation.new(texto, original_lang, final_lang)
