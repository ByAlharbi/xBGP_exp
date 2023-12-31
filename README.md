# xBGP_exp



- **Build the Docker Image:**
    ```
    docker compose build && docker compose up
    ```
- **Plugin Files Location:**
  - The plugin files will be located at `/etc/bird/plugins` in the bird container.

- **Starting and Stopping BIRD:** 
  - To start or stop the BIRD service, use:
    ```
    /usr/bin/xproto bird [start|stop]
    ```
**Note**: BIRD is already running in the container, so there is no need to run it manually.


### xBGP Compliant BIRD
- [xBGP compliant BIRD on GitHub](https://github.com/pluginized-protocols/xbgp_bird/tree/xbgp_compliant)

### xBGP API
- [xBGP API on GitHub](https://github.com/pluginized-protocols/libxbgp)

### xBGP Plugins Examples
- [xBGP plugins examples on GitHub](https://github.com/pluginized-protocols/xbgp_plugins)

### xBGP Documentation
#### xBGP Plugin Examples
- [xBGP Plugin example](https://pluginized-protocols.org/xbgp/2020/11/29/xbgp-hello.html)
- [xBGP Plugin - another example](https://github.com/pluginized-protocols/xbgp_plugins/blob/master/docs/source/plugin.rst)

#### Additional Documentation
- [xBGP Plugins Documentation](https://github.com/pluginized-protocols/xbgp_plugins/tree/master/docs/source)
- [xBGP API Documentation](https://github.com/pluginized-protocols/libxbgp/tree/master/docs/source)
