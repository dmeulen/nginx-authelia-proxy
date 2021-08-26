# Nginx authelia reverse proxy

This is a reverse proxy based on nginx. It uses [authelia](https://www.authelia.com/docs/) as authentication and authorization server. Authelia supports SSO and 2FA, uses LDAP as authentication backend. Most of all authelia is very easy to set up!

This reverse proxy uses a LUA script to lookup services and ports in consul ( thank you [ygersie](https://github.com/ygersie/nginx-ldap-auth) and [vlipco](https://github.com/vlipco/srv-router)).

## Configuration

Configuration is entirely done with environment variables.

Env var | Description | Example value | Default value
--- | --- | --- | ---
`SERVER_NAME` | Sets the server_name value nginx will listen to. REQUIRED | `service.example.com` | `None`
`BACKEND_SERVICE` | The consul service name to be used as upstream. REQUIRED | `http.consul.service.conul` | `None`
`AUTHELIA_URL` | The authelia backend url. REQUIRED | `https://authelia.example.com` | `None`
