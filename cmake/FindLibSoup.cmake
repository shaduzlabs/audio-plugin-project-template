message (STATUS "Checking for LibSoup...")

FIND_PATH(LIBSOUP_INCLUDE_DIRS
    NAMES libsoup/soup.h
    PATH_SUFFIXES libsoup-2.4
)
FIND_LIBRARY(LIBSOUP_LIBRARIES
    NAMES soup-2.4
)

if(LIBSOUP_LIBRARIES)
  mark_as_advanced(LIBSOUP_LIBRARIES LIBSOUP_INCLUDE_DIRS)
  set(LIBSOUP_FOUND true)
  message (STATUS "Found: LibSoup")
  message(STATUS " - Includes: ${LIBSOUP_INCLUDE_DIRS}")
  message(STATUS " - Libraries: ${LIBSOUP_LIBRARIES}")
else()
  set(LIBSOUP_FOUND false)
  message (FATAL_ERROR "NOT Found: LibSoup")
endif()
