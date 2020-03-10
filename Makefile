export SHELL := /bin/bash

.PHONY: test bench test-correctness test-performance test-thread-safety generate-linuxmain publish

test: test-correctness test-thread-safety

bench: test-performance

test-correctness:
	HYPHENATION_TEST_TYPE=hyphenation swift test -c debug

test-performance:
	rm benchmark.txt
	HYPHENATION_TEST_TYPE=performance swift test -c release > >(tee -a benchmark.txt) 2> >(tee -a benchmark.txt >&2)
	grep -oE 'test.+?average: [0-9]+\.[0-9]+' benchmark.txt | sed -E "s/]?'.+av/ av/g"

test-thread-safety:
	HYPHENATION_TEST_TYPE=thread-safety swift test -c debug --sanitize=thread

generate-linuxmain:
	HYPHENATION_TEST_TYPE=hyphenation swift test --generate-linuxmain
	HYPHENATION_TEST_TYPE=preformance swift test --generate-linuxmain
	HYPHENATION_TEST_TYPE=thread-safety swift test --generate-linuxmain

publish: generate-linuxmain test
	rm -rf .docs
	jazzy
	cp img/* .docs/img/
	swiftlint --strict
