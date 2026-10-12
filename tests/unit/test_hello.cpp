#include "hello/hello.hpp"

#include <gtest/gtest.h>

namespace hello {
namespace {

TEST(GreetingTest, GreetsByName) {
  EXPECT_EQ(greeting("Ada"), "Hello, Ada!");
}

TEST(GreetingTest, EmptyNameGreetsTheWorld) {
  EXPECT_EQ(greeting(""), "Hello, World!");
}

TEST(GreetingTest, PreservesNameVerbatim) {
  EXPECT_EQ(greeting("Grace Hopper"), "Hello, Grace Hopper!");
}

}  // namespace
}  // namespace hello
