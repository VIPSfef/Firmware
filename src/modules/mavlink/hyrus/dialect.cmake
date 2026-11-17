# HyRUS additive MAVLink integration, version 2.
# Keep CONFIG_MAVLINK_DIALECT unchanged for the board and other PX4 modules.
if(NOT CONFIG_MAVLINK_DIALECT MATCHES "^[A-Za-z][A-Za-z0-9_]*$" OR
   CONFIG_MAVLINK_DIALECT STREQUAL "hyrus")
  message(FATAL_ERROR "HyRUS needs a base MAVLink dialect name other than hyrus")
endif()
if(NOT EXISTS "${MAVLINK_GIT_DIR}/message_definitions/v1.0/${CONFIG_MAVLINK_DIALECT}.xml")
  message(FATAL_ERROR "Selected base MAVLink dialect ${CONFIG_MAVLINK_DIALECT}.xml is missing")
endif()
set(HYRUS_ADDITIONAL_INCLUDE "<include>ASLUAV.xml</include>")
if(CONFIG_MAVLINK_DIALECT STREQUAL "ASLUAV")
  set(HYRUS_ADDITIONAL_INCLUDE "")
endif()
set(MAVLINK_PRIMARY_DIALECT hyrus)
add_compile_definitions(HYRUS_MAVLINK=1)
set(_hyrus_wrapper "${CMAKE_CURRENT_BINARY_DIR}/hyrus_wrapper/hyrus.xml")
configure_file("${CMAKE_CURRENT_LIST_DIR}/hyrus.xml.in" "${_hyrus_wrapper}" @ONLY)
set(_hyrus_definitions "${CMAKE_CURRENT_BINARY_DIR}/hyrus_message_definitions")
set(MAVLINK_PRIMARY_XML "${_hyrus_definitions}/hyrus.xml")
file(GLOB _hyrus_official_xml CONFIGURE_DEPENDS
  "${MAVLINK_GIT_DIR}/message_definitions/v1.0/*.xml")
add_custom_command(
  OUTPUT "${MAVLINK_PRIMARY_XML}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${_hyrus_definitions}"
  COMMAND ${CMAKE_COMMAND} -E copy_directory
    "${MAVLINK_GIT_DIR}/message_definitions/v1.0" "${_hyrus_definitions}"
  COMMAND ${CMAKE_COMMAND} -E copy_if_different "${_hyrus_wrapper}" "${MAVLINK_PRIMARY_XML}"
  COMMAND ${CMAKE_COMMAND} -E touch "${MAVLINK_PRIMARY_XML}"
  DEPENDS git_mavlink_v2 "${_hyrus_wrapper}" ${_hyrus_official_xml}
  COMMENT "Adding HyRUS messages to the selected ${CONFIG_MAVLINK_DIALECT} MAVLink dialect"
  VERBATIM)
