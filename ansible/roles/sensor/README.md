# sensor

Configures Abbey environmental sensor nodes for USB serial sensors.

The initial target is the Adafruit SHT41 Trinkey on `sensor01`. The role
installs Python serial support, grants the Abbey administrator access to serial
devices, and runs a resilient systemd logger.

The Trinkey emits four CSV fields: device serial number, temperature in Celsius,
relative humidity, and capacitive touch value. The logger records one sample per
minute in daily CSV files, maintains `latest.json`, and removes daily files older
than 30 days. It reconnects automatically if the USB device is removed.

Display the newest reading with:

```bash
abbey-sensor-latest
```

Inspect service status with:

```bash
systemctl status abbey-sht41
journalctl -u abbey-sht41
```
