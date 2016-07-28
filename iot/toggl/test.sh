#!/bin/bash
# From: https://github.com/toggl/toggl_api_docs/blob/master/chapters/time_entries.md

if [ ! $TOGGL_API_KEY ]; then
    echo "Set TOGGL_API_KEY. Get apiToken at https://toggl.com/app/profile"
    exit
fi
curl -u $TOGGL_API_KEY:api_token -X GET https://www.toggl.com/api/v8/time_entries/current
echo
