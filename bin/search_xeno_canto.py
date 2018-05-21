#!/usr/bin/env python3

'''
Code for searching the https://www.xeno-canto.org/ database with a query
and optionally downloading the recordings that match.
'''

import os
import re
import requests
from tqdm import tqdm


class XenoCantoRecord():

    def __init__(self, d):
        '''
        @param d: Dict
        '''
        self.d = d

        # Copy main attributes in the record
        self.gen = d.pop('gen', 'none')
        self.sp = d.pop('sp', 'none')
        self.id = d.pop('id', 'none')
        self.q = d.pop('q', 'none')
        self.type = d.pop('type', 'none').replace(' ', '-').replace(',', '')

        self.fileUrl = 'https:' + d['file']
        self.response = requests.get(self.fileUrl, stream=True)

        contentType = self.response.headers['Content-Type']
        self.audioFormat = contentType.split('/')[1]

        self.downloadFileName = '{}.{}'.format(self, self.audioFormat)

        if '/' in self.downloadFileName:
            raise Exception('Bad filename: {}'.format(self.downloadFileName))

    def __repr__(self):
        values = self.gen, self.sp, self.id, self.q, self.type
        return ' '.join(values)

    def __str__(self):
        values = self.gen, self.sp, self.id, self.q, self.type
        return '.'.join(values)

    def __len__(self):
        return int(self.response.headers['Content-Length'])

    def download(self, maxSize, directory, force=False):
        '''
        @param maxSize. Int. Only download if file is smaller than max size.
            (Number of bytes).
        @param force. Bool. Download file if it already exists.
        @param directory. Str. Directory to save file in.
        '''
        OK = self.response.status_code == 200
        fileSize = len(self)
        small = fileSize < maxSize

        if OK and small:

            path = os.path.join(directory, self.downloadFileName)
            downloadedAlready = os.path.exists(path)

            if force or not downloadedAlready:

                with open(path, 'wb') as handle:
                    for data in tqdm(self.response.iter_content()):
                        handle.write(data)

            elif downloadedAlready:
                raise Exception('{} downloaded already'.format(path))

        elif not small:
            raise Exception('{} too large ({} bytes)'.format(
                self.downloadFileName, fileSize))

        elif not OK:
            raise Exception('Request response for {} not OK'.format(
                self.fileUrl))


regex = re.compile('sp:[a-z]+', re.IGNORECASE)
def removeSp(query):
    '''
    Remove sp from query if one is specified. Return the query without the
    sp, and sp.

    This is useful because Xeno-canto queries cannot specify a species.

    @param query. Str. Xeno-canto query
    '''
    match = regex.search(query)
    
    if match:
        group = match.group()
        query = query.replace(group, '').rstrip().lstrip()
        sp = group.replace('sp:', '')

    else:
        sp = str()

    return query, sp

def xenoCantoQuery(query, download=False, forceDownload=False,
                   directory=None, maxSize=500000, maxNDownloads=100):
    '''
    @param query. Str. Xeno canto search query.
        See https://www.xeno-canto.org/help/search for details.
        Example: "gen: columba sp: palumbus q > : C"'
    @param download. Bool. Download matches.
    @param forceDownload. Bool. Download even if file already exists.
    @param directory. Str. Directory to save download in.
    @param maxSize. Int. Don't download if the file would be larger than
        maxSize bytes.
    '''
    # XC queries cannot contain species
    # Check sp manually later and only print / download if it matches
    # Separate sp from rest of query here with removeSp
    query, sp = removeSp(query)

    response = requests.get(
        url='http://www.xeno-canto.org/api/2/recordings',
        params=dict(query=query))

    OK = response.status_code == 200

    if OK:
        json = response.json()
        nDownloaded = 0
        nRecordings = int(json['numRecordings'])

        print('Found {} recordings'.format(nRecordings))

        for i, r in enumerate(json['recordings']):

            try:
                xcRecord = XenoCantoRecord(r)
            except Exception as err:
                print(err)
                print('Skipping...')
                continue

            if xcRecord.sp != sp:
                continue

            print('{}/{}: {}'.format(i + 1, nRecordings, xcRecord.__repr__()))

            if download:
                try:
                    xcRecord.download(
                        maxSize=maxSize,
                        directory=directory,
                        force=forceDownload)

                except Exception as err:
                    print(err)
                    print('Skipping...')
                    continue

                nDownloaded += 1

            if nDownloaded >= maxNDownloads:
                print('Reached maximum number of files to download.')
                break


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(
        description='Search for bird song recordings from '
        'https://www.xeno-canto.org that match a query.')
    
    parser.add_argument(
        '-q',
        '--query',
        help='Query. See https://www.xeno-canto.org/help/search for details. '
             'Example: "gen: columba sp: palumbus q > : C"',
        dest='query')
    
    parser.add_argument(
        '-d',
        '--download',
        help='Download records that match the query.',
        action='store_true',
        dest='download')
    
    parser.add_argument(
        '-m',
        '--max-file-size',
        help='Only download files smaller than max-file-size bytes.',
        type=int,
        dest='maxSize',
        default=500000)
    
    parser.add_argument(
        '-n',
        '--max-number-downloads',
        help='Maximum number of files to download.',
        type=int,
        dest='maxNDownloads',
        default=50)
    
    parser.add_argument(
        '-p',
        '--directory',
        help='Directory to save downloads.',
        dest='directory',
        default='downloads')
    args = parser.parse_args()

    xenoCantoQuery(
        query=args.query,
        download=args.download,
        directory=args.directory,
        maxSize=args.maxSize,
        maxNDownloads=args.maxNDownloads)
