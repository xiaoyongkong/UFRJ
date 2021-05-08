import socket
import json
import select
import sys
from color import colors

HOST = "localhost"
PORT = 5001
config = {
  "dest_id": 0,
  "client_id": 0
}

entradas = [sys.stdin]


def printHelp():
  print(colors.fg.lightblue,"-"*10,colors.reset)
  print("Comandos:")
  print("\t/chat <id>\n\t\tStarts communicating with the specified id user")
  print(              "\t\tID = 0 refers to the server, i.e. all users")
  print(              "\t\tThe default channel is the server")
  print(              "\t\tEx.: /chat 0")
  print("\t/exit\n\t\tCloses the connection to the server")
  print("\t/help\n\t\tPrint help's list")
  print("\t/hist\n\t\tRequest the list of users for the server")
  print(colors.fg.lightblue,"-"*10,colors.reset)

def getServerFromId(id):
  if id == 0: return f"{colors.fg.purple}Server{colors.reset}"
  if id == config["client_id"]: return f"{colors.fg.cyan}Você{colors.reset}"
  return f"{colors.fg.lightblue}User {id}{colors.reset}"

def changeChat(id):
  try:
    config["dest_id"] = int(id)
    print(f"Canal modificado para '{getServerFromId(int(id))}'")
  except ValueError as verr:
    print(f"Valor '{id}' não é um ID válido :(")


# Receives a JSON and sends it through the socket
def sendMessage(sock,envelope):
  sock.send(str.encode(f"{len(envelope)},{envelope}"))


def processCommand(msg,sock):
  if msg == "/help":
    printHelp()
    return
  if msg[:5] == "/chat":
    changeChat(msg[5:].strip())
    return

  if msg == "/hist":
    sendMessage(sock,json.dumps({
      "id": config["client_id"],
      "to": 0,
      "type": "cmd",
      "text": msg
    }))
    return

  print(f"Unknown Commando '{msg}'")


def processText(msg,sock):
  if len(msg) == 0:
    return

  if msg[0] == '/':
    processCommand(msg,sock)
    return

  sendMessage(sock,json.dumps({
    "id": config["client_id"],
    "to": config["dest_id"],
    "type": "msg",
    "text": msg
  }))

  to = getServerFromId(config["dest_id"])
  fro = getServerFromId(config["client_id"])
  # Overwrite the previous line (i.e. the text the customer just entered)
  print("\033[1F",end="")
  print(f"[{to}] {fro}: {msg}")


def handleReceivedMessage(text):
  if not text: return True
  spl = text.split(",{")
  indicated_length = int(spl[0])
  str_json = "{" + spl[1]
  # If the JSON to be received is larger than 1024, we need to
  # several calls to recv () to read it in full
  while indicated_length - len(str_json) > 0:
    str_json = str_json + str(novo_sock.recv(1024), encoding="utf-8")

  cjson = json.loads(str_json)
  text = cjson["text"]
  to = getServerFromId(cjson["to"])
  fro = getServerFromId(cjson["id"])

  if cjson["type"] == "msg":
    # If the message is from the user himself, ignore
    if int(cjson["id"]) == config["client_id"]:
      return

    print(f"[{to}] {fro}: {text}")
  else:
    # User in
    if cjson["type"] == "new":
      print(f"{getServerFromId(int(text))} entrou")
    # User out
    elif cjson["type"] == "out":
      print(f"{getServerFromId(int(text))} saiu")
    elif cjson["type"] == "cmd":
      print(text)


def openClient():
  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  sock.connect((HOST, PORT))
  entradas.append(sock)
  printHelp()
  greeting = str(sock.recv(1024), encoding="utf-8")
  str_id = greeting.split(",")[0]
  new_id = int(str_id)
  config["client_id"] = new_id
  print(f"\nYour user's Id is #{colors.fg.cyan}{new_id}{colors.reset}")

  users = json.loads(greeting[(len(str_id)+1):])
  print(f"Open Connections ({len(users)}):  {users}")
  working_input = ""

  while True:
    current_server = getServerFromId(config["dest_id"])
    leitura, _, _ = select.select(entradas, [], [])
    for io_recebido in leitura:
      if io_recebido == sock:
        r = handleReceivedMessage(str(sock.recv(1024), encoding="utf-8"))
        if r: break
      elif io_recebido == sys.stdin:
        msg = input().strip()
        if msg == "/exit":
          break
        processText(msg,sock)
        continue
    else:
      continue
    break
  sock.close()
  
if __name__ == "__main__":
  openClient()