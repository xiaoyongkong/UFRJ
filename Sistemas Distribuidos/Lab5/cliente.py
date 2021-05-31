import socket
import sys
import select
import threading
from random import randrange as rand

inputs = [sys.stdin]
open_socks = {}

def main():
  cli_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  try:
    cli_sock.bind(("",42000))
  except OSError as e:
    raise
  cli_sock.listen(5)
  cli_sock.setblocking(False)
  inputs.append(cli_sock)

  printHelp()

  while True:
    # Espera por qualquer entrada de interesse
    r,w,e = select.select(inputs, [], [])
    # Trata todas as entradas prontas
    for ready in r:
      if ready == sys.stdin:
        processCommand(input())
      elif ready == cli_sock:
        new_sock,addr = cli_sock.accept()
        open_socks[new_sock] = addr
        cliente = threading.Thread(target=acceptConn, args=(new_sock,addr))
        cliente.start()

def printHelp():
  print("Comandos possíveis:")
  print("\tfind <ID nó origem> <chave>")
  print("\tinsert <ID nó origem> <chave> <valor>")
  print("\n\tExemplo:\n\tfind 3 banana\n\tinsert 3 banana 10\n\tfind 2 banana")

def acceptConn(new_sock,addr):
  while True:
    data = new_sock.recv(1024)
    if not data:
      new_sock.close()
      break
    spl = str(data, encoding="utf-8").split(",")
    search_id = spl[0]
    msg = spl[1].split(" ")
    print(f"Resposta da busca #{search_id}:\n\tID do Nó: {msg[0]}")
    if len(msg) > 1 and len(msg[1]) > 0:
      if msg[1] == "_null":
        print(f"\tValor: (vazio)")
      else:
        print(f"\tValor: {msg[1]}")

def processCommand(string):
  if string == "help":
    printHelp()
    return
  cmd = string.split(" ")
  if cmd[0] == "insert":
    if len(cmd) < 4:
      print("Uso:\n\tinsert [ID] [key] [value]")
    else:
      insert(cmd[1],cmd[2],cmd[3])
  elif cmd[0] == "find":
    if len(cmd) < 3:
      print("Uso:\n\tfind [ID] [key]")
    else:
      find(cmd[1],cmd[2])

def find(from_node_id, key):
  id_busca = rand(100)
  print(f"Enviada requisição para nó {from_node_id} (#{id_busca}): find {key}")
  sendTo(from_node_id,f"{id_busca},find {key}".encode())

def insert(from_node_id, key, value):
  id_busca = rand(100)
  print(f"Enviada requisição para nó {from_node_id}: (#{id_busca}) insert {key} {value}")
  sendTo(from_node_id,f"{id_busca},insert {key} {value}".encode())

def sendTo(from_node_id,message):
  node_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  node_sock.connect(("",42000+int(from_node_id)))
  node_sock.send(message)
  node_sock.close()

if __name__ == "__main__":
  main()