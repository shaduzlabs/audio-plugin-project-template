
        ##########    Copyright (C) 2017 Vincenzo Pacella
        ##      ##    Distributed under MIT license, see file LICENSE
        ##      ##    or <http://opensource.org/licenses/MIT>
        ##      ##
##########      ############################################################# shaduzlabs.com #######

include( cmake/hex-util.cmake )

# --------------------------------------------------------------------------------------------------

function( setupCI versionMajor_ versionMinor_ versionMicro_ )

  #versionHex
  dec2hex( VERSION_MAJOR_HEX ${versionMajor_})
  string(LENGTH ${VERSION_MAJOR_HEX} VERSION_MAJOR_HEX_LEN)
  if(${VERSION_MAJOR_HEX_LEN} EQUAL 1)
    set(VERSION_HEX "0x0${VERSION_MAJOR_HEX}")
  else()
    set(VERSION_HEX "0x${VERSION_MAJOR_HEX}")
  endif()

  dec2hex( VERSION_MINOR_HEX ${versionMinor_})
  string(LENGTH ${VERSION_MINOR_HEX} VERSION_MINOR_HEX_LEN)
  if(${VERSION_MINOR_HEX_LEN} EQUAL 1)
    set(VERSION_HEX "${VERSION_HEX}0${VERSION_MINOR_HEX}")
  else()
    set(VERSION_HEX "${VERSION_HEX}${VERSION_MINOR_HEX}")
  endif()

  dec2hex( VERSION_MICRO_HEX ${versionMicro_})
  string(LENGTH ${VERSION_MICRO_HEX} VERSION_MICRO_HEX_LEN)
  if(${VERSION_MICRO_HEX_LEN} EQUAL 1)
    set(VERSION_HEX "${VERSION_HEX}0${VERSION_MICRO_HEX}")
  else()
    set(VERSION_HEX "${VERSION_HEX}${VERSION_MICRO_HEX}")
  endif()

  set( PROJECT_VERSION_STRING "${versionMajor_}.${versionMinor_}.${versionMicro_}" )
  set( PROJECT_VERSION_STRING "${versionMajor_}.${versionMinor_}.${versionMicro_}" PARENT_SCOPE)

  set( JUCE_CONFIG_VERSION ${versionMajor_}.${versionMinor_}.${versionMicro_} PARENT_SCOPE )
  math(EXPR
    PROJECT_VERSION_INTEGER
    "( ${versionMajor_} * 65536 ) + ( ${versionMinor_} * 256 ) + ${versionMicro_}"
  )
  set( JUCE_CONFIG_VERSION_INTEGER ${PROJECT_VERSION_INTEGER} PARENT_SCOPE )
  set( JUCE_CONFIG_VERSION_HEX ${VERSION_HEX} PARENT_SCOPE)
  set( JUCE_CONFIG_VERSION_STRING ${PROJECT_VERSION_STRING} PARENT_SCOPE)

  if($ENV{APPVEYOR})
    set (PRJ_BUILD_HOST "Appveyor")
    set (PRJ_BUILD_NUMBER ".$ENV{APPVEYOR_BUILD_NUMBER}")
    set (PRJ_GIT_BRANCH $ENV{APPVEYOR_REPO_BRANCH})
    execute_process(COMMAND appveyor UpdateBuild -Version ${PROJECT_VERSION_STRING})
  elseif($ENV{TRAVIS})
    set (PRJ_BUILD_HOST "Travis-CI")
    set (PRJ_BUILD_NUMBER ".$ENV{TRAVIS_BUILD_NUMBER}")
    set (PRJ_GIT_BRANCH $ENV{TRAVIS_BRANCH})
  else()
    set (PRJ_BUILD_HOST "a local machine")
    set (PRJ_BUILD_NUMBER "")
    execute_process(
      COMMAND git rev-parse --abbrev-ref HEAD
      WORKING_DIRECTORY ${PROJECT_ROOT_DIR}
      OUTPUT_VARIABLE PRJ_GIT_BRANCH
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
  endif()

  if(${PRJ_GIT_BRANCH} STREQUAL "master")
    set(PRJ_BUILD_TYPE "release version")
    set (PROJECT_VERSION_STRING "${PROJECT_VERSION_STRING}${PRJ_BUILD_NUMBER}")
  elseif(${PRJ_GIT_BRANCH} STREQUAL "develop")
    set(PRJ_BUILD_TYPE "development version")
    set (PROJECT_VERSION_STRING "${PROJECT_VERSION_STRING}${PRJ_BUILD_NUMBER}-dev")
  else()
    set(PRJ_BUILD_TYPE "development version from feature branch: ${GIT_BRANCH}")
    set (PROJECT_VERSION_STRING "${PROJECT_VERSION_STRING}${PRJ_BUILD_NUMBER}-fb")
  endif()

  configure_file (
    "${PROJECT_ROOT_DIR}/support/project-config.h.in"
    "${PROJECT_BINARY_DIR}/project-config.h"
  )

  set(ENV{PROJECT_VERSION} "${PROJECT_VERSION_STRING}")

  if($ENV{APPVEYOR})
    execute_process(COMMAND appveyor UpdateBuild -Version ${PROJECT_VERSION_STRING})
    set(ENV{APPVEYOR_BUILD_VERSION} "${PROJECT_VERSION_STRING}")
  elseif($ENV{TRAVIS})
    set(PRJ_DEPLOY_TARGET $ENV{PRJ_DEPLOY_TARGET})
  endif()

  set( PROJECT_BUILD_DESCRIPTION "${PRJ_BUILD_TYPE} built on ${PRJ_BUILD_HOST}" PARENT_SCOPE )
endfunction( setupCI )
