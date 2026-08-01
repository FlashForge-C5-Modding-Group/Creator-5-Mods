# Decouple "Cooling Fan" from "Auxiliary recirculation" fan for better Chamber Heater performance
Tutorial by ano.space

## Requirements:
[Root](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Written-Scripts/blob/main/Basic/Enable%20Root/README.md), and [Mainsail](https://github.com/FlashForge-C5-Modding-Group/Creator-5-Written-Scripts/blob/main/Basic/Enable%20Moonraker%20%26%20Mainsail/README.md)

### Tutorial:
Start by opening the Webui of the printer (put the printer's IP address into a web browser)

1: Go to "Machine" (Picture pending)
2: Go to `printer.macro.cfg`
3: Find the `[gcode_macro M106]` section (CTRL + F)
4: Replace the macro with the macro below
```
[gcode_macro M106]
gcode:
  {% if 'S' in params %}
    {% set speed = params['S']|float %}
  {% else %}
    {% set speed = 255.0|float%}
  {% endif %}
  {% if 'T' in params %}
    {% set index = params['T']|int %}
  {% endif %}
  {% if 'P' in params %}
    {% set index = params['P']|int %}
  {% endif %}
  {% set chamber_target = printer["heater_generic chamber_heater"].target|default(0.0)|float %}
  {% if index == 101 %}
      #SET_FAN_SPEED FAN=internal_fan SPEED={speed/255.0}
  {% elif index == 2 %}
      # always recirc
      SET_FAN_SPEED FAN=chamber_loop_fan SPEED={speed/255.0}
      # only use cooling fan if chamber heater is off
      SET_FAN_SPEED FAN=chamber_cool_fan SPEED={0.0 if chamber_target > 0 else speed/255.0}
  {% elif index == 3 %}
      # only use exhaust if chamber heater is off
      SET_FAN_SPEED FAN=chamber_fan SPEED={0.0 if chamber_target > 0 else speed/255.0}
  {% else %}
      SET_FAN_SPEED FAN=fanM106 SPEED={speed/255.0}
  {% endif %}
  ```

5: Save and reboot. Saving and reloading will cause the printer's UI to crash.
