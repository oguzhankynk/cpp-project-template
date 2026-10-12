include_guard(GLOBAL)

## hello_add_doxygen_targets()
#
# Registers two targets from docs/Doxyfile.in:
#   docs        - builds the HTML API reference in <build>/docs/html.
#   docs-check  - re-runs Doxygen with WARN_AS_ERROR=YES and no HTML output;
#                 fails the build on any undocumented symbol or broken
#                 reference. This is what 'run_checks.sh' and CI call.
# A missing Doxygen executable degrades both to a warning, not a failure,
# since HELLO_BUILD_DOCS may be enabled on machines without it installed.
function(hello_add_doxygen_targets)
  find_package(Doxygen QUIET)
  if(NOT DOXYGEN_FOUND)
    message(WARNING "HELLO_BUILD_DOCS is ON but Doxygen was not found; 'docs' and 'docs-check' targets skipped.")
    return()
  endif()

  find_program(HELLO_DOT_EXECUTABLE dot)
  if(HELLO_DOT_EXECUTABLE)
    set(HELLO_DOXYGEN_HAVE_DOT "YES")
  else()
    set(HELLO_DOXYGEN_HAVE_DOT "NO")
  endif()

  set(HELLO_VERSION "${PROJECT_VERSION}")
  set(HELLO_SOURCE_DIR "${PROJECT_SOURCE_DIR}")

  # 'docs': human-readable HTML site, warnings do not fail the build.
  set(HELLO_DOXYGEN_OUTPUT_DIR "${CMAKE_BINARY_DIR}/docs")
  set(HELLO_DOXYGEN_GENERATE_HTML "YES")
  set(HELLO_DOXYGEN_WARN_AS_ERROR "NO")
  configure_file(
    "${PROJECT_SOURCE_DIR}/docs/Doxyfile.in"
    "${CMAKE_BINARY_DIR}/Doxyfile"
    @ONLY)

  add_custom_target(docs
    COMMAND ${DOXYGEN_EXECUTABLE} "${CMAKE_BINARY_DIR}/Doxyfile"
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    COMMENT "Generating Doxygen HTML documentation in ${HELLO_DOXYGEN_OUTPUT_DIR}/html"
    VERBATIM)

  # 'docs-check': same input, but any warning is now a build failure, and we
  # skip HTML generation since only the warning log matters here.
  set(HELLO_DOXYGEN_OUTPUT_DIR "${CMAKE_BINARY_DIR}/docs-check")
  set(HELLO_DOXYGEN_GENERATE_HTML "NO")
  set(HELLO_DOXYGEN_WARN_AS_ERROR "YES")
  configure_file(
    "${PROJECT_SOURCE_DIR}/docs/Doxyfile.in"
    "${CMAKE_BINARY_DIR}/Doxyfile.check"
    @ONLY)

  add_custom_target(docs-check
    COMMAND ${DOXYGEN_EXECUTABLE} "${CMAKE_BINARY_DIR}/Doxyfile.check"
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    COMMENT "Checking Doxygen documentation coverage (warnings are errors)"
    VERBATIM)
endfunction()
