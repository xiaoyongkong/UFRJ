import sys
import logging

class StdinWrapper:
    def __init__(self):
        self._stdin = sys.stdin

    def fileno(self):
        return self._stdin.fileno()

    def ready(self, openClients):
        """ Handles stdin entry """
        clientsClosed = False
        msg = self._stdin.readline()
        logging.debug(f'Read message from stdin: {msg.strip()}')
        if not msg:
            logging.debug(f'Waiting for open clients: {openClients}')

            # close remaining connections
            for client in openClients:
                client.join()

            logging.info('All clients closed')
            clientsClosed = True

        return openClients, clientsClosed