export SHELL := /bin/bash

.PHONY: test bench test-correctness test-performance test-thread-safety publish

test: test-correctness test-thread-safety

bench: test-performance

test-correctness:
	HYPHENATION_TEST_TYPE=hyphenation swift test -c debug --enable-test-discovery

test-performance:
	echo "" > benchmark.txt
	HYPHENATION_TEST_TYPE=performance swift test -c release --enable-test-discovery > >(tee -a benchmark.txt) 2> >(tee -a benchmark.txt >&2)
	grep -oE 'test.+?average: [0-9]+\.[0-9]+' benchmark.txt | sed -E "s/]?'.+av/ av/g"

test-thread-safety:
	HYPHENATION_TEST_TYPE=thread-safety swift test -c debug --sanitize=thread --enable-test-discovery

publish: test
	rm -rf .docs
	jazzy
	cp img/* .docs/img/
	swiftlint --strict
