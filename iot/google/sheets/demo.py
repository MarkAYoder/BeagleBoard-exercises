#!/usr/bin/env python3
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START sheets_quickstart]
from __future__ import print_function
from googleapiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools
import time, sys

# If modifying these scopes, delete the file token.json.
SCOPES = 'https://www.googleapis.com/auth/spreadsheets'

# The ID and range of a sample spreadsheet.
SAMPLE_SPREADSHEET_ID = '1hGMHMLwiG3zEDM19zJehpLjTDbVi8LOjVKhD8R0dBO0'
SAMPLE_RANGE_NAME = 'A2'

def main():
    """Shows basic usage of the Sheets API.
    Prints values from a sample spreadsheet.
    """
    store = file.Storage('tokenPython.json')
    creds = store.get()
    if not creds or creds.invalid:
        flow = client.flow_from_clientsecrets('credentials.json', SCOPES)
        creds = tools.run_flow(flow, store)
    service = build('sheets', 'v4', http=creds.authorize(Http()))

    # Call the Sheets API
    SPREADSHEET_ID = '1hGMHMLwiG3zEDM19zJehpLjTDbVi8LOjVKhD8R0dBO0'
    RANGE_NAME = 'A2'
    values = [ [time.time()/60/60/24+ 25569 - 4/24, sys.argv[1], sys.argv[2]]]
    body = { 'values': values }
    result = service.spreadsheets().values().append(spreadsheetId=SPREADSHEET_ID,
                                                range=RANGE_NAME,
                                                #  How the input data should be interpreted.
                                                valueInputOption='USER_ENTERED',
                                                # How the input data should be inserted.
                                                # insertDataOption='INSERT_ROWS'
                                                body=body
                                                ).execute()
    
    values = result.get('values', [])
    print("%s" % values)

    # if not values:
    #     print('No data found.')
    # else:
    #     print('Name, Major:')
    #     for row in values:
    #         # Print columns A and E, which correspond to indices 0 and 4.
    #         print('%s, %s' % (row[0], row[4]))

if __name__ == '__main__':
    main()
# [END sheets_quickstart]
