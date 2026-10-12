add_executable(greet_cli greet_cli.cpp)
target_link_libraries(greet_cli PRIVATE hello::hello)
hello_set_warnings(greet_cli)
