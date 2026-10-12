#ifndef HELLO_VERSION_HPP
#define HELLO_VERSION_HPP

/// @brief Minimal example library this template builds, tests, and documents.
namespace hello {

/// @brief Returns the library version as "MAJOR.MINOR.PATCH".
/// @return A pointer to a static, null-terminated string. Never null.
/// @par Thread safety
/// Safe to call from any thread; the returned string is immutable.
const char* version() noexcept;

}  // namespace hello

#endif  // HELLO_VERSION_HPP
