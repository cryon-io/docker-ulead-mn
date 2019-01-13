#!/bin/sh

#  ULEAD Masternode docker template
#  Copyright © 2019 cryon.io
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#  Contact: cryi@tutanota.com

PATH_TO_SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname "$PATH_TO_SCRIPT")

if [ -f "$BASEDIR/../project_id" ]; then 
    PROJECT=$(sed 's/PROJECT=//g' "$BASEDIR/../project_id")
    PROJECT="--project-name $PROJECT"
fi 

get_latest_github_release() {
    GIT_INFO=$(curl -sL "https://api.github.com/repos/$1/releases/latest")                                       
    RESULT=$(printf "%s\n" "$GIT_INFO" | jq .assets[].browser_download_url -r | grep x86_64-linux)                         
} 

container=$(docker-compose -f "$BASEDIR/../docker-compose.yml" $PROJECT ps -q mn)
if [ -z "$container" ]; then 
    # masternode is not running
    exit 1
fi

current_ver=$(sh "$BASEDIR/node-info.sh")
get_latest_github_release "uleadapp/ulead"
# shellcheck disable=SC1003

ver=$(curl -Ls "$RESULT" | md5sum | awk '{ print $1 }')
if echo "$current_ver" | grep -q "HASH: $ver"; then
    exit 0
else
    docker-compose -f "$BASEDIR/../docker-compose.yml" $PROJECT build --no-cache && \
    docker-compose -f "$BASEDIR/../docker-compose.yml" $PROJECT up -d --force-recreate -t 120
    sleep 10
    current_ver=$(sh "$BASEDIR/node-info.sh")
    if echo "$current_ver" | grep -q "HASH: $ver" "$BASEDIR/data/node.info"; then
        exit 0
    else 
        # failed to update masternode
        exit 2
    fi
fi