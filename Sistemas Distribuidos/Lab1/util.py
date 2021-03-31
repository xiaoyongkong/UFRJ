import argparse
import logging

LOG_FORMAT = "[%(asctime)s | %(levelname)s]: %(message)s"

def setupLogging():
    logging.basicConfig(format=LOG_FORMAT, level=logging.DEBUG)

def parseArguments():
    parser = argparse.ArgumentParser(
        description='Basic echo server implementation')
    parser.add_argument('--host', type=str, default='localhost',
                        help='Host', dest='host')
    parser.add_argument('-P', '--port', type=int, default=5000,
                        help='Port', dest='port')

    args = parser.parse_args()
    host = args.host
    port = args.port

    return host, port
