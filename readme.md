## Docker ULEAD Masternode © cryon.io 2019

Docker template for ULEAD Masternode.


ULEAD Donations: `UYKAaZFM4gcv9msJREgEVgMwwcfJoVYBit`

[Quick Start Guide](https://github.com/cryon-io/docker-ulead-mn/wiki/Quickstart---ANS)

## Prerequisites 

1. 64-bit installation
2. 3.10 or higher version of the Linux kernel (latest is recommended)

(If you run on VPS provider, which uses OpenVZ, setup requires at OpenVZ 7)

## Setup ANS (AUTONOMOUS MASTERNODE SYSTEM - recommended)

1. - `git clone "https://github.com/cryon-io/ans.git" [path] && cd [path] && chmod +x ./ans` # replace path with directory you want to store node in
   or 
   - `wget https://github.com/cryon-io/ans/archive/master.zip && unzip -o master.zip && mv ./ans-master [path] && cd [path] && chmod +x ./ans`
2. one of commands below depending of your preference (run as *root* or use *sudo*)
    - `./ans --full --node=ULEAD_MN` # full setup of ULEAD MN for current user
    - `./ans --full --user=[user] --node=ULEAD_MN --auto-update-level=[level] -sp=ip=[external ip] -sp=nodeprivkey=[MN privkey]` 
        * full setup of ULEAD MN for defined user (directory location and structure is preserved) sets specified auto update level (Refer to Autoupdates)
        * Do not forget to set master node **external ip** and **privkey**. This is required only first time.
3.  logout, login and check node status
    - `./ans --node-info`

## Manual Setup (non ANS)

Recommended only for advance users. Guide - [Manual Setup](https://github.com/cryon-io/docker-ulead-mn/wiki/Manual-Setup).
