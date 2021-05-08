import socket
import re
import json
import select
import sys
import threading

HOST = ""
PORT = 5001

entradas = [sys.stdin]
conexoes = {}
clisocks = {}
lock = threading.Lock()
finalizando = False

def createServer():
  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  sock.bind((HOST, PORT))
  sock.listen(5)
  sock.setblocking(False)
  entradas.append(sock)
  return sock

available_ids = list(range(1, 51))

def getNewId():
  return available_ids.pop(0)

def releaseId(id):
  available_ids.append(id)

def acceptConnection(sock):
  clisock, addr = sock.accept()
  lock.acquire()
  new_id = getNewId()
  conexoes[clisock] = {
    "addr": addr,
    "id": new_id
  }
  clisocks[new_id] = clisock
  lock.release()
  users = [u["id"] for u in list(conexoes.values())]
  clisock.send(str.encode(f"{new_id},{users}"))

  print(f"{new_id} entrou - {str(addr)}")
  tellEveryoneText("new", new_id)
  return clisock, addr

def getUserList():
  return [u["id"] for u in list(conexoes.values())]

def handleClient(novo_sock, addr):
  client_id = conexoes[novo_sock]["id"]
  while True:
    # Recebe mensagem do lado 'ativo'
    # Argumento indica tamanho máximo, em bytes, a ser lido
    msg = novo_sock.recv(1024)
    if not msg:
      lock.acquire()
      releaseId(client_id)
      del conexoes[novo_sock]
      del clisocks[client_id]
      lock.release()
      novo_sock.close()
      print(f"{client_id} saiu")
      tellEveryoneText("out", client_id)
      return

    msg = str(msg, encoding="utf-8")
    print(msg)
    spl = msg.split(",{")
    indicated_length = int(spl[0])
    str_json = "{" + spl[1]
    while indicated_length - len(str_json) > 0:
      str_json = str_json + str(novo_sock.recv(1024), encoding="utf-8")

    parsed = json.loads(str_json)
    text = parsed["text"]
    to = int(parsed["to"])
    fro = int(parsed["id"])

    if to != 0:
      if to in clisocks:
        print(f"{client_id} -> {to}: {text}")
        clisocks[to].send(str.encode(f"{indicated_length},{str_json}"))
      else:
        print(f"User {to} doesn't exist")
    else:
      if parsed["type"] == "cmd":
        if text == "/hist":
          users = getUserList()
          ret_json = json.dumps({
            "id": 0,
            "to": fro,
            "type": "cmd",
            "cmd": text,
            "text": f"Open Connections ({len(users)}):\n\t{str(users)}"
          })
          clisocks[fro].send(str.encode(f"{len(ret_json)},{ret_json}"))
      else:
        print(f"{client_id} -> Server: {text}")
        tellEveryoneJSON(str_json)
  print("Connection terminated on the active side")

def tellEveryoneText(type,text):
  for i,id in enumerate(clisocks):
    envelope = json.dumps({
      "id": 0,
      "to": id,
      "type": type,
      "text": text
    })
    clisocks[id].send(str.encode(f"{len(envelope)},{envelope}"))

def tellEveryoneJSON(str_json):
  for i,id in enumerate(clisocks):
    clisocks[id].send(str.encode(f"{len(str_json)},{str_json}"))

def printActiveConnections():
  print(f"Open Connections ({len(conexoes.values())}):\n\t{str(list(conexoes.values()))}")

def processCommand(cmd,sock):
  if cmd == "exit":
    if not conexoes:
      sock.close()
      sys.exit()
    else:
      print("There are still active connections!")
      printActiveConnections()
  elif cmd == "hist":
    printActiveConnections()
  elif cmd == "wids":
    print(f"Availables IDs ({len(available_ids)}):\n\t",end="")
    print(available_ids)
  elif cmd == "help":
    printHelp()

def printHelp():
  print("Comandos:")
  print("\texit\n\t\tCloses the server if there are no active connections")
  print("\thist\n\t\tList active connections")
  print("\twids\n\t\tList IDs still available to customers")
  print("\thelp\n\t\tPrint this list")

def openServer():
  print("Iniciando servidor")
  printHelp()
  print("-"*8)
  sock = createServer()
  while True:
    leitura, _, _ = select.select(entradas, [], [])
    for io_recebido in leitura:
      if io_recebido == sock:
        novo_sock, addr = acceptConnection(sock)
        cliente = threading.Thread(target=handleClient, args=(novo_sock,addr))
        cliente.start()
      elif io_recebido == sys.stdin:
        cmd = input()
        processCommand(cmd,sock)

if __name__ == "__main__":
  openServer()