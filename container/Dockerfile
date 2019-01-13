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

FROM ubuntu:bionic

# setup dependencies
RUN apt-get update && apt-get upgrade -q -y
RUN apt-get install wget curl libjemalloc1 unzip jq -y

HEALTHCHECK --interval=5s --timeout=3s --start-period=30s --retries=5 \
  CMD curl -X POST --user "healthcheck:healthcheck" --url http://localhost:10000 \
                                        --header 'Cache-Control: no-cache' \
                                        --header 'Content-Type: application/json' \
                                        --data '{"jsonrpc":"2.0","id":"healthcheck","method":"getblockchaininfo","params":[]}' \
                                        --silent -k --fail || exit 1

# create user
RUN adduser --disabled-login \
         --disabled-password \
         --gecos "" \
         --uid 14000 \
         ulead

# copy necessary scripts
WORKDIR /home/ulead/
COPY get-node.sh ./get-node.sh
COPY get-node-info.sh ./get-node-info.sh
COPY get-version.sh ./get-version.sh
COPY limits.conf ./limits.conf

# set execution rights
RUN chmod +x ./get-node.sh ./get-node-info.sh ./get-version.sh

# get latest ulead binaries
RUN ./get-node.sh
RUN mv ./uleadd /usr/sbin/uleadd
RUN chmod +x /usr/sbin/uleadd ./ulead-cli

# run ulead masternode
USER ulead
ENTRYPOINT [ "/usr/sbin/uleadd" ]