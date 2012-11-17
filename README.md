# Hue got me babe #

This is a SiriProxy plugin to control Philips Hue lights with Siri. It has been developed for and tested with jimmykane's [Three Little Pigs fork](https://github.com/jimmykane/The-Three-Little-Pigs-Siri-Proxy) of [SiriProxy](https://github.com/plamoni/SiriProxy), although the plugin APIs look very similar and for now it may work with both.

## Installation Notes ##

Follow the plugin install instructions from [SiriProxy](https://github.com/jimmykane/The-Three-Little-Pigs-Siri-Proxy/wiki/Plugin%20Developer%20Guide). I had some trouble until I made sure that libmysql-dev was also installed before I could `rake install` SiriProxy, so use your preferred package manager to do that if necessary.

## Example Commands ##

- Turn off *all* the lights
- Turn on the *bedroom* light
- Turn up the *kitchen*
- Set the hallway to *20%*
- Set the bedroom to *light blue* (colors not implemented yet)
- Make it look like a *sunset* (scenes not implemented yet)

## Initial setup ##

- Press the link button on your Hue bridge
- Make an HTTP request to http://YourHueHub/api with:
    {"username": "YourMD5Hash", "devicetype": "YourAppName"}
    I used [resty](https://github.com/micha/resty) for this.
- A valid request will return {"success":{"username":"YourMD5Hash"}}
- Store this MD5 hash in the hueKey class variable in lib/siriproxy-hue.rb
- Store the Hue's local IP address in the hueIP class variable
- Add the hue gem to the SiriProxy config file, run `siriproxy bundle` from it's directory and restart the server

## Credit ##

The API used with the Hue bridge has been sniffed by other people who deserve the credit.

  - http://rsmck.co.uk/hue
  - http://blog.ef.net/2012/11/02/philips-hue-api.html

There's also a ton of people who have put work into SiriProxy, thanks to them for making this possible.
