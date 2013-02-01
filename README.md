# Hue got me babe #

This is a SiriProxy plugin to control Philips Hue lights with Siri. It has been developed for and tested with jimmykane's [Three Little Pigs fork](https://github.com/jimmykane/The-Three-Little-Pigs-Siri-Proxy) of [SiriProxy](https://github.com/plamoni/SiriProxy), although the plugin APIs look very similar and for now it may work with both.

## Example Commands ##

- Turn off *all* the lights
- Turn on the *bedroom* light
- Turn up the *kitchen*
- Set the hallway to *20%*
- Set the bedroom to *green*
- Make it look like a *sunset* (not implemented yet)

## Setup ##

- Pick a username that you'll use to connect to your Hue device, and make a MD5 hash of it. You can either [google it](https://www.google.com/?q=md5+generator) or type `md5 -s *your username*` in a terminal. Save this hash for the next steps.
- Install [resty](https://github.com/micha/resty) or a similar tool to make HTTP requests. I'll let you go check out the instructions on that page, but it amounts to downloading resty with `curl` and then sourcing it with `source resty` so that you can use it.
- Press the link button on your Hue bridge.
- Make a POST HTTP request to http://*YourHueHubIP*/api with the data:
    `{"username": "YourMD5Hash", "devicetype": "SiriProxyHue"}`. Using resty I first set the base URL to this address with `resty http://10.0.1.16/api` and `POST  {"username": "YourMD5Hash", "devicetype": "SiriProxyHue"}` to send the request. You should get a response like `{"success":{"username":"YourMD5HashFromBefore"}}`
- Store this MD5 hash in the hueKey class variable in lib/siriproxy-hue.rb.
- Store the Hue's local IP address (that you used with resty) in the hueIP class variable in the same file.
- Follow the plugin install instructions from [SiriProxy](https://github.com/jimmykane/The-Three-Little-Pigs-Siri-Proxy/wiki/Plugin%20Developer%20Guide). I had some trouble until I made sure that libmysql-dev was also installed before I could `rake install` SiriProxy, so use your preferred package manager to do that if necessary.

## Credit ##

The API used with the Hue bridge has been sniffed by other people who deserve the credit.

  - http://rsmck.co.uk/hue
  - http://blog.ef.net/2012/11/02/philips-hue-api.html

There's also a ton of people who have put work into SiriProxy, thanks to them for making this possible.
