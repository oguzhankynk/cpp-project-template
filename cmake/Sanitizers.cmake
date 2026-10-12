include_guard(GLOBAL)

## hello_enable_sanitizers(<target>)
#
# Applies the sanitizers listed in HELLO_SANITIZER (semicolon-separated,
# e.g. "address;undefined" or "thread") to <target>. A no-op when the
# variable is empty. See the "asan"/"tsan" presets.
function(hello_enable_sanitizers target)
  if(NOT HELLO_SANITIZER)
    return()
  endif()

  if(NOT (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
    message(WARNING "HELLO_SANITIZER is set but ${CMAKE_CXX_COMPILER_ID} is not GCC/Clang; ignoring.")
    return()
  endif()

  list(JOIN HELLO_SANITIZER "," sanitizer_csv)
  set(flags -fsanitize=${sanitizer_csv} -fno-omit-frame-pointer)
  if(NOT "thread" IN_LIST HELLO_SANITIZER)
    list(APPEND flags -fno-sanitize-recover=all)
  endif()

  target_compile_options(${target} PUBLIC ${flags})
  target_link_options(${target} PUBLIC ${flags})
endfunction()

## hello_apply_sanitizer_test_wrapper(<target>)
#
# ThreadSanitizer needs a specific virtual-memory layout and aborts with
# "unexpected memory mapping" under some kernels' default ASLR behavior
# (observed under WSL2; `setarch -R <binary>` reproduces and fixes it
# without root). When HELLO_SANITIZER includes "thread" and `setarch` is
# available, this wraps <target>'s test invocation (ctest/gtest_discover_tests)
# with it via CROSSCOMPILING_EMULATOR. No-op otherwise.
function(hello_apply_sanitizer_test_wrapper target)
  if(NOT "thread" IN_LIST HELLO_SANITIZER)
    return()
  endif()

  find_program(SETARCH_EXECUTABLE setarch)
  if(NOT SETARCH_EXECUTABLE)
    return()
  endif()

  set_target_properties(${target} PROPERTIES
    CROSSCOMPILING_EMULATOR "${SETARCH_EXECUTABLE};-R")
endfunction()
