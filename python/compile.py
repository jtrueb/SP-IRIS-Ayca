import os
import serial
from serial.tools import list_ports
import io
import time

from Serial_Scan import NGA_Config_Serial_Scan

'''
The class will identify which ports contain which piece of hardware
The Ardunio and MMC100 are both set to 38400 and will respond to the 1VER? command
Once connnected, will store information in a config_com_ports.txt file

'''

if __name__ == '__main__':
    config = NGA_Config_Serial_Scan()
