#include "hello/hello.hpp"

namespace hello {

// Sample implementation used by the template. Replace this logic with your
// project's actual behavior.
std::string greeting(const std::string& name) {
  if (name.empty()) {
    return "Hello, World!";
  }
  return "Hello, " + name + "!";
}

}  // namespace hello
