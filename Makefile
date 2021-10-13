export SHELL := /bin/bash

.PHONY: test bench test-correctness test-performance test-thread-safety publish

test: test-correctness test-thread-safety

bench: test-performance

test-correctness:
	swift test -c debug --filter CorrectnessTests

test-performance:
	echo "" > benchmark.txt
	swift test -c release --filter PerformanceTests > >(tee -a benchmark.txt) 2> >(tee -a benchmark.txt >&2)
	grep -oE 'test.+?average: [0-9]+\.[0-9]+' benchmark.txt | sed -E "s/]?'.+av/ av/g"

test-thread-safety:
	swift test -c debug --filter ThreadSafetyTests --sanitize=thread

publish: test
	rm -rf .docs
	jazzy
	cp img/* .docs/img/
	swiftlint --strict
