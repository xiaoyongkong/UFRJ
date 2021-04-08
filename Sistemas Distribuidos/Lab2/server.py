#!/bin/python3
import argparse
import logging

from util import parseArguments, setupLogging
from socket import socket, AF_INET, SOCK_STREAM
from fileReader import readFile

def formatDict(dictionary):
    logging.debug('Formatting payload response')
    formattedDict = ""
    for word in dictionary:
        formattedDict += f'{word}: {dictionary[word]}\n'
    return formattedDict

def topOccurrences(dictionary, N):
    """ Returns top N occurrences of words in `dictionary` """
    logging.debug(f'Selecting top {N} words ordered by occurrences')
    return {k: v for k, v in sorted(dictionary.items(),
        key=lambda item: item[1], reverse=True)[:N]}


def parseContent(wordCounter, content):
    """ Returns updated wordCounter using fileContent """
    # read every line
    for line in content:
        # and every word in them
        for word in line.split():
            if word in wordCounter:
                # if word is already in dictionary, add 1
                wordCounter[word] += 1
            else:
                # if word is *not* in dictionary, first occurrence
                wordCounter[word] = 1
    return wordCounter

def countWords(filesString, N=10):
    """ Returns formatted string of top N word occurences in specified files """
    # split using whitespace as separator
    files = filesString.split()

    # using dictionary mapping word to occurrences
    wordCounter = {}

    # iterate through every file specified
    for file in files:
        try:
            # read content of file
            logging.debug(f'Trying to read content of {file}')
            content = readFile(file)
        except Exception as e:
            return str(e)

        logging.debug('Parsing content')
        wordCounter = parseContent(wordCounter, content)

    wordCounter = topOccurrences(wordCounter, N)
    return formatDict(wordCounter)


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

    # set timeout to 30 seconds
    sock.settimeout(30)

    # keep socket descriptor open as long as server receives new connections
    while True:
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

            # count words
            logging.info('Begin counting words')
            wordCountPayload = countWords(decodedResponse)
            logging.info('Finished counting words')

            # add 20 equals signs to denote end of server response
            payload = wordCountPayload + '='*20

            # byte encode payload
            payload = payload.encode('utf-8')

            # send payload to the client
            logging.info('Sending payload back to client')
            cSock.send(payload)

        logging.info('Empty response received, closing connection')

        # close client socket descriptor
        cSock.close()

    # close server socket descriptor
    sock.close()

    logging.info('All connections closed, shutting down server')

if __name__ == '__main__':
    serve()