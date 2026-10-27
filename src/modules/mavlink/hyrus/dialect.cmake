# HyRUS owns its MAVLink integration in this fork; external modules only publish uORB.
# Preserve the official dialects and stage their definitions in the build tree.
add_compile_definitions(HYRUS_MAVLINK=1)
set(_hyrus_wrapper "${CMAKE_CURRENT_LIST_DIR}/weather.xml")
set(_hyrus_definitions "${CMAKE_CURRENT_BINARY_DIR}/hyrus_message_definitions")
set(MAVLINK_PRIMARY_XML "${_hyrus_definitions}/weather.xml")
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
  COMMENT "Preparing HyRUS weather dialect with unchanged official MAVLink definitions"
  VERBATIM)
