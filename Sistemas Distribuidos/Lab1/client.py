#!/bin/python3
import argparse
import logging
import sys

from util import parseArguments
from socket import socket, AF_INET, SOCK_STREAM

def connect():
    address = parseArguments()

    # create socket descriptor
    sock = socket(AF_INET, SOCK_STREAM)
    # connect to server
    sock.connect(address)
    

    # keep reading until user presses CTRL + D
    for msg in sys.stdin:
        # remove trailing spaces
        msg = msg.strip()

        # byte encode message
        msg = msg.encode('utf-8')

        # send msg
        sock.send(msg)

        # receive response from server
        response = sock.recv(1024)

        # decode byte encoded message
        response = response.decode('utf-8')

        # print to the user
        print(response)

    sock.close()

if __name__ == '__main__':
    print('Type your message: ')
    connect()