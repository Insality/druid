--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  LuaSocket API documentation

  LuaSocket is a Lua extension library that provides
  support for the TCP and UDP transport layers. Defold provides the "socket" namespace in
  runtime, which contain the core C functionality. Additional LuaSocket support modules for
  SMTP, HTTP, FTP etc are not part of the core included, but can be easily added to a project
  and used.
  Note the included helper module "socket.lua" in "builtins/scripts/socket.lua". Require this
  module to add some additional functions and shortcuts to the namespace:
  require "builtins.scripts.socket"
  LuaSocket is Copyright © 2004-2007 Diego Nehab. All rights reserved.
  LuaSocket is free software, released under the MIT license (same license as the Lua core).
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.socket
socket = {}

---This constant contains the maximum number of sockets that the select function can handle.
socket._SETSIZE = nil

---This constant has a string describing the current LuaSocket version.
socket._VERSION = nil

---This function is a shortcut that creates and returns a TCP client object connected to a remote
---address at a given port. Optionally, the user can also specify the local address and port to
---bind (locaddr and locport), or restrict the socket family to "inet" or "inet6".
---Without specifying family to connect, whether a tcp or tcp6 connection is created depends on
---your system configuration.
---@param address string the address to connect to.
---@param port number the port to connect to.
---@param locaddr string|nil optional local address to bind to.
---@param locport number|nil optional local port to bind to.
---@param family string|nil optional socket family to use, "inet" or "inet6".
---@return socket_client|nil tcp_client a new IPv6 TCP client object, or nil in case of error.
---@return string|nil error the error message, or nil if no error occurred.
function socket.connect(address, port, locaddr, locport, family) end

---This function converts a host name to IPv4 or IPv6 address.
---The supplied address can be an IPv4 or IPv6 address or host name.
---The function returns a table with all information returned by the resolver:
---{
--- [1] = {
---    family = family-name-1,
---    addr = address-1
---  },
---  ...
---  [n] = {
---    family = family-name-n,
---    addr = address-n
---  }
---}
---Here, family contains the string "inet" for IPv4 addresses, and "inet6" for IPv6 addresses.
---In case of error, the function returns nil followed by an error message.
---@param address string a hostname or an IPv4 or IPv6 address.
---@return table|nil resolved a table with all information returned by the resolver, or if an error occurs, nil.
---@return string|nil error the error message, or nil if no error occurred.
function socket.dns.getaddrinfo(address) end

---Returns the standard host name for the machine as a string.
---@return string hostname the host name for the machine.
function socket.dns.gethostname() end

---This function converts an address to host name.
---The supplied address can be an IPv4 or IPv6 address or host name.
---The function returns a table with all information returned by the resolver:
---{
---  [1] = host-name-1,
---  ...
---  [n] = host-name-n,
---}
---@param address string a hostname or an IPv4 or IPv6 address.
---@return table|nil resolved a table with all information returned by the resolver, or if an error occurs, nil.
---@return string|nil error the error message, or nil if no error occurred.
function socket.dns.getnameinfo(address) end

---This function converts from an IPv4 address to host name.
---The address can be an IPv4 address or a host name.
---@param address string an IPv4 address or host name.
---@return string|nil hostname the canonic host name of the given address, or nil in case of an error.
---@return table|string resolved a table with all information returned by the resolver, or if an error occurs, the error message string.
function socket.dns.tohostname(address) end

---This function converts a host name to IPv4 address.
---The address can be an IP address or a host name.
---@param address string a hostname or an IP address.
---@return string|nil ip_address the first IP address found for the hostname, or nil in case of an error.
---@return table|string resolved a table with all information returned by the resolver, or if an error occurs, the error message string.
function socket.dns.toip(address) end

---Returns the time in seconds, relative to the system epoch (Unix epoch time since January 1, 1970 (UTC) or Windows file time since January 1, 1601 (UTC)).
---You should use the values returned by this function for relative measurements only.
---@return number seconds the number of seconds elapsed.
function socket.gettime() end

---This function creates and returns a clean try function that allows for cleanup before the exception is raised.
---The finalizer function will be called in protected mode (see protect).
---@param finalizer function a function that will be called before the try throws the exception.
---@return function try the customized try function.
function socket.newtry(finalizer) end

---Converts a function that throws exceptions into a safe function. This function only catches exceptions thrown by try functions. It does not catch normal Lua errors.
--- Beware that if your function performs some illegal operation that raises an error, the protected function will catch the error and return it as a string. This is because try functions uses errors as the mechanism to throw exceptions.
---@param func function a function that calls a try function (or assert, or error) to throw exceptions.
---@return fun(function) safe_func an equivalent function that instead of throwing exceptions, returns nil followed by an error message.
function socket.protect(func) end

---The function returns a list with the sockets ready for reading, a list with the sockets ready for writing and an error message. The error message is "timeout" if a timeout condition was met and nil otherwise. The returned tables are doubly keyed both by integers and also by the sockets themselves, to simplify the test if a specific socket has changed status.
---Recvt and sendt parameters can be empty tables or nil. Non-socket values (or values with non-numeric indices) in these arrays will be silently ignored.
---The returned tables are doubly keyed both by integers and also by the sockets themselves, to simplify the test if a specific socket has changed status.
--- This function can monitor a limited number of sockets, as defined by the constant socket._SETSIZE. This number may be as high as 1024 or as low as 64 by default, depending on the system. It is usually possible to change this at compile time. Invoking select with a larger number of sockets will raise an error.
--- A known bug in WinSock causes select to fail on non-blocking TCP sockets. The function may return a socket as writable even though the socket is not ready for sending.
--- Calling select with a server socket in the receive parameter before a call to accept does not guarantee accept will return immediately. Use the settimeout method or accept might block forever.
--- If you close a socket and pass it to select, it will be ignored.
---(Using select with non-socket objects: Any object that implements getfd and dirty can be used with select, allowing objects from other libraries to be used within a socket.select driven loop.)
---@param recvt table array with the sockets to test for characters available for reading.
---@param sendt table array with sockets that are watched to see if it is OK to immediately write on them.
---@param timeout number|nil the maximum amount of time (in seconds) to wait for a change in status. Nil, negative or omitted timeout value allows the function to block indefinitely.
---@return table sockets_r a list with the sockets ready for reading.
---@return table sockets_w a list with the sockets ready for writing.
---@return string|nil error an error message. "timeout" if a timeout condition was met, otherwise nil.
function socket.select(recvt, sendt, timeout) end

---This function drops a number of arguments and returns the remaining.
---It is useful to avoid creation of dummy variables:
---D is the number of arguments to drop. Ret1 to retN are the arguments.
---The function returns retD+1 to retN.
---@param d number the number of arguments to drop.
---@param ret1 any|nil argument 1.
---@param ret2 any|nil argument 2.
---@param retN any|nil argument N.
---@return any|nil retD+1 argument D+1.
---@return any|nil retD+2 argument D+2.
---@return any|nil retN argument N.
function socket.skip(d, ret1, ret2, retN) end

---Freezes the program execution during a given amount of time.
---@param time number the number of seconds to sleep for.
function socket.sleep(time) end

---Creates and returns an IPv4 TCP master object. A master object can be transformed into a server object with the method listen (after a call to bind) or into a client object with the method connect. The only other method supported by a master object is the close method.
---@return socket_master|nil tcp_master a new IPv4 TCP master object, or nil in case of error.
---@return string|nil error the error message, or nil if no error occurred.
function socket.tcp() end

---Creates and returns an IPv6 TCP master object. A master object can be transformed into a server object with the method listen (after a call to bind) or into a client object with the method connect. The only other method supported by a master object is the close method.
---Note: The TCP object returned will have the option "ipv6-v6only" set to true.
---@return socket_master|nil tcp_master a new IPv6 TCP master object, or nil in case of error.
---@return string|nil error the error message, or nil if no error occurred.
function socket.tcp6() end

---Creates and returns an unconnected IPv4 UDP object. Unconnected objects support the sendto, receive, receivefrom, getoption, getsockname, setoption, settimeout, setpeername, setsockname, and close methods. The setpeername method is used to connect the object.
---@return socket_unconnected|nil udp_unconnected a new unconnected IPv4 UDP object, or nil in case of error.
---@return string|nil error the error message, or nil if no error occurred.
function socket.udp() end

---Creates and returns an unconnected IPv6 UDP object. Unconnected objects support the sendto, receive, receivefrom, getoption, getsockname, setoption, settimeout, setpeername, setsockname, and close methods. The setpeername method is used to connect the object.
---Note: The UDP object returned will have the option "ipv6-v6only" set to true.
---@return socket_unconnected|nil udp_unconnected a new unconnected IPv6 UDP object, or nil in case of error.
---@return string|nil error the error message, or nil if no error occurred.
function socket.udp6() end



return socket