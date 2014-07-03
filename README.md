# SiriProxy-Hue #

[![Code Climate](https://codeclimate.com/github/interstateone/siriproxy-hue.png)](https://codeclimate.com/github/interstateone/siriproxy-hue)
[![Dependency Status](https://gemnasium.com/interstateone/siriproxy-hue.png)](https://gemnasium.com/interstateone/siriproxy-hue)

## This project has been deprecated

I no longer maintain or provide support for this project. It remains on GitHub as a record of the project and for any possible benefits to others. Apple has since announced the HomeKit framework which provides hardware and software developers first-party support, including Siri, for the sort of thing this project did. I would recommend looking into the possibilities that the HomeKit framework offers.

---

This is a SiriProxy plugin to control Philips Hue lights with Siri. It has been developed for and tested with jimmykane's [Three Little Pigs fork](https://github.com/jimmykane/The-Three-Little-Pigs-Siri-Proxy) of [SiriProxy](https://github.com/plamoni/SiriProxy), although the plugin APIs look very similar and for now it may work with both.

## Example Commands ##

- Turn off *all* the lights
- Turn on (the) *bedroom* light(s)
- Turn up (the) *kitchen* light(s)
- Set (the) *hallway* to *20%*
- Set (the) *bedroom* to *green*
- Set (the) *living room* to *love*
- Make it look like a *sunset* (not implemented yet)

## Setup ##

- Follow the setup instructions for [SiriProxy](https://github.com/jimmykane/The-Three-Little-Pigs-Siri-Proxy#set-up-instructions) if you haven't already, then copy SiriProxy-Hue into the plugins folder.
- Find out the IP address of your Hue bridge
- Add the plugin in the SiriProxy config.yml file, substituting your own information:

-       plugins:

          - name: 'Hue'
            path: "./plugins/siriproxy-hue"
            bridge_ip: "10.0.1.2"
            username: "JohnnyAppleseed"

- Run `siriproxy update`
- Run `rvmsudo bundle exec ./siriproxy-restarter`
- Say one of the commands above. The first time Siri will prompt you to press the link button on your Hue bridge.

## Support ##

I'm more than happy to look into issues with SiriProxy-Hue itself, but please respect that I won't be able to provide installation support for you.

## Credit ##

The API used with the Hue bridge has been sniffed by other people who deserve the credit.

  - http://rsmck.co.uk/hue
  - http://blog.ef.net/2012/11/02/philips-hue-api.html

Philips has since made it [publicly available](http://developers.meethue.com/).

There's also a ton of people who have put work into SiriProxy, thanks to them for making this possible.
