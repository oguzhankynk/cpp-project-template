include(GoogleTest)

add_executable(hello_unit_tests
  unit/test_hello.cpp
  unit/test_version.cpp
)

target_link_libraries(hello_unit_tests PRIVATE hello::hello GTest::gtest GTest::gtest_main)

hello_set_warnings(hello_unit_tests)
hello_enable_sanitizers(hello_unit_tests)
hello_enable_coverage(hello_unit_tests)
hello_apply_sanitizer_test_wrapper(hello_unit_tests)

gtest_discover_tests(hello_unit_tests)

hello_add_coverage_target()
if(TARGET coverage)
  # The 'coverage' custom target has no implicit dependency on the test
  # binaries; without this, a clean build runs ctest before
  # hello_unit_tests exists and every test reports NOT_BUILT.
  add_dependencies(coverage hello_unit_tests)
endif()
