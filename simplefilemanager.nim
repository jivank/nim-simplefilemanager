import jester, asyncdispatch, htmlgen, json, sequtils, os, strutils, system, re, cgi

proc parts(path: string): seq[string] = path.split(DirSep)

var currentDir = getCurrentDir()

proc fileListing(path: string): untyped =    
  var links = ""
  var route = ""
  if path != currentDir:
    route = "/" & join(path.parts[0..path.parts.high],"/") & "/"
  for kind,fPath in walkDir(path,true):
    links &= a(href=route & fPath, fPath) & "\n"
  return html(pre(links))

routes:
  get re"^\/(.*)$":
    let match = decodeUrl(request.matches[0])
    jester.setStaticDir(request,currentDir)
    if match == "":
      resp fileListing(currentDir)
    cond existsDir(match)
    resp fileListing(match)
    
runForever()