#include "hello/hello.hpp"

#include <iostream>
#include <string>

int main(int argc, char** argv) {
  const std::string name = (argc > 1) ? argv[1] : "";
  std::cout << hello::greeting(name) << "\n";
  return 0;
}
