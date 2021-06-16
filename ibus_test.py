#!/usr/bin/python3

# Simple script to easy testing IBUS commands

import sys
import time
import threading
try:
  from gi.repository import GObject
except ImportError:
  import gobject as GObject
import ibus as ibus_

ibus = None

def on_ibus_ready():
    pass

def on_ibus_packet(packet):
    
    print(packet)

def main():
    global ibus

    ibus = ibus_.ibus_service(on_ibus_ready, on_ibus_packet)
    ibus.cmd = ibus_.IBUSCommands(ibus)
    
    ibus.main_thread = threading.Thread(target=ibus.start)
    ibus.main_thread.daemon = True
    ibus.main_thread.start()

    try:
        mainloop = GObject.MainLoop()
        mainloop.run()
    except KeyboardInterrupt:
        pass
    except:
        print("Unable to run the gobject main loop")
    
    print("")
    shutdown()
    sys.exit(0)

def shutdown():
    global ibus

    if ibus.main_thread.is_alive():
        print("Stopping IBUS main thread...")
        ibus.stop()

    print("Destroying IBUS service...")
    ibus.shutdown()
    
if __name__ == '__main__':
    main()