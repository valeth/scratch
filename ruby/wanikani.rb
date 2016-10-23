#!/usr/bin/ruby -w

module WaniKani
    require 'json'
    require 'net/http'
    require 'uri'
    require 'time'

    class WaniKani::JSymbol
        attr_reader :TYPE
        attr_reader :CHARACTER, :MEANING, :IMAGE, :LEVEL
        attr_reader :SRS, :SRS_NUMERIC, :UNLOCKED_DATE, :AVAILABLE_DATE
        attr_reader :BURNED, :BURNED_DATE
        attr_reader :MEANING_CORRECT, :MEANING_INCORRECT
        attr_reader :MEANING_MAX_STREAK, :MEANING_CURRENT_STREAK, :MEANING_NOTE
        attr_reader :READING_CORRECT, :READING_INCORRECT
        attr_reader :READING_MAX_STREAK, :READING_CURRENT_STREAK

        def initialize(type, json)
            @TYPE = type
            @CHARACTER = json['character']
            @MEANING = json['meaning']
            @IMAGE = json['image']
            @LEVEL = json['level']

            # user specific constants
            json_user = json['user_specific']
            @SRS = json_user['srs'] if json_user
            @SRS_NUMERIC = json_user['srs_numeric'] if json_user
            @UNLOCKED_DATE = json_user['unlocked_date'] if json_user
            @AVAILABLE_DATE = json_user['available_date'] if json_user
            @BURNED = json_user['burned'] if json_user
            @BURNED_DATE = json_user['burned_date'] if json_user
            @MEANING_CORRECT = json_user['meaning_correct'] if json_user
            @MEANING_INCORRECT = json_user['meaning_incorrect'] if json_user
            @MEANING_MAX_STREAK = json_user['meaning_max_streak'] if json_user
            @MEANING_CURRENT_STREAK = json_user['meaning_current_streak'] if json_user
            @READING_CORRECT = json_user['reading_correct'] if json_user
            @READING_INCORRECT = json_user['reading_incorrect'] if json_user
            @READING_MAX_STREAK = json_user['reading_max_streak'] if json_user
            @READING_CURRENT_STREAK = json_user['reading_current_streak'] if json_user
            @MEANING_NOTE = json_user['meaning_note'] if json_user
            @USER_SYNONYMS = json_user['user_synonyms'] if json_user
        end

        def to_s
            "#{@TYPE}(#{@CHARACTER || @IMAGE}, #{@AVAILABLE_DATE})"
        end

        alias to_str to_s
    end

    @key = nil
    @url = "https://www.wanikani.com/api/user/"
    @cache = {}
    @cache_timestamp = {}
    @cache_timeout = 3600

    def self.keyfile(filename)
        if File.exist? filename
            @key = open(filename).read.chomp
            @url = "#{@url}#{@key}/"
        else
            puts "The file #{filename} does not exist."
        end
    end

    def self.get(resource, args = "")
        return { 'error' => 'Keyfile not set' } if @key.nil?
        return @cache[resource] if
            Time.now.to_i - @cache_timestamp.fetch(resource, 0) <= @cache_timeout

        parsed_url = URI.parse("#{@url}#{resource}/#{args}")
        http = Net::HTTP.new(parsed_url.host, parsed_url.port)
        http.use_ssl = true
        get_req = Net::HTTP::Get.new(parsed_url)
        response = http.request(get_req)

        if response.code == "200"
            case response
            when Net::HTTPOK
                parsed = JSON.parse response.body
                @cache_timestamp[resource] = Time.now.to_i
                @cache[resource] = parsed
            when Net::HTTPServerError
                { 'error' => "#{response.message}" }
            end
        end
    end

    def self.user_information
        get('user-information')['user_information']
    end

    def self.study_queue
        get('study-queue')['requested_information']
    end

    def self.level_progression
        get('level-progression')['requested_information']
    end

    def self.srs_distribution
        get('srs-distribution')['requested_information']
    end

    def self.recent_unlocks(limit = 10)
        get('recent-unlocks', limit.to_s)['requested_information']
    end

    def self.critical_items(threshold = 75)
        get('critical-items', threshold.to_s)['requested_information']
    end

    def self.radicals_list(levels = [])
        tmp = []
        get('radicals', levels.join(','))['requested_information'].each do |elem|
            tmp << JSymbol.new('radical', elem)
        end
        tmp
    end

    def self.kanji_list(levels = [])
        tmp = []
        get('kanji', levels.join(','))['requested_information'].each do |elem|
            tmp << JSymbol.new('kanji', elem)
        end
        tmp
    end

    def self.vocabulary_list(levels = [])
        tmp = []
        get('vocabulary', levels.join(','))['requested_information']['general'].each do |elem|
            tmp << JSymbol.new('vocabulary', elem)
        end
        tmp
    end

    def self.all_items_list(levels = [])
        (radicals_list + kanji_list) + vocabulary_list
    end

    def self.up_next
        tmp = all_items_list

        tmp.select! { |x| !x.AVAILABLE_DATE.nil? }
        tmp.each { |x| puts x }

        tmp.sort_by! { |x| x.AVAILABLE_DATE }

        tmp.map! do |x|
            { "type"      => "#{x.TYPE}",
              "next_at"   => "#{Time.at x.AVAILABLE_DATE}",
              "character" => x.CHARACTER,
              "meaning"   => x.MEANING
            }
        end

        tmp.reverse!
    end
end


WaniKani.keyfile('api_key.txt')

methods = {
    "user"     => -> { WaniKani.user_information },
    "queue"    => -> { WaniKani.study_queue },
    "lvl"      => -> { WaniKani.level_progression },
    "srs"      => -> { WaniKani.srs_distribution },
    "unlocks"  => -> { WaniKani.recent_unlocks },
    "critical" => -> { WaniKani.critical_items },
    "radicals" => -> { WaniKani.radicals_list },
    "kanji"    => -> { WaniKani.kanji_list },
    "vocab"    => -> { WaniKani.vocabulary_list },
    "all"      => -> { WaniKani.all_items_list },
    "next"     => -> { WaniKani.up_next }
}

loop do
    print "What to get?\n> "
    exit 0 unless what = $stdin.gets

    what = what.chomp

    if what == "quit"
        break
    elsif what == "help"
        methods.each { |key, _| puts "#{key}" }
    elsif methods.key? what
        result = methods[what].call
        puts JSON.pretty_generate result
    end
end

