import socket
import select
import sys
import multiprocessing
import threading
import hashlib
import math

inputs = [ sys.stdin ]

nodes_proc = []
nodes_addr = []
node_count = 0
MAX_NODES = 150

clientes = {}

def main():
  # Pede para o usuário especificar tamanho do anel lógico
  n = -1
  while n < 0:
    print("Insira um valor para 'n': ", end="", flush=True)
    try:
      n = int(input())
    except ValueError:
      print("Por favor, somente utilize valores inteiros para n!")

  node_count = 2**n
  # Limita n para o intervalo [1,MAX_NODES]
  if node_count > MAX_NODES:
    print(f"Valor muito alto para n! (2^{n} = {node_count} nós)")
    return
  if n < 1:
    print(f"Valor muito baixo para n! (2^{n} = {node_count} nós)")
    return

  # Cria 2^n processos para formar o anel lógico
  current_port = 42000
  print(f"Criando {node_count} nós...")
  for i in range(node_count):
    # Cada node recebe via argumentos:
    # - Total de nós
    # - Seu ID (consecutivo)
    # - Sua porta distinta de outros processos (aqui também consecutiva)
    current_port = current_port + 1

    node = multiprocessing.Process(target=logicalNode, args=[node_count,i+1,current_port])
    node.start()
    # Salva referências a esse nó
    nodes_proc.append(node)
    nodes_addr.append(("",current_port))

  while True:
    # Espera por qualquer entrada de interesse
    r,w,e = select.select(inputs, [], [])
    # Trata todas as entradas prontas
    for ready in r:
      if ready == sys.stdin:
        # Depois de disparar os processos filhos, o programa principal deverá ficar
        # disponível para responder "consultas sobre os nós da tabela" e sua localização
        try:
          cmd = int(input())
        except ValueError:
          print("Por favor, use somente números para conferir IDs de nós!")
          continue
        if cmd > node_count or cmd < 1:
          print(f"Nó de número {cmd} não existe!")
          continue
        print(f"IP/porta do nó {cmd}: ('',{cmd+42000})")


def logicalNode(node_count, node_id, port):
  print(f"Criado node ID={node_id}, porta={port}")

  # Cria finger table do nó
  finger_table = []
  for i in range(int(math.log(node_count,2))):
    succ_id = node_id + 2**i
    if succ_id > node_count:
      succ_id = succ_id - node_count
    succ_port = (port - node_id) + succ_id
    succ = [succ_id, ("", succ_port)]
    finger_table.append(succ)

  def printFingerTable():
    print(f"Node {node_id}: [ ",end="")
    for i in range(len(finger_table)):
      print(f"{finger_table[i][0]} ",end="")
    print("]")
  printFingerTable()

  # Abre um socket para esse nó receber conexões
  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  sock.bind(("",port))
  sock.listen(5)
  sock.setblocking(False)

  node_inputs = [ sock ]
  open_socks = {}
  local_hashtable = {}

  def acceptConn(new_sock,addr):
    while True:
      data = new_sock.recv(1024)
      if not data:
        new_sock.close()
        break
      req = str(data, encoding="utf-8")
      print(f"Node {node_id}: Recebeu requisição: {req}")
      processCommand(req)

  def hashKey(key):
    original_hash = hashlib.sha1(key.encode()).hexdigest()
    return int(original_hash,16) % node_count + 1

  def processCommand(string):
    spl = string.split(",")
    search_id = spl[0]
    cmd = spl[1].split(" ")
    if cmd[0] == "insert" and len(cmd) >= 3:
      insertOrFind(search_id,cmd[1],cmd[2])
    elif cmd[0] == "find" and len(cmd) >= 2:
      insertOrFind(search_id,cmd[1])

  def insertOrFind(sid,key,value=""):
    hashed_key = ""
    if f"{key}".startswith("_"):
      hashed_key = int(key[1:])
    else:
      hashed_key = hashKey(key)
    print(f"Node {node_id}: (#{sid}) Buscando chave '{key}' (='{hashed_key}')")

    # Verifica se esse nó deve guardar a chave
    if int(hashed_key) == int(node_id):
      if len(value) > 0:
        print(f"Node {node_id}: (#{sid}) Guardando chave '{hashed_key}' na tabela local")
        local_hashtable[hashed_key] = value
      else:
        print(f"Node {node_id}: (#{sid}) Retornando vazio para o usuário")
        value = local_hashtable.get(hashed_key,"_null")
      sendToClient(f"{sid},{node_id} {value}")
    else:
      # Descobre para qual sucessor passar a chave
      prev_i = -1
      ABSURD = node_count*10
      prev_diff = ABSURD+1
      for i in range(len(finger_table)):
        diff = hashed_key - finger_table[i][0]
        if diff >= 0:
          if diff < prev_diff:
            prev_i = i
            prev_diff = diff
        elif (i == 0) or (prev_diff - ABSURD > 0 and abs(diff) > prev_diff - ABSURD):
          prev_i = i
          prev_diff = abs(diff) + ABSURD

      if prev_i == -1:
        sendToFingerTableIndex(sid,0,hashed_key,value)
      else:
        sendToFingerTableIndex(sid,prev_i,hashed_key,value)

  def sendToFingerTableIndex(sid,index,hashed_key,value):
    printFingerTable()
    print(f"Node {node_id}: (#{sid}) Enviando chave '{hashed_key}' para nó {finger_table[index][0]}")
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect(finger_table[index][1])
    sock.send(f"{sid},insert _{hashed_key} {value}".encode())
    sock.close()

  def sendToClient(message):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect(("",42000))
    sock.send(message.encode())
    sock.close()

  while True:
    r,w,e = select.select(node_inputs, [], [])
    for ready in r:
      if ready == sock:
        new_sock,addr = sock.accept()
        open_socks[new_sock] = addr
        cliente = threading.Thread(target=acceptConn, args=(new_sock,addr))
        cliente.start()

if __name__ == "__main__":
  main()