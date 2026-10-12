#ifndef HELLO_HELLO_HPP
#define HELLO_HELLO_HPP

#include <string>

/// @brief Sample library implementation used as the template baseline.
/// Replace this API with the real public interface of your project.
namespace hello {

/// @brief Builds a greeting for `name`.
/// @param name The name to greet; an empty string greets the world instead.
/// @return `"Hello, <name>!"`, or `"Hello, World!"` when `name` is empty.
/// @par Thread safety
/// Safe to call from any thread; takes no shared state.
std::string greeting(const std::string& name);

}  // namespace hello

#endif  // HELLO_HELLO_HPP
