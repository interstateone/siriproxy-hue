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
    result = lights.select { |light| light[:name].to_s.downcase == capturedString }
    result = result[0]

    if result.empty? then return false end

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

  def color (hue)
    url = "#{@bridgeIP}/api/#{@username}/lights/#{@number}/state"
    RestClient.put(url, {hue: 182*hue, sat: 254}.to_json, content_type: :json)
  end
end