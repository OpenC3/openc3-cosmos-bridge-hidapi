# encoding: ascii-8bit

# Copyright 2023 OpenC3, Inc.
# All Rights Reserved.
#
# This program is free software; you can modify and/or redistribute it
# under the terms of the GNU Affero General Public License
# as published by the Free Software Foundation; version 3 with
# attribution addendums as found in the LICENSE.txt
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# This file may also be used under the terms of a commercial license
# if purchased from OpenC3, Inc.

require 'openc3/streams/stream'
require 'openc3/config/config_parser'
require 'myhidapi'
require 'timeout'

module OpenC3
  class HidApiStream < Stream
    def initialize(vendor_id, product_id, serial_number = nil, read_size = 64, read_timeout = 5.0, read_delay = nil)
      @vendor_id = Integer(vendor_id)
      @product_id = Integer(product_id)
      @serial_number = ConfigParser.handle_nil(serial_number)
      @read_size = read_size.to_i
      if read_timeout
        @read_timeout_ms = read_timeout * 1000
      else
        @read_timeout_ms = nil
      end
      @read_delay = ConfigParser.handle_nil(read_delay)
      @read_delay = @read_delay.to_f if @read_delay
      @handle = nil
    end

    # Expected to return any amount of data on success, or a blank string on
    # closed/EOF, and may raise Timeout::Error, or other errors
    def read
      sleep(@read_delay) if @read_delay
      if @read_timeout_ms
        data = @handle.read_timeout(@read_size, @read_timeout_ms)
        raise Timeout::Error if data.nil? or data.length <= 0
        return data
      else
        data = @handle.read(@read_size)
        if data
          return data
        else
          return ""
        end
      end
    end

    # Expected to always return immediately with data if available or an empty string.
    # Should not raise errors
    def read_nonblock
      sleep(@read_delay) if @read_delay
      data = @handle.read_timeout(@read_size, 0)
      if data
        return data
      else
        return ""
      end
    end

    # Expected to write complete set of data.  May raise Timeout::Error
    # or other errors.
    #
    # @param data [String] Binary data to write to the stream
    def write(data)
      @handle.write(data)
    end

    # Connects the stream
    def connect
      devices = MyHIDAPI.enumerate @vendor_id, @product_id
      devices.each do |device|
        if !@serial_number or (@serial_number and device.serial_number == @serial_number)
          @handle = device.open
          raise "Failed to Open HIDAPI Device #{@vendor_id}:#{@product_id}:#{@serial_number}" unless @handle
          return
        end
      end
      raise "HIDAPI Device #{@vendor_id}:#{@product_id}:#{@serial_number} Not Found"
    end

    # @return [Boolean] true if connected or false otherwise
    def connected?
      if @handle
        return true
      else
        return false
      end
    end

    # Disconnects the stream
    # Note that streams are not designed to be reconnected and must be recreated
    def disconnect
      if connected?()
        # Note: There should probably be a close call - but myhidapi doesn't have one (yet)
        @handle = nil
      end
    end
  end # class Stream
end
