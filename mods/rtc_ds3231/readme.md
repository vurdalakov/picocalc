# PicoCalc RTC mod with DS3231

### Connections

| DS3231 | Raspberry Pi Pico | Pin |
| ------ | ----------------- | --- |
| GND    | GND               |   8 |
| SDA    | GP6               |   9 |
| SCL    | GP7               |  10 |
| VCC    | 3V3(OUT)          |  36 |

### Initialization

1. Enable RTC in MMBasic:
    ```
    option rtc auto enable
    ```
1. Check that it succeeded:
    ```
    option list
    ```
1. Set current time (year, month, day, hour, minute, second):
    ```
    rtc settime 2025, 8, 14, 18, 25, 0
    ```
1. Check current time:
    ```
    print date$, time$
    ```

### Notes

* PicoMite User Manual: *"The command OPTION RTC AUTO ENABLE can also be used to set an automatic update of the TIME$ and DATE$ read only variables from the real time clock chip on boot and every hour."*
