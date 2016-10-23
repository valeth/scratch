#!/usr/bin/env ruby

class Hummingbird
    require 'json'
    require 'net/http'
    require 'uri'

    def initialize()
        @version = "v1"
        @url = "https://hummingbird.me/api/#{@version}/"
        @auth_token = nil
    end

    def get_auth_token
        @auth_token
    end

    def get(resource)
        parsed_url = URI.parse "#{@url}#{resource}"
        puts "INFO: GET request: #{parsed_url}"
        http = Net::HTTP.new parsed_url.host, parsed_url.port
        http.use_ssl = true
        get_req = Net::HTTP::Get.new parsed_url
        response = http.request get_req
        return response
    end

    def post(resource)
        parsed_url = URI.parse "#{@url}#{resource}"
        puts "INFO: POST request: #{parsed_url}"
        http = Net::HTTP.new parsed_url.host, parsed_url.port
        http.use_ssl = true
        post_req = Net::HTTP::Post.new parsed_url
        response = http.request post_req
        return response
    end

    def parse_response(response)
        case response
            when Net::HTTPSuccess
                JSON.parse response.body
            else
                { 'error' => "#{response.message}" }
        end
    end

    def anime_by_id(id, tl_pref = 'canonical')
        parse_response get "anime/#{id}?title_language_preference=#{tl_pref}"
    end

    def anime_by_title(title)
        parse_response get "search/anime?query=#{title}"
    end

    def user_library(username, status = nil)
        if status
            parse_response get "users/#{username}/library?status=#{status}"
        else
            parse_response get "users/#{username}/library"
        end
    end

    # struct:
    #  { 'status' => 'currently-watching' OR 'plan-to-watch' OR 'completed' OR 'on-hold' OR 'dropped',
    #    'privacy => 'public' OR 'private',
    #    'rating' => IN { 0, 0.5 ... 5 } ,
    #    'sane_rating_update' => IN { 0, 0.5 ... 5 },
    #    'rewatching' => true OR false,
    #    'rewatched_times' => IN { 0 ... },
    #    'notes' => STRING,
    #    'episodes_watched' => IN { 0 ... n } WHERE n is total number of episodes,
    #    'increment_episodes' => true OR false
    #  }
    def user_update_entry(id, increment)
        if not @auth_token
            { 'error' => 'User not authenticated' }
            return
        end

        response = post "libraries/#{id}?auth_token=#{@auth_token}&increment_episodes=#{increment}"
        case response
        when Net::HTTPSuccess
            { 'success' => "#{response.message}" }
        when Net::HTTPUnauthorized
            { 'error' => "#{response.message}" }
        else
            { 'error' => "#{response.message}" }
        end
    end

    def user_remove_entry()
    end

    def authenticate(password, username = nil, email = nil)
        resource = "users/authenticate?password=#{password}"

        if username
            resource = "#{resource}&username=#{username}"
        elsif email
            resource = "#{resource}&email=#{email}"
        else
            return { 'error' => "username OR email required" }
        end

        response = post resource
        case response
            when Net::HTTPCreated
                @auth_token = JSON.parse("[#{response.body}]")[0]
            else
                { 'error' => "#{response.message}" }
        end
    end

    def user_info(username)
        parse_response get "users/#{username}"
    end

    def user_activity(username)
        parse_response get "user/#{username}/feed"
    end

    def user_favourite(username)
        parse_response get "user/#{username}/favorite_anime"
    end
end


hb = Hummingbird.new

for entry in hb.user_library 'valeth'
    if entry["anime"]["title"] == "Toradora!"
        puts JSON.pretty_generate entry
    end
end

#hb.authenticate "", ""

#puts hb.user_update_entry '', true
