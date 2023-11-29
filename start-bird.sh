#!/bin/bash

# Start bird
/usr/bin/xproto bird start
# Stop bird
# /usr/bin/xproto bird stop
# Keep the container running
exec /bin/bash
