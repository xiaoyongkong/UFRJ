import logging

from util import formatDict
from fileReader import readFile

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
            if word.lower() in wordCounter:
                # if word is already in dictionary, add 1
                wordCounter[word.lower()] += 1
            else:
                # if word is *not* in dictionary, first occurrence
                wordCounter[word.lower()] = 1
    return wordCounter

def countWords(filesString, N=10):
    """ Returns formatted string of top N word occurences in specified files """
    logging.info('Begin counting words')

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
    logging.info('Finished counting words')
    return formatDict(wordCounter)

