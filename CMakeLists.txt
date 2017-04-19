
        ##########    Copyright (C) 2017 Vincenzo Pacella
        ##      ##    Distributed under MIT license, see file LICENSE
        ##      ##    or <http://opensource.org/licenses/MIT>
        ##      ##
##########      ############################################################# shaduzlabs.com #######

cmake_minimum_required (VERSION 3.2.0)

project (audio-plugin-project-template)

set ( CMAKE_CXX_STANDARD 11 )

set( PROJECT_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR} )
set( PROJECT_MODULES_DIR ${CMAKE_CURRENT_LIST_DIR}/modules )
set( PROJECT_SOURCE_DIR ${PROJECT_ROOT_DIR}/src )

set( VST_INCLUDE_PATH "${PROJECT_MODULES_DIR}/vst3sdk" )

list( APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake" )

include( cmake/ci.cmake )
include( cmake/JUCE.cmake )

if(${CMAKE_PROJECT_NAME} STREQUAL ${PROJECT_NAME})
  include( cmake/colors.cmake )
endif()

set_directory_properties( PROPERTIES
  COMPILE_DEFINITIONS         NDEBUG
  COMPILE_DEFINITIONS_DEBUG   DEBUG
  COMPILE_DEFINITIONS_RELEASE NDEBUG
)


# Configuration ---------------------------------------------------------------------------------- #

setupCI( 1 0 1 ) # version
string( TIMESTAMP PROJECT_BUILD_DATE "%Y-%m-%d" )

set( JUCE_CONFIG_PLUGIN_NAME "gain" )
set( JUCE_CONFIG_PLUGIN_DESC "Simple gain control" )
set( JUCE_CONFIG_PLUGIN_MANUFACTURER "shaduzLABS" )
set( JUCE_CONFIG_PLUGIN_MANUFACTURER_URL "www.shaduzlabs.com" )
set( JUCE_CONFIG_PLUGIN_MANUFACTURER_EMAIL "shaduz@shaduzlabs.com" )
set( JUCE_CONFIG_PLUGIN_MANUFACTURER_CODE_STRING "SLBS" )
set( JUCE_CONFIG_PLUGIN_MANUFACTURER_CODE 0x534c4253 ) # 'SLBS'
set( JUCE_CONFIG_PLUGIN_CODE_STRING "SLGC" )
set( JUCE_CONFIG_PLUGIN_CODE 0x534c4743 ) # 'SLGC'

set( JUCE_CONFIG_IS_SYNTH 0 )
set( JUCE_CONFIG_WANTS_MIDI 0 )
set( JUCE_CONFIG_PRODUCES_MIDI 0 )
set( JUCE_CONFIG_IS_MIDI_EFFECT 0 )
set( JUCE_CONFIG_EDITOR_REQUIRES_KEYBOARD_FOCUS 0 )
set( JUCE_CONFIG_MAX_IN_CHANNELS 2 )
set( JUCE_CONFIG_MAX_OUT_CHANNELS 2 )
set( JUCE_CONFIG_PREFERRED_CHANNELS_CFG "{1,1,},{2,2}")

configure_file (
  "${PROJECT_ROOT_DIR}/support/JuceHeader.h.in"
  "${PROJECT_BINARY_DIR}/JuceHeader.h"
)

configure_file (
  "${PROJECT_ROOT_DIR}/support/AppConfig.h.in"
  "${PROJECT_BINARY_DIR}/AppConfig.h"
)

message( " ")
message( " ")
message( "${BoldYellow}${JUCE_CONFIG_PLUGIN_NAME} - ${JUCE_CONFIG_PLUGIN_DESC}${ColorReset}")
message( "[${PROJECT_BUILD_DATE}] v. ${PROJECT_VERSION_STRING} / ${PROJECT_BUILD_DESCRIPTION} ")
message( " ")
message( " ")

# Sources ---------------------------------------------------------------------------------------- #

set( UI_SOURCES
  ${PROJECT_SOURCE_DIR}/ui/GraphicKnob.cpp
  ${PROJECT_SOURCE_DIR}/ui/GraphicKnob.h
)
set( PLUGIN_SOURCES
  ${PROJECT_SOURCE_DIR}/GainGUI.cpp
  ${PROJECT_SOURCE_DIR}/GainGUI.h
  ${PROJECT_SOURCE_DIR}/PluginAudioProcessor.cpp
  ${PROJECT_SOURCE_DIR}/PluginAudioProcessor.h
  ${PROJECT_SOURCE_DIR}/PluginAudioProcessorEditor.cpp
  ${PROJECT_SOURCE_DIR}/PluginAudioProcessorEditor.h
)

source_group( "src\\ui" FILES ${UI_SOURCES} )
source_group( "src" FILES ${PLUGIN_SOURCES} )

include_directories(
  ${PROJECT_BINARY_DIR}
  ${PROJECT_SOURCE_DIR}
  ${PROJECT_ROOT_DIR}/support/JuceLibraryCode
)

set( ALL_SOURCES ${UI_SOURCES} ${PLUGIN_SOURCES} )


# Targets ---------------------------------------------------------------------------------------- #

addJUCEPlugins( gain "${ALL_SOURCES}" )
