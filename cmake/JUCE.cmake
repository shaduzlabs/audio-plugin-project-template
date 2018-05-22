
        ##########    Copyright (C) 2017 Vincenzo Pacella
        ##      ##    Distributed under MIT license, see file LICENSE
        ##      ##    or <http://opensource.org/licenses/MIT>
        ##      ##
##########      ############################################################# shaduzlabs.com #######

set(SUBMODULES_DIR ${CMAKE_SOURCE_DIR}/modules)
set(JUCE_LIBRARY_CODE_DIR ${CMAKE_SOURCE_DIR}/support/JuceLibraryCode/)

if(UNIX AND NOT APPLE)
  set(LINUX TRUE)
endif()

# --------------------------------------------------------------------------------------------------

function(replace_compile_flags old_flag new_flag)
  foreach (flag_var
           CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE 
	   CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
           CMAKE_C_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_MINSIZEREL
	   CMAKE_C_FLAGS_RELWITHDEBINFO CMAKE_CXX_FLAGS_RELWITHDEBINFO)
    string(REGEX REPLACE ${old_flag} ${new_flag} tmp_new_flag_var "${${flag_var}}")      
    set(${flag_var} ${tmp_new_flag_var} CACHE INTERNAL "" FORCE)
  endforeach()
endfunction()

function(msvc_set_mt)
  if (MSVC)
    replace_compile_flags("/MD" "/MT")      
  endif(MSVC)
endfunction(msvc_set_mt)

# --------------------------------------------------------------------------------------------------

function( addJUCE target_ )

  if(APPLE)
    find_package( OpenGL REQUIRED )
  elseif(LINUX)
    find_package( ALSA REQUIRED )
    find_package( Freetype REQUIRED )
    find_package( X11 REQUIRED )
    find_package( OpenGL REQUIRED )
    find_package( GTK3 REQUIRED)
    find_package( WebKitGTK REQUIRED)
    find_package( LibSoup REQUIRED)
  endif()

  target_compile_definitions( ${CURRENT_TARGET} PRIVATE
    JUCE_SHARED_CODE=1
    JucePlugin_Build_VST=0
    JucePlugin_Build_VST3=0
    JucePlugin_Build_AU=0
    JucePlugin_Build_AUv3=0
    JucePlugin_Build_RTAS=0
    JucePlugin_Build_AAX=0
    JucePlugin_Build_Standalone=0
  )

  set(juce_library
    ${JUCE_LIBRARY_CODE_DIR}/juce_core.cpp
    ${JUCE_LIBRARY_CODE_DIR}/juce_cryptography.cpp
    ${JUCE_LIBRARY_CODE_DIR}/juce_data_structures.cpp
    ${JUCE_LIBRARY_CODE_DIR}/juce_events.cpp
    ${JUCE_LIBRARY_CODE_DIR}/juce_graphics.cpp
    ${JUCE_LIBRARY_CODE_DIR}/juce_gui_basics.cpp
    ${JUCE_LIBRARY_CODE_DIR}/juce_gui_extra.cpp
    ${JUCE_LIBRARY_CODE_DIR}/juce_opengl.cpp
    ${JUCE_LIBRARY_CODE_DIR}/juce_video.cpp
  )

  set(juce_library_audio
    ${JUCE_LIBRARY_CODE_DIR}/juce_audio_basics.cpp
    ${JUCE_LIBRARY_CODE_DIR}/juce_audio_devices.cpp
    ${JUCE_LIBRARY_CODE_DIR}/juce_audio_formats.cpp
    ${JUCE_LIBRARY_CODE_DIR}/juce_audio_processors.cpp
    ${JUCE_LIBRARY_CODE_DIR}/juce_audio_utils.cpp
  )

  set(juce_library_audio_plugin_client
    ${JUCE_LIBRARY_CODE_DIR}/juce_audio_plugin_client_utils.cpp
  )

  set(juce_library_audio_plugin_client_aax
    ${JUCE_LIBRARY_CODE_DIR}/juce_audio_plugin_client_AAX.cpp
  )

  set(juce_library_audio_plugin_client_aax_osx
    ${JUCE_LIBRARY_CODE_DIR}/juce_audio_plugin_client_AAX.mm
  )

  set(juce_library_audio_plugin_client_standalone
    ${JUCE_LIBRARY_CODE_DIR}/juce_audio_plugin_client_Standalone.cpp
  )

  target_sources( ${CURRENT_TARGET} PRIVATE ${juce_library} )
  target_sources( ${CURRENT_TARGET} PRIVATE ${juce_library_audio} )
  target_sources( ${CURRENT_TARGET} PRIVATE ${juce_library_audio_plugin_client} )

  source_group( "JUCE" FILES ${juce_library} )
  source_group( "JUCE\\audio" FILES ${juce_library_audio} )
  source_group( "JUCE\\audio" FILES ${juce_library_audio_plugin_client} )

  target_include_directories( ${CURRENT_TARGET} PUBLIC
    ${JUCE_LIBRARY_CODE_DIR}
    ${CMAKE_SOURCE_DIR}/modules/JUCE5/modules
  )

  set_target_properties(${CURRENT_TARGET} PROPERTIES
    COMPILE_DEFINITIONS         NDEBUG
    COMPILE_DEFINITIONS_DEBUG   DEBUG
    COMPILE_DEFINITIONS_RELEASE NDEBUG
  )

  if( APPLE )

    set_target_properties( ${CURRENT_TARGET} PROPERTIES
      COMPILE_FLAGS "${COMPILE_FLAGS} -x objective-c++"
    )
    target_link_libraries( ${CURRENT_TARGET} PRIVATE ${OPENGL_gl_LIBRARY} )
    target_link_libraries( ${CURRENT_TARGET} PUBLIC
      "-framework AudioUnit"
      "-framework AudioToolbox"
      "-framework AVFoundation"
      "-framework AVKit"
      "-framework Carbon"
      "-framework Cocoa"
      "-framework CoreAudio"
      "-framework CoreFoundation"
      "-framework CoreMedia"
      "-framework CoreMidi"
      "-framework QuartzCore"
      "-framework IOKit"
      "-framework AGL"
      "-framework Accelerate"
      "-framework WebKit"
      "-lobjc"
    )

  elseif(WIN32)

    target_link_libraries(${CURRENT_TARGET} PUBLIC
      advapi32.lib
      comdlg32.lib
      gdi32.lib
      GlU32.Lib
      kernel32.lib
      ole32.lib
      OpenGL32.Lib
      rpcrt4.lib
      shell32.lib
      user32.lib
      vfw32.lib
      wininet.lib
      winmm.lib
      ws2_32.lib
    )
    msvc_set_mt()
  elseif(LINUX)

    target_include_directories(${CURRENT_TARGET} PRIVATE
      ${FREETYPE_INCLUDE_DIRS}
      ${GTK3_INCLUDE_DIRS}
      ${WEBKITGTK_INCLUDE_DIRS}
      ${LIBSOUP_INCLUDE_DIRS}
    )

    target_link_libraries(${CURRENT_TARGET} PRIVATE
      ${ALSA_LIBRARIES}
      ${FREETYPE_LIBRARIES}
      ${OPENGL_LIBRARIES}
      ${X11_LIBRARIES}
      ${GTK3_LIBRARIES}
      ${WEBKIT_LIBRARIES}
      ${LIBSOUP_LIBRARIES}
    )

  endif()

endfunction(addJUCE)

# --------------------------------------------------------------------------------------------------

function( addJUCE_VST name_ sources_ )

  set( CURRENT_TARGET "${name_}VST" )

  add_library( ${CURRENT_TARGET} MODULE ${sources_} )
  addJUCE( ${CURRENT_TARGET} )

  target_compile_definitions( ${CURRENT_TARGET} PRIVATE JucePlugin_Build_VST=1 )

  set(juce_library_audio_plugin_client_vst
    ${JUCE_LIBRARY_CODE_DIR}/juce_audio_plugin_client_VST2.cpp
  )

  source_group( "JUCE\\audio\\vst" FILES ${juce_library_audio_plugin_client_vst} )

  target_include_directories( ${CURRENT_TARGET} PUBLIC ${VST_INCLUDE_PATH} )
  target_sources(${CURRENT_TARGET} PRIVATE ${juce_library_audio_plugin_client_vst})

  if(APPLE)
    configure_file (
      "${PROJECT_ROOT_DIR}/support/osx/Info-VSTx.plist.in"
      "${PROJECT_BINARY_DIR}/plists/Info-VST.plist"
    )
    set(juce_library_audio_plugin_client_vst_osx
      ${JUCE_LIBRARY_CODE_DIR}/juce_audio_plugin_client_VST_utils.mm
    )
    target_sources(${CURRENT_TARGET} PRIVATE ${juce_library_audio_plugin_client_vst_osx})
  endif()

  set_target_properties(${CURRENT_TARGET} PROPERTIES
    BUNDLE true
    OUTPUT_NAME ${name_}
    BUNDLE_EXTENSION "vst"
    XCODE_ATTRIBUTE_WRAPPER_EXTENSION "vst"
    MACOSX_BUNDLE_INFO_PLIST "${PROJECT_BINARY_DIR}/plists/Info-VST.plist"
  )

  if(APPLE)
    install( TARGETS ${CURRENT_TARGET} DESTINATION "$ENV{HOME}/Library/Audio/Plug-Ins/VST" )
  endif()

endfunction( addJUCE_VST )

# --------------------------------------------------------------------------------------------------

function( addJUCE_VST3 name_ sources_ )

  set( CURRENT_TARGET "${name_}VST3" )

  add_library ( ${CURRENT_TARGET} MODULE ${sources_} )
  addJUCE(${CURRENT_TARGET})

  target_compile_definitions( ${CURRENT_TARGET} PRIVATE JucePlugin_Build_VST3=1 )

  set(juce_library_audio_plugin_client_vst
    ${JUCE_LIBRARY_CODE_DIR}/juce_audio_plugin_client_VST2.cpp
  )

  set(juce_library_audio_plugin_client_vst3
    ${JUCE_LIBRARY_CODE_DIR}/juce_audio_plugin_client_VST3.cpp
  )

  source_group( "JUCE\\audio\\vst" FILES ${juce_library_audio_plugin_client_vst} )
  source_group( "JUCE\\audio\\vst3" FILES ${juce_library_audio_plugin_client_vst3} )

  target_include_directories( ${CURRENT_TARGET} PUBLIC ${VST_INCLUDE_PATH} )
  target_sources(${CURRENT_TARGET} PRIVATE ${juce_library_audio_plugin_client_vst})
  target_sources(${CURRENT_TARGET} PRIVATE ${juce_library_audio_plugin_client_vst3})
  if(APPLE)
    configure_file (
      "${PROJECT_ROOT_DIR}/support/osx/Info-VSTx.plist.in"
      "${PROJECT_BINARY_DIR}/plists/Info-VST3.plist"
    )
    set(juce_library_audio_plugin_client_vst_osx
      ${JUCE_LIBRARY_CODE_DIR}/juce_audio_plugin_client_VST_utils.mm
    )
    source_group( "JUCE\\audio\\vst\\osx" FILES ${juce_library_audio_plugin_client_vst_osx} )

    target_sources(${CURRENT_TARGET} PRIVATE ${juce_library_audio_plugin_client_vst_osx})
  endif()

  set( PLUGIN_OUTPUT_NAME ${name_} )
  if( WIN32)
    if (${CMAKE_BUILD_TYPE} STREQUAL "DEBUG")
      ADD_DEFINITIONS(-D_WINSOCKAPI_)
    endif(${CMAKE_BUILD_TYPE} STREQUAL "DEBUG")
    set_target_properties(${CURRENT_TARGET} PROPERTIES SUFFIX ".vst3")
  endif( WIN32)
  if ( LINUX )
    set( PLUGIN_OUTPUT_NAME ${name_}-vst3 )
  endif( LINUX)

  set_target_properties(${CURRENT_TARGET} PROPERTIES
    BUNDLE true
    OUTPUT_NAME ${PLUGIN_OUTPUT_NAME}
    BUNDLE_EXTENSION "vst3"
    XCODE_ATTRIBUTE_WRAPPER_EXTENSION "vst3"
    MACOSX_BUNDLE_INFO_PLIST "${PROJECT_BINARY_DIR}/plists/Info-VST3.plist"
  )

  if(APPLE)
    install( TARGETS ${CURRENT_TARGET} DESTINATION "$ENV{HOME}/Library/Audio/Plug-Ins/VST3" )
  endif()

endfunction( addJUCE_VST3 )

# --------------------------------------------------------------------------------------------------

function( addJUCE_AU name_ sources_)
  if(APPLE)

    set( CURRENT_TARGET "${name_}AU" )
    add_library ( ${CURRENT_TARGET} MODULE ${sources_} )
    addJUCE( ${CURRENT_TARGET} )

    configure_file (
      "${PROJECT_ROOT_DIR}/support/osx/Info-AU.plist.in"
      "${PROJECT_BINARY_DIR}/plists/Info-AU.plist"
    )

    target_compile_definitions( ${CURRENT_TARGET} PRIVATE JucePlugin_Build_AU=1 )

    set(juce_library_audio_plugin_client_au
      ${JUCE_LIBRARY_CODE_DIR}/juce_audio_plugin_client_AU_1.mm
      ${JUCE_LIBRARY_CODE_DIR}/juce_audio_plugin_client_AU_2.mm
    )
    source_group( "JUCE\\audio\\au" FILES ${juce_library_audio_plugin_client_au} )

    target_sources( ${CURRENT_TARGET} PRIVATE ${juce_library_audio_plugin_client_au} )

    set_target_properties( ${CURRENT_TARGET} PROPERTIES
      BUNDLE true
      OUTPUT_NAME ${name_}
      BUNDLE_EXTENSION "component"
      XCODE_ATTRIBUTE_WRAPPER_EXTENSION "component"
      MACOSX_BUNDLE_INFO_PLIST "${PROJECT_BINARY_DIR}/plists/Info-AU.plist"
    )

    install( TARGETS ${CURRENT_TARGET} DESTINATION "$ENV{HOME}/Library/Audio/Plug-Ins/Components" )
  endif()
endfunction(addJUCE_AU)

# --------------------------------------------------------------------------------------------------

function( addJUCE_AAX name_ sources_ )

  get_filename_component(AAX_SDK_DIR
  "${SUBMODULES_DIR}/AAX_SDK_2p3p0/" ABSOLUTE)
  set(AAX_SDK_INCLUDE_DIR
    ${AAX_SDK_DIR}/Interfaces
    ${AAX_SDK_DIR}/Interfaces/ACF
    )
  set(AAX_SDK_LIB_DIR ${AAX_SDK_DIR}/Libs)
  set(AAX_SDK_LIB_DIR_RELEASE ${AAX_SDK_LIB_DIR}/Release)
  set(AAX_SDK_LIB_DIR_DEBUG ${AAX_SDK_LIB_DIR}/Debug)

  if(WIN32)
    if(${CMAKE_CL_64})
      set(AAX_SDK_LIB_RELEASE "AAXLibrary_x64.lib")
      set(AAX_SDK_LIB_DEBUG "AAXLibrary_x64_D.lib")
    else()
      set(AAX_SDK_LIB_RELEASE "AAXLibrary.lib")
      set(AAX_SDK_LIB_DEBUG "AAXLibrary_D.lib")
    endif(${CMAKE_CL_64})
  else()
    set(AAX_SDK_LIB_RELEASE "libAAXLibrary_libcpp.a")
    set(AAX_SDK_LIB_DEBUG "libAAXLibrary_libcpp.a")
  endif()

  set( CURRENT_TARGET "${name_}AAX" )

  add_library( ${CURRENT_TARGET} MODULE ${sources_} )
  addJUCE( ${CURRENT_TARGET} )

  target_compile_definitions( ${CURRENT_TARGET} PRIVATE
    JucePlugin_Build_AAX=1
    JucePlugin_AAXLibs_path="${AAX_SDK_LIB_DIR}")

  set(AAX_TARGET_OUTPUT_DIR "${PROJECT_BINARY_DIR}/${name_}.aaxplugin/")
  
  if(APPLE)    
    configure_file (
      "${PROJECT_ROOT_DIR}/support/osx/Info-AAX.plist.in"
      "${PROJECT_BINARY_DIR}/plists/Info-AAX.plist"
      )
    configure_file(
      "${PROJECT_ROOT_DIR}/support/osx/PkgInfo-AAX"
      "${AAX_TARGET_OUTPUT_DIR}/Contents/PkgInfo"
       COPYONLY)
    target_sources(${CURRENT_TARGET} PRIVATE ${juce_library_audio_plugin_client_vst_osx})
  elseif (WIN32)
    set_target_properties(${CURRENT_TARGET} PROPERTIES SUFFIX ".aaxdll")
  endif()

  source_group( "JUCE\\audio\\aax" FILES ${juce_library_audio_plugin_client_aax} )

  target_include_directories( ${CURRENT_TARGET} PUBLIC ${AAX_SDK_INCLUDE_DIR} )
  target_sources(${CURRENT_TARGET} PRIVATE ${juce_library_audio_plugin_client_aax})

  target_link_libraries(${CURRENT_TARGET} PUBLIC
    optimized "${AAX_SDK_LIB_DIR_RELEASE}/${AAX_SDK_LIB_RELEASE}"
    debug "${AAX_SDK_LIB_DIR_DEBUG}/${AAX_SDK_LIB_DEBUG}"
    )
  
  set_target_properties(${CURRENT_TARGET} PROPERTIES
    BUNDLE true
    OUTPUT_NAME ${name_}
    BUNDLE_EXTENSION "aaxplugin"
    XCODE_ATTRIBUTE_WRAPPER_EXTENSION "aaxplugin"    
    XCODE_ATTRIBUTE_MACH_O_TYPE mh_bundle
    XCODE_ATTRIBUTE_GENERATE_PKGINFO_FILE "YES"
    XCODE_ATTRIBUTE_INFOPLIST_PREPROCESS "YES"
    MACOSX_BUNDLE_INFO_PLIST "${PROJECT_BINARY_DIR}/plists/Info-AAX.plist"
  )

  if(APPLE)
    install( TARGETS ${CURRENT_TARGET} DESTINATION "$ENV{HOME}/Library/Audio/Plug-Ins/Digidesign" )
  endif()
  
endfunction( addJUCE_AAX )

# --------------------------------------------------------------------------------------------------

function( addJUCEPlugins name_ sources_ )
  add_custom_target("${name_}_plugins")
  if( APPLE )
    addJUCE_AU( ${name_} "${sources_}" )
    add_dependencies("${name_}_plugins" "${name_}AU")
  endif( APPLE )
  addJUCE_VST( ${name_} "${sources_}" )
  addJUCE_VST3( ${name_} "${sources_}" )
  addJUCE_AAX( ${name_} "${sources_}" )
  add_dependencies("${name_}_plugins" "${name_}VST" "${name_}VST3" "${name_}AAX")
endfunction( addJUCEPlugins )
