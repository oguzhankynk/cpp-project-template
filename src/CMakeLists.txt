configure_file(version.cpp.in "${CMAKE_CURRENT_BINARY_DIR}/version.cpp" @ONLY)

add_library(hello
  "${CMAKE_CURRENT_BINARY_DIR}/version.cpp"
  hello.cpp
)
add_library(hello::hello ALIAS hello)

target_compile_features(hello PUBLIC cxx_std_17)

target_include_directories(hello
  PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

hello_set_warnings(hello)
hello_enable_sanitizers(hello)
hello_enable_coverage(hello)
hello_enable_clang_tidy(hello)
hello_enable_cppcheck(hello)
