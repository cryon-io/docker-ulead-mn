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

ver=$(./get-version.sh)
type="ULEAD_MN"
mn_status=$(/home/ulead/ulead-cli -rpcuser=healthcheck -rpcpassword=healthcheck getmasternodestatus | jq .message)
hash=$(cat ./node.hash)
block_count="$(/home/ulead/ulead-cli getblockchaininfo | jq .blocks)"
sync_status="$(/home/ulead/ulead-cli mnsync status | jq .IsBlockchainSynced)"

printf "\
TYPE: %s \n\
VERSION: %s \n\
MN_STATUS: %s \n\
HASH: %s \n\
BLOCKS: %s \n\
SYNCED: %s \n\
" "$type" "$ver" "$mn_status" "$hash" "$block_count" "$sync_status"> /home/ulead/.ulead/node.info

printf "\
TYPE: %s \n\
VERSION: %s \n\
MN_STATUS: %s \n\
HASH: %s \n\
BLOCKS: %s \n\
SYNCED: %s \n\
" "$type" "$ver" "$mn_status" "$hash" "$block_count" "$sync_status"