include(tools/cmake/cpp_test.cmake)

set(CPP_LIB_BUILD_DIR ${CMAKE_BINARY_DIR}/cpp-lib)

set(GENERATED_CPP_LIB_HEADERS
  ${CPP_LIB_BUILD_DIR}/AddressFailure.hpp
  ${CPP_LIB_BUILD_DIR}/ArgumentEmpty.hpp
  ${CPP_LIB_BUILD_DIR}/ArgumentTooBig.hpp
  ${CPP_LIB_BUILD_DIR}/BufferTarget.hpp
  ${CPP_LIB_BUILD_DIR}/Element.hpp
  ${CPP_LIB_BUILD_DIR}/Entry.hpp
  ${CPP_LIB_BUILD_DIR}/ErrorId.hpp
  ${CPP_LIB_BUILD_DIR}/Facility.hpp
  ${CPP_LIB_BUILD_DIR}/FileOpenFailure.hpp
  ${CPP_LIB_BUILD_DIR}/FileTarget.hpp
  ${CPP_LIB_BUILD_DIR}/FileWriteFailure.hpp
  ${CPP_LIB_BUILD_DIR}/IndexOutOfBounds.hpp
  ${CPP_LIB_BUILD_DIR}/InvalidFacility.hpp
  ${CPP_LIB_BUILD_DIR}/InvalidId.hpp
  ${CPP_LIB_BUILD_DIR}/MemoryAllocationFailure.hpp
  ${CPP_LIB_BUILD_DIR}/MemoryManager.hpp
  ${CPP_LIB_BUILD_DIR}/NetworkProtocolUnsupported.hpp
  ${CPP_LIB_BUILD_DIR}/Param.hpp
  ${CPP_LIB_BUILD_DIR}/Severity.hpp
  ${CPP_LIB_BUILD_DIR}/SocketBindFailure.hpp
  ${CPP_LIB_BUILD_DIR}/SocketConnectFailure.hpp
  ${CPP_LIB_BUILD_DIR}/SocketFailure.hpp
  ${CPP_LIB_BUILD_DIR}/SocketSendFailure.hpp
  ${CPP_LIB_BUILD_DIR}/StreamTarget.hpp
  ${CPP_LIB_BUILD_DIR}/StreamWriteFailure.hpp
  ${CPP_LIB_BUILD_DIR}/StumplessException.hpp
  ${CPP_LIB_BUILD_DIR}/TargetIncompatible.hpp
  ${CPP_LIB_BUILD_DIR}/TargetUnsupported.hpp
  ${CPP_LIB_BUILD_DIR}/TransportProtocolUnsupported.hpp
  ${CPP_LIB_BUILD_DIR}/Version.hpp
  ${CPP_LIB_BUILD_DIR}/WindowsEventLogCloseFailure.hpp
  ${CPP_LIB_BUILD_DIR}/WindowsEventLogOpenFailure.hpp
)

set(GENERATED_CPP_LIB_SOURCES
  ${CPP_LIB_BUILD_DIR}/AddressFailure.cpp
  ${CPP_LIB_BUILD_DIR}/ArgumentEmpty.cpp
  ${CPP_LIB_BUILD_DIR}/ArgumentTooBig.cpp
  ${CPP_LIB_BUILD_DIR}/BufferTarget.cpp
  ${CPP_LIB_BUILD_DIR}/Element.cpp
  ${CPP_LIB_BUILD_DIR}/Entry.cpp
  ${CPP_LIB_BUILD_DIR}/FileOpenFailure.cpp
  ${CPP_LIB_BUILD_DIR}/FileTarget.cpp
  ${CPP_LIB_BUILD_DIR}/FileWriteFailure.cpp
  ${CPP_LIB_BUILD_DIR}/IndexOutOfBounds.cpp
  ${CPP_LIB_BUILD_DIR}/InvalidFacility.cpp
  ${CPP_LIB_BUILD_DIR}/InvalidId.cpp
  ${CPP_LIB_BUILD_DIR}/MemoryAllocationFailure.cpp
  ${CPP_LIB_BUILD_DIR}/MemoryManager.cpp
  ${CPP_LIB_BUILD_DIR}/NetworkProtocolUnsupported.cpp
  ${CPP_LIB_BUILD_DIR}/Param.cpp
  ${CPP_LIB_BUILD_DIR}/SocketBindFailure.cpp
  ${CPP_LIB_BUILD_DIR}/SocketConnectFailure.cpp
  ${CPP_LIB_BUILD_DIR}/SocketFailure.cpp
  ${CPP_LIB_BUILD_DIR}/SocketSendFailure.cpp
  ${CPP_LIB_BUILD_DIR}/StreamTarget.cpp
  ${CPP_LIB_BUILD_DIR}/StreamWriteFailure.cpp
  ${CPP_LIB_BUILD_DIR}/StumplessException.cpp
  ${CPP_LIB_BUILD_DIR}/TargetIncompatible.cpp
  ${CPP_LIB_BUILD_DIR}/TargetUnsupported.cpp
  ${CPP_LIB_BUILD_DIR}/TransportProtocolUnsupported.cpp
  ${CPP_LIB_BUILD_DIR}/Version.cpp
  ${CPP_LIB_BUILD_DIR}/WindowsEventLogCloseFailure.cpp
  ${CPP_LIB_BUILD_DIR}/WindowsEventLogOpenFailure.cpp
)

if(STUMPLESS_NETWORK_TARGETS_SUPPORTED)
  list(APPEND GENERATED_CPP_LIB_HEADERS ${CPP_LIB_BUILD_DIR}/NetworkTarget.hpp)
  list(APPEND GENERATED_CPP_LIB_SOURCES ${CPP_LIB_BUILD_DIR}/NetworkTarget.cpp)

  add_cpp_test(network
    SOURCES
      ${PROJECT_SOURCE_DIR}/test/function/cpp/target/network.cpp
  )
endif()

if(STUMPLESS_SOCKET_TARGETS_SUPPORTED)
  list(APPEND GENERATED_CPP_LIB_HEADERS ${CPP_LIB_BUILD_DIR}/SocketTarget.hpp)
  list(APPEND GENERATED_CPP_LIB_SOURCES ${CPP_LIB_BUILD_DIR}/SocketTarget.cpp)
endif()

if(STUMPLESS_WINDOWS_EVENT_LOG_TARGETS_SUPPORTED)
  list(APPEND GENERATED_CPP_LIB_HEADERS ${CPP_LIB_BUILD_DIR}/WelTarget.hpp)
  list(APPEND GENERATED_CPP_LIB_HEADERS ${CPP_LIB_BUILD_DIR}/WelTarget.cpp)

  add_cpp_test(wel
    SOURCES
      ${PROJECT_SOURCE_DIR}/test/function/cpp/target/wel.cpp
  )
endif()

file(MAKE_DIRECTORY ${CPP_LIB_BUILD_DIR})

add_custom_command(
  OUTPUT ${GENERATED_CPP_LIB_SOURCES}
  COMMAND wrapture ${WRAPTURE_SPECS}
  DEPENDS ${WRAPTURE_SPECS}
  WORKING_DIRECTORY ${CPP_LIB_BUILD_DIR}
  VERBATIM
)

add_library(stumplesscpp SHARED
  ${GENERATED_CPP_LIB_SOURCES}
)

target_link_libraries(stumplesscpp
  optimized stumpless
)

target_include_directories(stumplesscpp
  PRIVATE
  ${PROJECT_SOURCE_DIR}/include
  ${CMAKE_BINARY_DIR}/include
  ${CPP_LIB_BUILD_DIR}
)

set_target_properties(stumplesscpp
  PROPERTIES
    VERSION ${PROJECT_VERSION}
)

if(CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
  target_compile_options(stumplesscpp PUBLIC "-std=c++11")
endif()

add_cpp_test(entry
  SOURCES
    ${PROJECT_SOURCE_DIR}/test/function/cpp/entry.cpp
)

add_cpp_test(file
  SOURCES
    ${PROJECT_SOURCE_DIR}/test/function/cpp/target/file.cpp
    $<TARGET_OBJECTS:rfc5424_checker>
)

add_cpp_test(memory
  SOURCES
    ${PROJECT_SOURCE_DIR}/test/function/cpp/memory.cpp
)

add_cpp_test(param
  SOURCES
    ${PROJECT_SOURCE_DIR}/test/function/cpp/param.cpp
)

add_cpp_test(stream
  SOURCES
    ${PROJECT_SOURCE_DIR}/test/function/cpp/target/stream.cpp
)

add_cpp_test(version
  SOURCES
    ${PROJECT_SOURCE_DIR}/test/function/cpp/version.cpp
)

add_custom_target(check-cpp
  DEPENDS ${STUMPLESS_CPP_TEST_RUNNERS}
)


# add c++ library to installation
install(TARGETS stumplesscpp
  RUNTIME DESTINATION "bin"
  LIBRARY DESTINATION "lib"
  PUBLIC_HEADER DESTINATION "include"
  ARCHIVE DESTINATION "lib/static"
)

install(
  FILES ${GENERATED_CPP_LIB_HEADERS}
  DESTINATION "include/stumplesscpp"
)

#documentation generation
if(HAVE_DOXYGEN)
  file(MAKE_DIRECTORY ${PROJECT_DOCS_DIR})

  set(CPP_DOCS_DIR ${PROJECT_DOCS_DIR}/cpp)

  configure_file(${PROJECT_SOURCE_DIR}/tools/doxygen/CppDoxyfile.in ${CMAKE_BINARY_DIR}/tools/doxygen/CppDoxyfile)

  add_custom_target(docs-cpp
    DEPENDS ${GENERATED_CPP_LIB_HEADERS}
    COMMAND doxygen ${CMAKE_BINARY_DIR}/tools/doxygen/CppDoxyfile
  )
endif(HAVE_DOXYGEN)