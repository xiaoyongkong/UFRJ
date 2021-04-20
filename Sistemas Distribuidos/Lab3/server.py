#!/bin/python3
import argparse
import logging

from util import parseArguments, setupLogging
from serverSocket import ServerSocket
from stdinWrapper import StdinWrapper

from select import select

def serve():
    setupLogging()
    listenerAddress = parseArguments()

    # setup server socket
    sock = ServerSocket(listenerAddress)
    stdin = StdinWrapper()

    # input entries
    readersDescriptors = [sock, stdin]
    writersDescriptors = []
    exceptionsDescriptors = []

    # clients created throughout the execution
    clients = []

    # keep socket descriptor open as long as it still receives new connections
    while True:
        # get descriptors ready for interaction
        readersReady, _, _ = select(readersDescriptors, writersDescriptors,
            exceptionsDescriptors)

        logging.debug(f'Descriptors ready for reading: {readersReady}')
        for reader in readersReady:
            clients, clientsClosed = reader.ready(clients)

        if clientsClosed:
            break

    # close server socket descriptor
    sock.close()

    logging.info('All connections closed, shutting down server')

if __name__ == '__main__':
    serve()