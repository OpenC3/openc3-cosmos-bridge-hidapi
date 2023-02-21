# OpenC3 COSMOS HIDAPI Bridge

This bridge provides an interface for bridges to connect to HID device using libHIDAPI. https://github.com/libusb/hidapi
It currently uses a limited driver to the api called myhidapi, that works well on MacOS but may not work on
other OS. Let us know!

## Install and Run the Bridge

1. gem install openc3
1. Instill libhidapi and development headers for your operating system. (MacOS: brew install hidapi) See https://github.com/libusb/hidapi
1. gem install openc3-cosmos-bridge-hidapi
1. Update the next step with your specific settings
1. openc3cli bridgegem openc3-cosmos-bridge-hidapi router_port=2951 vendor_id=0x0000 product_id=0x0000 read_size=64

## Create and Install a Plugin

You will also need to create a COSMOS plugin that describes your target and connects to the bridge.

The INTERFACE section of your plugin will look something like this:

```
INTERFACE BRIDGE_INT tcpip_client_interface.rb host.docker.internal 2951 2951 10.0 nil PROTOCOL_NAME [Protocol Specific Parameters]
  MAP_TARGET MY_TARGET
```
