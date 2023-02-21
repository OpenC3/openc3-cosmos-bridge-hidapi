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

require 'openc3/interfaces/stream_interface'
require 'openc3/config/config_parser'
require 'hid_api_stream'

module OpenC3
  # Provides a base class for interfaces that use the libhidapi
  class HidApiInterface < StreamInterface
    def initialize(vendor_id,
                   product_id,
                   serial_number = nil,
                   read_size = 64,
                   read_timeout = 5.0,
                   read_delay = nil,
                   protocol_type = nil,
                   *protocol_args)
      super(protocol_type, protocol_args)

      @vendor_id = Integer(vendor_id)
      @product_id = Integer(product_id)
      @serial_number = ConfigParser.handle_nil(serial_number)
      @read_size = read_size.to_i
      @read_timeout = read_timeout.to_f
      @read_delay = ConfigParser.handle_nil(read_delay)
      @read_delay = @read_delay.to_f if @read_delay
    end

    def connect
      @stream = HidApiStream.new(@vendor_id, @product_id, @serial_number, @read_size, @read_timeout, @read_delay)
      super()
    end
  end
end
