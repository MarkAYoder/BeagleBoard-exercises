# From: https://learn.adafruit.com/user-space-spi-tft-python-library-ili9341-2-8

# Wire as shown, EXCEPT:

# D/C goes to P9_26
# RESET goes to P9_27
# config-pin P9_26 gpio
# config-pin P9_27 gpio

# SPI0 config
config-pin P9_19 gpio
config-pin P9_20 gpio

# SPI_PORT 1 - Adafruit instructions
# config-pin P9_17 spi_cs
# config-pin P9_18 spi
# config-pin P9_22 spi_scl

# SPI_PORT 2
# CS   to P9_28
# MOSI to P9_30
# SCLK to P9_31
# config-pin P9_28 spi_cs
# config-pin P9_30 spi
# config-pin P9_31 spi_sclk

# SPI_PORT 0
config-pin P9_17 spi_cs     # CS
config-pin P9_18 spi        # MOSI
config-pin P9_22 spi_sclk   # SCLK

