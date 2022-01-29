.PHONY: clean run test

clean:
	rm -rf out
	rm -rf compiled
	rm -rf hynocli/compiled
	rm -rf hynocli/test/compiled

run: clean
	racket main.rkt

docs: clean
	rm -rf docs
	scribble --html +m --redirect-main http://docs.racket-lang.org/ --dest docs scribblings/index.scrbl

test:
	bash -c 'export HYNOCLI_APP=test; export HYNOCLI_TOKEN=test; raco test hynocli/test'
