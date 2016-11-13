#!/usr/bin/python

import sys
import time
try:
  from gi.repository import GObject
except ImportError:
  import gobject as GObject
import bluetooth as bt_
import ibus as ibus_

bluetooth = None
ibus = None

def main():
    global bluetooth
    bluetooth = bt_.BluetoothService()
    global ibus
    ibus = ibus_.IBUSService()
    ibus.commands = ibus_.IBUSCommands()

    time.sleep(15)
    ibus.write_to_ibus("3f05000c4e01")
    #print(ibus.commands.generate_display_packet("Hello"))
    
    
    #bluetooth.reconnect()
    try:
        mainloop = GObject.MainLoop()
        mainloop.run()
    except KeyboardInterrupt:
        pass
    except:
        print("Unable to run the gobject main loop")
        
    bluetooth.shutdown()
    ibus.shutdown()
    sys.exit(0)


if __name__ == '__main__':
    main()