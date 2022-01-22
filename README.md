hynocli
=======

An unofficial command-line client for the Hypernode API in Racket. For the official Hypernode-API client see the [hypernode-systemctl documentation](https://support.hypernode.com/en/hypernode/tools/how-to-use-the-hypernode-systemctl-cli-tool). This project is an unaffiliated implementation by me just to practice some Racket on the weekends out of personal interest. Hopefully if you are interested in talking to the Hypernode-API directly this could also be used as a helpful reference implementation.

## Documentation

Setting up the project:
```
$ sudo apt-get install racket
$ git clone https://github.com/vdloo/hynocli
$ cd hynocli
$ raco pkg install --deps search-auto
$ export HYNOCLI_TOKEN=your_api_token
$ export HYNOCLI_APP=your_app_name
$ racket main.rkt --help
```

Check out the full documentation on [https://vdloo.github.io/hynocli/](https://vdloo.github.io/hynocli/)
