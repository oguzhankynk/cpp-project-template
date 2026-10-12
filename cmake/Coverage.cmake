include_guard(GLOBAL)

## hello_enable_coverage(<target>)
#
# Instruments <target> with --coverage when HELLO_ENABLE_COVERAGE is ON.
# Call hello_add_coverage_target() once, after tests exist, to register the
# aggregate 'coverage' target (gcovr HTML + XML + threshold).
function(hello_enable_coverage target)
  if(NOT HELLO_ENABLE_COVERAGE)
    return()
  endif()

  if(NOT (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
    message(WARNING "HELLO_ENABLE_COVERAGE is set but ${CMAKE_CXX_COMPILER_ID} is not GCC/Clang; ignoring.")
    return()
  endif()

  target_compile_options(${target} PUBLIC --coverage -O0 -g)
  target_link_options(${target} PUBLIC --coverage)
endfunction()

## hello_add_coverage_target()
#
# Registers a 'coverage' target that runs ctest and then gcovr, failing the
# build if the line/branch thresholds below are not met.
# No-op if HELLO_ENABLE_COVERAGE is OFF or gcovr is not found.
function(hello_add_coverage_target)
  if(NOT HELLO_ENABLE_COVERAGE)
    return()
  endif()

  find_program(GCOVR_EXECUTABLE gcovr)
  if(NOT GCOVR_EXECUTABLE)
    message(WARNING "HELLO_ENABLE_COVERAGE is ON but gcovr was not found; 'coverage' target skipped.")
    return()
  endif()

  set(coverage_html_dir "${CMAKE_BINARY_DIR}/coverage")
  file(MAKE_DIRECTORY "${coverage_html_dir}")

  add_custom_target(coverage
    COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure --test-dir "${CMAKE_BINARY_DIR}"
    # gcovr re-resolves each .gcno's recorded source path relative to its own
    # current working directory (one of several fallback heuristics it
    # tries); run it from CMAKE_SOURCE_DIR, matching --root, so resolution
    # lands on the real src/ and include/hello/ files instead of silently
    # falling back to whatever it can find via another heuristic.
    COMMAND ${GCOVR_EXECUTABLE}
            --root "${CMAKE_SOURCE_DIR}"
            --object-directory "${CMAKE_BINARY_DIR}"
            # Works around a long-standing gcov bug (GCC PR68080) where
            # branch counters on some code paths come out negative; gcovr's
            # own suggested workaround.
            --gcov-ignore-parse-errors negative_hits.warn
            # Substrings, not anchored paths: gcovr matches these relative to
            # --root, and generated sources (e.g. version.cpp, written by
            # configure_file into the build tree) must still match.
            --filter "src/"
            --filter "include/hello/"
            --exclude "_deps/"
            --exclude "tests/"
            --html --html-details -o "${coverage_html_dir}/index.html"
            --xml "${CMAKE_BINARY_DIR}/coverage.xml"
            --print-summary
            # Defaults for this template's own trivial example code; lower
            # these to match what your own project's test suite actually
            # achieves (implicit branches from things like std::string's
            # allocation paths are often impractical to hit deliberately).
            --fail-under-line 90
            --fail-under-branch 60
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
    COMMENT "Running tests and generating coverage report in ${coverage_html_dir}"
    VERBATIM)
endfunction()
