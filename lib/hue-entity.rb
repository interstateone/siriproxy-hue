class HueEntity
    attr_accessor :type
    attr_accessor :name
    attr_accessor :number
    attr_writer :bridgeIP
    attr_writer :username
    
    def initialize (capturedString, bridgeIP, username)
        @bridgeIP = bridgeIP
        @username = username
        response = RestClient.get("#{@bridgeIP}/api/#{@username}")
        data = JSON.parse(response)
        lights = data["lights"].map do |key, light|
            {type: :light, name: light["name"].to_s, number: key.to_i}
        end
        lights.push({type: :group, name: "all", number: 0})
        result = lights.select { |light| light[:name].to_s.downcase.eql?(capturedString) }
        result = result[0]
        
        if result.nil? then raise ArgumentError end
        
        @type = result[:type]
        @number = result[:number]
        @name = result[:name]
    end
    
    def power (value)
        if self.type == :group
            url = "#{@bridgeIP}/api/#{@username}/groups/#{@number}/action"
            else
            url = "#{@bridgeIP}/api/#{@username}/lights/#{@number}/state"
        end
        RestClient.put(url, {on: value}.to_json, content_type: :json)
    end
    
    def brightness (*args)
        if args.size < 1
            url = "#{@bridgeIP}/api/#{@username}/lights/#{@number}"
            response = RestClient.get(url)
            data = JSON.parse(response)
            brightness = data["state"]["bri"].to_i
            return brightness
            elsif args.size == 1
            value = args[0]
            if (value > 254) then value = 254
                elsif (value < 0) then value = 0
            end
            url = "#{@bridgeIP}/api/#{@username}/lights/#{@number}/state"
            RestClient.put(url, {:bri => value}.to_json, content_type: :json)
        end
    end
    
    def color (red, green, blue, saturation)
        calcX = (1.076450 * red.to_i) - (0.237662 * green.to_i) + (0.161212 * blue.to_i)
        calcY = (0.410964 * red.to_i) + (0.554342 * green.to_i) + (0.034694 * blue.to_i)
        calcZ = (-0.010954 * red.to_i) - (0.013389 * green.to_i) + (1.024343 * blue.to_i)
        x = calcX/(calcX + calcY + calcZ)
        y = calcY/(calcX + calcY + calcZ)
        url = "#{@bridgeIP}/api/#{@username}/lights/#{@number}/state"
        RestClient.put(url, {xy: [x,y], sat: (saturation*2.54).to_i}.to_json, content_type: :json)
    end
end