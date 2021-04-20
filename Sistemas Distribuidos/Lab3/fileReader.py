from util import colors

def readFile(filename):
    """ Read file and returns its content as a list """
    try:
        with open(filename, 'r') as f:
            return f.readlines()
    except FileNotFoundError:
        raise Exception(f"{colors.FAIL}Arquivo {filename} não encontrado.{colors.ENDC}\n")
