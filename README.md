# hello — a modern C++ project template

A minimal "hello world" C++17 library and CLI that exists to carry a
complete, working project setup: CMake presets, tests, docs, and every
quality gate wired up and verified. Replace `src/`, `include/`, and
`tests/` with your own project's code; the surrounding structure and
tooling need no changes to keep working.

## What's wired up

- **CMake presets** (`CMakePresets.json`) for debug, release, ASan/UBSan,
  TSan, coverage, clang-tidy, and cppcheck builds — each in its own
  `build/<preset>` directory.
- **Tests**: GoogleTest, fetched via `FetchContent`, with
  `gtest_discover_tests` wiring each `TEST()` into `ctest` individually.
- **Two static analyzers**: clang-tidy (`cmake/ClangTidy.cmake`,
  `.clang-tidy`) and cppcheck (`cmake/Cppcheck.cmake`), each toggled by its
  own CMake option and preset so they can run independently or together.
- **Sanitizers**: AddressSanitizer + UndefinedBehaviorSanitizer, and
  ThreadSanitizer, via `cmake/Sanitizers.cmake` and the `asan`/`tsan`
  presets.
- **Coverage**: `--coverage` instrumentation plus a `coverage` CMake target
  that runs the test suite and renders an HTML + XML report with gcovr,
  failing the build under configurable line/branch thresholds
  (`cmake/Coverage.cmake`).
- **Doxygen**: a `docs` target (HTML API reference) and a `docs-check`
  target that fails the build on any undocumented symbol or broken
  reference (`cmake/Doxygen.cmake`, `docs/Doxyfile.in`).
- **clang-format** (`.clang-format`) and **.editorconfig** for consistent
  formatting across editors.
- **Install + `find_package`**: the library installs and exports a CMake
  package (`helloConfig.cmake`) so `find_package(hello CONFIG REQUIRED)`
  works for consumers.
- **GitHub Actions CI** (`.github/workflows/ci.yml`) running every gate
  above on each push and pull request.
- **MIT license**.

## Quick example

```cpp
#include <hello/hello.hpp>
#include <iostream>

int main() {
  std::cout << hello::greeting("World") << "\n";  // Hello, World!
}
```

## Requirements

- A C++ compiler (GCC or Clang)
- CMake ≥ 3.25
- Ninja

## Building

```sh
cmake --preset debug
cmake --build --preset debug
ctest --preset debug
```

| Preset       | Purpose                                                      |
|--------------|----------------------------------------------------------------|
| `debug`      | Default development build.                                     |
| `release`    | Optimized build.                                                |
| `asan`       | AddressSanitizer + UndefinedBehaviorSanitizer.                 |
| `tsan`       | ThreadSanitizer.                                                |
| `coverage`   | Instrumented build; `--target coverage` runs tests and writes an HTML/XML gcovr report under `build/coverage/coverage/`. |
| `tidy`       | Builds with clang-tidy enabled on the `hello` target.           |
| `cppcheck`   | Builds with cppcheck enabled on the `hello` target.             |

Run every check in one go (format, tidy, cppcheck, docs, tests, sanitizers,
coverage, and an install/`find_package` smoke test):

```sh
./scripts/run_checks.sh
```

### Optional Git hooks

The repository includes opt-in hooks:

- `pre-commit` checks the formatting of staged `.cpp` and `.hpp` files with
  `clang-format`. It does not modify files.
- `pre-push` configures and builds the `debug` preset, then runs its tests.

Enable them for this local clone with:

```sh
git config core.hooksPath .githooks
```

Install `clang-format` before committing C++ changes. Hook checks also run in
CI where configured. To skip a hook for one command, use `git -c
core.hooksPath=/dev/null commit ...` or `git -c core.hooksPath=/dev/null push`.
The hooks are local convenience checks; CI remains the authoritative gate.

Useful CMake options (`-D<option>=<value>` with any preset):

| Option                     | Default                 | Effect                                  |
|-----------------------------|--------------------------|------------------------------------------|
| `BUILD_SHARED_LIBS`         | `OFF`                    | Build `hello` as a shared library.       |
| `HELLO_BUILD_TESTS`         | `ON` (top-level build)   | Build `tests/`.                          |
| `HELLO_BUILD_EXAMPLES`      | `ON` (top-level build)   | Build `examples/`.                       |
| `HELLO_BUILD_DOCS`          | `ON` if Doxygen is found | Enable the `docs` / `docs-check` targets.|
| `HELLO_ENABLE_CLANG_TIDY`   | `OFF`                    | Run clang-tidy as part of the build.     |
| `HELLO_ENABLE_CPPCHECK`     | `OFF`                    | Run cppcheck as part of the build.       |
| `HELLO_ENABLE_COVERAGE`     | `OFF`                    | Build with `--coverage` instrumentation. |
| `HELLO_SANITIZER`           | `""`                     | e.g. `address;undefined` or `thread`.    |
| `HELLO_WARNINGS_AS_ERRORS`  | `OFF`                    | Treat compiler warnings as errors.       |

```sh
# HTML API reference (requires Doxygen)
cmake --build --preset debug --target docs
# same inputs, but fails the build on any undocumented symbol or broken reference
cmake --build --preset debug --target docs-check
```

### Installing and consuming the library

```sh
cmake --install build/release --prefix /path/to/prefix
```

```cmake
find_package(hello CONFIG REQUIRED)
target_link_libraries(your_target PRIVATE hello::hello)
```

## Repository layout

```
include/hello/   public headers
src/             library implementation
tests/           unit tests
examples/        greet_cli, a tiny CLI built on the library
cmake/           CMake helper modules (warnings, sanitizers, coverage, clang-tidy, cppcheck, Doxygen)
scripts/         run_checks.sh
.githooks/       optional pre-commit and pre-push checks
docs/            Doxygen input and generated API reference
```

## Using this as a template

This repository is intentionally built as a starting point for a new C++
project. The `hello` library and `greet_cli` example are sample code, not
business logic. When you clone or fork this repo for a real project, the
recommended workflow is:

1. Replace the sample domain code: `src/hello.cpp`,
   `include/hello/hello.hpp`, and `tests/unit/test_hello.cpp`.
2. Rename the project and target names to match your project:
   - project name in `CMakeLists.txt`
   - target names in `src/CMakeLists.txt`
   - `hello_*` helper function prefixes in `cmake/*.cmake`
   - `HELLO_*` option names in `CMakeLists.txt` and helper modules
   - include directory name (`include/hello/`)
   - namespace name (`hello`) in the public API
3. Update the package metadata and install/export names so they match your
   project instead of the sample `hello` template.
4. Adjust the coverage thresholds in `cmake/Coverage.cmake` and the
   warning/check lists in `.clang-tidy` / `cmake/Cppcheck.cmake` to taste.
5. Keep the surrounding tooling in place: presets, tests, sanitizers, docs,
   CI, and install/export support.

### Recommended bootstrap checklist

Use this checklist the first time you turn the template into a real project:

- [ ] Rename the CMake project and target names
- [ ] Replace the sample namespace (`hello`) with your own domain namespace
- [ ] Replace sample library symbols and tests with real business logic
- [ ] Update README examples and package names
- [ ] Review compiler warnings and analyzer rules
- [ ] Confirm the `debug`/`release` preset flow works for your project
- [ ] Add project-specific CI steps if needed
- [ ] Decide whether to keep the example CLI or remove it

### Typical new-project workflow

```sh
# 1) clone this template
# 2) rename the project metadata and target names
# 3) replace the sample code under src/, include/, and tests/
# 4) run the project checks

cmake --preset debug
cmake --build --preset debug
ctest --preset debug --output-on-failure
```

The rest of the repository — presets, docs generation, static analyzers,
coverage, sanitizers, install/export support, and CI wiring — is meant to
stay stable while you swap in your actual application code.

## License

MIT — see [LICENSE](LICENSE).
