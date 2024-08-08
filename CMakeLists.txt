cmake_minimum_required(VERSION 3.5)
project(nn CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

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

if (NN_BUILD_TEST)
    add_executable(nn_test test_nn.cpp)
    target_link_libraries(nn_test PRIVATE nn)
endif()

# Install the header files
install(FILES nn.hpp DESTINATION include)

# Export the library configuration
install(EXPORT ${PROJECT_NAME}Config
    FILE ${PROJECT_NAME}Config.cmake
    NAMESPACE ${PROJECT_NAME}::
    DESTINATION lib/cmake/${PROJECT_NAME}
)
