# SiriProxy-Hue
# https://github.com/interstateone/siriproxy-hue
# copyright 2013, Brandon Evans
# extended version and bug fixes, Christoph Weil
# Released under MIT License

# SiriProxy Plugin Requirements
require "cora"
require "siri_objects"
require "pp"

require "rest_client" # HTTP requests
require "json" # Parse Hue responses
require "matrix" # Color space transformations
require "hue-entity"

class SiriProxy::Plugin::Hue < SiriProxy::Plugin
    def initialize (config)
        @@bridgeIP = config['bridge_ip']
        @@username = config['username']
        @@registering = false
        @@registered = false
    end
    
    def checkRegistration
        if @@registered then return end
        
        url = "#{@@bridgeIP}/api/#{@@username}"
        response = RestClient.get(url)
        data = JSON.parse(response)
        if data.kind_of?(Array)
            data = data[0]
        end
        
        if data.has_key? "error"
            # Unregistered username
            @@registering = true
            response = ask "I just need to finish setting up: say \"Ready\" after you've pressed the link utton on your Hue bridge."
            if response =~ /ready/i
                url = "#{@@bridgeIP}/api"
                data = {devicetype: "siriproxy", username: "#{@@username}"}.to_json
                response = RestClient.post(url, data, content_type: :json)
                request_completed
                checkRegistration
            end
            else
            # Success
            if @@registering
                @@registering = false
                say "Thanks, you're ready to go."
                request_completed
                @@registered = true
                else
                @@registered = true
            end
        end
    end
    
    def parseNumbers (value)
        if (value =~ /%/)
            value = value.delete("%").to_i * 254 / 100 # 254 is max brightness value
        end
    end
    
    def is_numeric?(obj)
        obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end
    
    def ensureMatchedEntity(entity)
        begin
            matchedEntity = HueEntity.new(entity, @@bridgeIP, @@username)
            rescue ArgumentError
            say "I couldn't find any lights by that name."
            request_completed
            return
        end
        matchedEntity
    end
    
    
    def switchEntity(state, matchedEntity)
        if (state == "on")
            matchedEntity.power(true)
            else
            matchedEntity.power(false)
        end
        
        if matchedEntity.type == :group
            if matchedEntity.name == "all"
                say "I've turned #{state} all of the lights for you."
                else
                say "I've turned #{state} the #{matchedEntity.name} lights for you."
            end
            else
            say "I've turned #{state} the #{matchedEntity.name} light for you."
        end
        request_completed
    end
    
    def setRelativeBrightness(change, matchedEntity)
        currentBrightness = matchedEntity.brightness
        
        if (change == "up")
            newBrightness = currentBrightness + 50
            else
            newBrightness = currentBrightness - 50
        end
        matchedEntity.brightness(newBrightness)
        
        response = ask "Is that enough?"
        
        if (response =~ /yes/i)
            say "I'm happy to help."
            elsif (response =~ /more|no/i)
            if (change == "up")
                newBrightness += 50
                else
                newBrightness -= 50
            end
            matchedEntity.brightness(newBrightness)
            say "You're right, that does look better"
        end
        
        request_completed
    end
    
    def setAbsoluteBrightness(value, matchedEntity)
        numericValue = parseNumbers(value)
        if (is_numeric? numericValue)
            log numericValue
            matchedEntity.brightness(numericValue.to_i)
            else
            # query colourlovers for first rgb value from the given string
            url = "http://www.colourlovers.com/api/colors?keywords=#{value}&numResults=1&format=json"
            response = RestClient.get(url)
            data = JSON.parse(response)[0]["hsv"]
            matchedEntity.color(data["hue"])
        end
        
        say "There you go."
        request_completed
    end
    
    # Binary state
    listen_for %r/turn (on|off)(?: the)? ([a-z]*)/i do |state, entity|
    checkRegistration
    matchedEntity = ensureMatchedEntity(entity)
    switchEntity(state, matchedEntity)
end

# Relative brightness
listen_for %r/turn (up|down)(?: the)? ([a-z]*)/i do |change, entity|
    checkRegistration
    matchedEntity = ensureMatchedEntity(entity)
    setRelativeBrightness(change, matchedEntity)
end

# Absolute brightness/color change
#   Numbers (0-254) and percentages (0-100) are treated as brightness values
#   Single words are used as a color query to lookup HSV values
listen_for %r/set(?: the)? ([a-z]*) to ([a-z0-9%]*)/i do |entity, value|
    checkRegistration
    matchedEntity = ensureMatchedEntity(entity)
    setAbsoluteBrightness(value, matchedEntity)
end

# TODO Scenes
listen_for %r/make it look like a (.+)/i do |scene|
    checkRegistration
    # pull n colors, where n is the number of lights
    # set each light to color[i]
    request_completed
end
end
