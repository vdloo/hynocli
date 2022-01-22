#lang scribble/manual

@title{hynocli: An unofficial command-line client for the Hypernode API in Racket}
@author{Rick van de Loo}

@section{Introduction}

A unofficial command-line client for the Hypernode API in Racket. For the official Hypernode-API client see the @hyperlink["https://support.hypernode.com/en/hypernode/tools/how-to-use-the-hypernode-systemctl-cli-tool"]{hypernode-systemctl documentation}. This project is an unaffiliated implementation by me just to practice some Racket on the weekends out of personal interest.

Hopefully if you are interested in talking to the Hypernode-API directly this could also be used as a helpful reference implementation. Check out the code @hyperlink["https://github.com/vdloo/hynocli"]{on github}.

@section{Installation}

To install @racket[hynocli] (on Debian) you can run the following:

@codeblock|{
$ sudo apt-get install racket
$ git clone https://github.com/vdloo/hynocli
$ cd hynocli
$ raco pkg install --deps search-auto
$ export HYNOCLI_TOKEN=your_api_token
$ export HYNOCLI_APP=your_app_name
$ racket main.rkt --help
}|

@section{Getting the API token}

Each Hypernode has an API token in @racket[/etc/hypernode/hypernode_api_token] that can be used to talk to @hyperlink["https://community.hypernode.io/#/Documentation/hypernode-api/README"]{the Hypernode API} to list information and configure certain settings for the Hypernode hosting environment to which that token belongs. That token is used by @racket[hypernode-systemctl] which is a command that is installed on every Hypernode but which is also available in the @hyperlink["https://github.com/byteinternet/hypernode-docker"]{hypernode-docker image}.

For example if you'd get the hypernode-api token from a real Hypernode as the @racket[app] user:
@codeblock|{
$ cat /etc/hypernode/hypernode_api_token 
<your_api_token>
}|

And then logged in into a local hypernode-docker container as root and placed that same API token there and updated the `common.json`:
@verbatim|{
# docker run docker.hypernode.com/byteinternet/hypernode-buster-docker:latest
$ ssh root@172.17.0.2
# echo "<your_api_token>" > /etc/hypernode/hypernode_api_token 
# jq '.tag = "<your_app_name>"' /etc/hypernode/common.json > /tmp/new_common.json
# mv /tmp/new_common.json /etc/hypernode/common.json
}|

Then you'd be able to use @racket[hypernode-systemctl] to talk to the Hypernode-API directly on behalf of your Hypernode, not from the actual Hypernode, but from your local environment instead:
@verbatim|{
# hypernode-systemctl settings php_version
php_version is set to value 8.1
}|

This project takes a similar approach: the hypernode-API token from a Hypernode is used to talk to the Hypernode-API directly. It does API-calls to @racket[api.hypernode.com] from a local client using the API token that you can find on a Hypernode to control that Hypernode.

@section{Development}

To run the unit tests you can run the following:
@codeblock|{
$ make test
}|

