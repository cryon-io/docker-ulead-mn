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


GIT_INFO=$(curl -sL "https://api.github.com/repos/uleadapp/ulead/releases/latest")                            
URL=$(printf "%s\n" "$GIT_INFO" | jq .assets[].browser_download_url -r | grep linux | grep x86_64)                         

if [ -f "./limits.conf" ]; then 
    if grep "NODE_VERSION=" "./limits.conf"; then 
        NODE_BINARY=$(grep "NODE_VERSION=" "./limits.conf" | sed 's/NODE_VERSION=//g')
        
        if curl --fail -sL "https://api.github.com/repos/uleadapp/ulead/releases/tags/$NODE_BINARY"; then
            GIT_INFO=$(curl -sL "https://api.github.com/repos/uleadapp/ulead/releases/tags/$NODE_BINARY")                                       
            URL=$(printf "%s\n" "$GIT_INFO" | jq .assets[].browser_download_url -r | grep linux | grep x86_64)                     
        elif [ -n "$NODE_BINARY" ] && [ ! "$NODE_BINARY" = "auto" ]; then
            URL=$NODE_BINARY
        fi
    fi
fi

FILE=ulead

case "$URL" in
    *.tar.gz) 
        curl -L "$URL" -o "./$FILE.tar.gz"
        tar -xzvf "./$FILE.tar.gz"
        md5sum "./$FILE.tar.gz" | awk '{ print $1 }' > node.hash
        rm -f "./$FILE.tar.gz"
    ;;
    *.zip)
        curl -L "$URL" -o "./$FILE.zip"
        unzip "./$FILE.zip"
        md5sum "./$FILE.zip" | awk '{ print $1 }' > node.hash
        rm -f "./$FILE.zip"
    ;;
esac

cp -f "$(find . -name uleadd)" . 2>/dev/null
cp -f "$(find . -name ulead-cli)" . 2>/dev/null

printf "%s" "$(printf "%s" "$GIT_INFO" | jq .tag_name -r | sed 's\v\\')" > ./version
exit 0