cmake_minimum_required(VERSION 3.5)
project(nn CXX)

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

# Install the header files
install(FILES nn.hpp DESTINATION include)

# Export the library configuration
install(EXPORT ${PROJECT_NAME}Config
    FILE ${PROJECT_NAME}Config.cmake
    NAMESPACE ${PROJECT_NAME}::
    DESTINATION lib/cmake/${PROJECT_NAME}
)
