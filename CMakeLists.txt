cmake_minimum_required(VERSION 3.12)
project(nn LANGUAGES CXX VERSION 1.1.0)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Option to build tests
option(NN_BUILD_TESTS "Build the test executable" OFF)

# Create the INTERFACE library
add_library(${PROJECT_NAME} INTERFACE)

# Use the current source directory for development
target_include_directories(${PROJECT_NAME} INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include>
)

# Install the library target
install(TARGETS ${PROJECT_NAME} EXPORT ${PROJECT_NAME}Config
    INCLUDES DESTINATION include
)

# Build tests if this is the root project and NN_BUILD_TEST is enabled
if (NN_BUILD_TESTS)
    add_executable(nn_test test_nn.cpp)
    target_link_libraries(nn_test PRIVATE nn)
    message(STATUS "Building tests")
endif()

# Install the header files
install(FILES nn.hpp DESTINATION include)

# Export the library configuration
install(EXPORT ${PROJECT_NAME}Config
    FILE ${PROJECT_NAME}Config.cmake
    NAMESPACE ${PROJECT_NAME}::
    DESTINATION lib/cmake/${PROJECT_NAME}
)
