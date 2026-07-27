# sensor

Prepares Abbey environmental sensor nodes for USB serial sensors.

The initial target is the Adafruit SHT41 Trinkey on `sensor01`. The role
installs Python serial support, grants the Abbey administrator access to serial
devices, and creates stable application and data directories.

The reader and systemd service will be added after the physical device arrives
and its persistent device identity and emitted CSV format are verified.
