#!/bin/python3
import argparse
import logging

from util import parseArguments, setupLogging
from socket import socket, AF_INET, SOCK_STREAM

def serve():
    setupLogging()
    listenerAddress = parseArguments()

    # set up socket descriptor
    sock = socket(AF_INET, SOCK_STREAM)

    # bind connection to host and port given as parameters
    logging.debug(f'Binding connection on: {listenerAddress}')
    sock.bind(listenerAddress)

    # set up listener for new connections, max of 1 simultaneous connection
    logging.info('Listening...')
    sock.listen(1)

    # accept new connections
    cSock, addr = sock.accept()
    logging.info(f'Accepted connection from: {addr}')

    # deal with information received from this connection
    while True:
        response = cSock.recv(1024)
        if not response:
            break

        # decode byte encoded response
        decodedResponse = response.decode('utf-8')
        logging.debug(f'Client sent: {decodedResponse}')
        
        # code to stop client socket
        if decodedResponse == 'exit':
            break

        # echo it back to the client
        cSock.send(response)

    logging.info('Empty response received, closing connection')

    # close client socket descriptor
    cSock.close()

    # close server socket descriptor
    sock.close()

    logging.info('All connections closed, shutting down server')

if __name__ == '__main__':
    serve()
