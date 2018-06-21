# README

Disclaimer: This is a personal project. Not intended to be used or installed
by others, but there are in fact some solutions that may look interesting if
you are building an Energy Monitor, if that is the case, feel free to use it
as you please.

## What is Mr.Wattson

Mr.Wattson is the name of my personal Energy Monitoring system. Is one of my
first and bigger experiments into the IoT field, and it helped me understand a
lot about working IoT projects. Alongside this API, there is also a Mobile App,
built in Ionic; custom hardware which uses IoT hardware from Particle.io; and
an IoT server also from Particle.io. I'm only releasing the API code for now.

## How does it work

![Monitor](https://s3-us-west-2.amazonaws.com/matisio/mrwattson/monitor-sd.jpg)

### Device & API

This is the device which is installed alongside your electrical panel, with
those blue sensors around the cables of the areas of the house/office you want
to monitor.

Internally, it has a [Photon chip](https://store.particle.io/collections/photon),
a printed circuit board, an antenna, and small button. The sensors have magnetic
pads that measure the amount of energy going through the cable (simplified
explanation =P). They send that data to the circuit board, and the Photon chip,
which has your WiFi configured, sends a string to the server similar to this:
`"d-1|666|666-2|123|321"`.

Every time the device detects a shift in the energy consumption superior to
10 watts, it sends that string of data, where the first number after the `d-` is
the `sensor_id`, and the 2 other numbers are `watts_before_the_shift`, and the
`watts_after_the_shift`. Also, it is possible that two or more sensors detect
shifts at the same time, in that case, the device sends both changes in the same
request, joining both strings with a '-'.

```
            another sensor another sensor
             \           / \          /
  d-1|180|400-2|1000|2000-3|3000|1000
    ^  ^   ^
    |  |   after_shift
    |  before_shift
    |
    sensor_id
```
In that example, sensor 1, detected a shift from *180w* to *400w*, then the
sensor 2 detected a shift from *1000w* to *2000w*, the sensor 3 detected a
shift from *3000w* to *1000w*, and the sensor 4, did not detect any changes.

Apart from that data, the Particle.io server also sent me metadata, like the
exact time the reading was made.

[services/reading_events_creator](https://github.com/matismasters/mrwattson-api-public/blob/master/app/services/reading_events_creator.rb)

[services/reading_event_data_param_splitter](https://github.com/matismasters/mrwattson-api-public/blob/master/app/services/reading_events_creator.rb)

There you can find part of the code that solves the parsing of that data, and
then creates the corresponding `ReadingEvents`. There were also other challenges and endpoints, for example, if the device loses connection, it sends a big chunk of data when connection comes back.

### Mobile App

![Mobile App screenshots](https://s3-us-west-2.amazonaws.com/matisio/mrwattson/mobile-app-sd.jpg)

With the `ReadingEvents` in place, now it was time for some fun. In the left
you can see a chart, and the latest reading from each sensor below. At the right
you can see the more advance data, reports of how much energy you consumed per
day, and if you click on those message, you can see a detailed version, with
the consumption by sensor.

I also developed an admin panel to create custom notifications, that were
triggered by SQL queries. One of those was to notify the user of continued
activity for 7 or more nights, in which case you might have an appliance not
working properly.

You can check those complex queries here if you like
[Complex queries here](https://github.com/matismasters/mrwattson-api-public/blob/master/queries.sql)

### Takeaway

It was an amazing experience, I have a few monitors working right now in a
production URL, with the latest version of the code, with all the extra
security and stuff.

IoT is a really exciting field, both for the software and the hardware involved. I took the time to use RSpec API Documentation, to have the API
well documented, and it really paid off. It was also my first time deploying Android and iOS apps with Ionic, all by myself, to be honest, it was pretty
straight forward, just web, and angular, and you got it.

Thanks for reading!

_Matías Verges_
