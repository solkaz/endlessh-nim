import asyncnet, asyncdispatch, random, strformat

proc processClient(client: AsyncSocket) {.async.} =
  while true:
    # Use & instead of fmt to interpolate a random number
    # because fmt is a generalized raw string:
    # https://nim-lang.org/docs/strformat.html#fmt-vsdot-amp
    await client.send(&"{random.rand(65536)}\r\n")
    await sleepAsync(5000)

proc serve() {.async.} =
  var server = newAsyncSocket()
  server.setSockOpt(OptReuseAddr, true)
  server.bindAddr(Port(2222))
  server.listen()
  
  while true:
    asyncCheck processClient(await server.accept())

asyncCheck serve()
runForever()
