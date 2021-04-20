import logging

from socket import socket, AF_INET, SOCK_STREAM
from wordCounter import countWords
from threading import Thread

class ServerSocket:
    def __init__(self, address, maxConnnections=5):
        self._sock = self._initSocket(address, maxConnnections)

    def fileno(self):
        return self._sock.fileno()

    def close(self):
        self._sock.close()

    def ready(self, openClients):
        # spawn new process to handle new client connection
        client = Thread(target=self._handleNewClientConnection)
        client.start()

        openClients.append(client)
        return openClients, False

    def _initSocket(self, address, maxConnnections):
        # set up socket descriptor
        sock = socket(AF_INET, SOCK_STREAM)

        # bind connection to host and port given as parameters
        logging.debug(f'Binding connection on: {address}')
        sock.bind(address)

        # set up listener for new connections, max of 1 simultaneous connection
        logging.info('Listening...')
        sock.listen(maxConnnections)

        sock.setblocking(False)
        return sock

    def _handleNewClientConnection(self):
        """ Handles new connection from client """
        # accept new connections
        cSock, addr = self._sock.accept()
        logging.info(f'Accepted connection from: {addr}')

        # deal with information received from this connection
        while True:
            response = cSock.recv(1024)
            if not response:
                break

            # decode byte encoded response
            decodedResponse = response.decode('utf-8')
            logging.debug(f'Client sent: {decodedResponse}')

            # count words
            wordCountPayload = countWords(decodedResponse)

            # add 20 equals signs to denote the end of the server response
            payload = wordCountPayload + '='*20

            # byte encode payload
            payload = payload.encode('utf-8')

            # send payload to the client
            logging.info('Sending payload back to client')
            cSock.send(payload)

        logging.info('Empty response received, closing connection')

        # close client socket descriptor
        cSock.close()