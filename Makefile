.PHONY: run_test

all: run_test

run_test: test
	./test && echo "test passed"

test: nn.hpp test_nn.cpp
	/opt/homebrew/opt/llvm/bin/clang++ -stdlib=libc++ -std=c++20 test_nn.cpp -o test

clean:
	rm ./test
