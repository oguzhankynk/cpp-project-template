hello {#mainpage}
=====

A minimal example library this template builds, tests, and documents, meant
to be replaced by your own project's code. See the top-level `README.md` for
what this template wires up and how to use each quality gate.

@code
#include <hello/hello.hpp>
#include <iostream>

int main() {
  std::cout << hello::greeting("World") << "\n";
}
@endcode
