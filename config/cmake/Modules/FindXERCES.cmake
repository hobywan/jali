# Copyright (c) 2017, Los Alamos National Security, LLC
# All rights reserved.

# Copyright 2017. Los Alamos National Security, LLC. This software was
# produced under U.S. Government contract DE-AC52-06NA25396 for Los
# Alamos National Laboratory (LANL), which is operated by Los Alamos
# National Security, LLC for the U.S. Department of Energy. The
# U.S. Government has rights to use, reproduce, and distribute this
# software.  NEITHER THE GOVERNMENT NOR LOS ALAMOS NATIONAL SECURITY,
# LLC MAKES ANY WARRANTY, EXPRESS OR IMPLIED, OR ASSUMES ANY LIABILITY
# FOR THE USE OF THIS SOFTWARE.  If software is modified to produce
# derivative works, such modified software should be clearly marked, so
# as not to confuse it with the version available from LANL.
 
# Additionally, redistribution and use in source and binary forms, with
# or without modification, are permitted provided that the following
# conditions are met:

# 1.  Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 2.  Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# 3.  Neither the name of Los Alamos National Security, LLC, Los Alamos
# National Laboratory, LANL, the U.S. Government, nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
 
# THIS SOFTWARE IS PROVIDED BY LOS ALAMOS NATIONAL SECURITY, LLC AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LOS
# ALAMOS NATIONAL SECURITY, LLC OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#
# Jali XERCES Find Module
#
# Usage:
#    Control the search through XERCES_DIR or setting environment variable
#    XERCES_ROOT to the XERCES installation prefix.
#
#    This module does not search default paths! 
#
#    Following variables are set:
#    XERCES_FOUND            (BOOL)       Flag indicating if XERCES was found
#    XERCES_INCLUDE_DIR      (PATH)       Path to the XERCES include file
#    XERCES_INCLUDE_DIRS     (LIST)       List of all required include files
#    XERCES_LIBRARY_DIR      (PATH)       Path to the XERCES library
#    XERCES_LIBRARY          (FILE)       XERCES library
#    XERCES_LIBRARIES        (LIST)       List of all required XERCES libraries
#
# #############################################################################

# Standard CMake modules see CMAKE_ROOT/Modules
include(FindPackageHandleStandardArgs)

# Jali CMake functions see <root>/tools/cmake for source
include(PrintVariable)
include(AddPackageDependency)

message (STATUS "EIB>> XERCES: XERCES_C_LIBRARIES=${XERCES_C_LIBRARIES}  " )
message (STATUS "EIB>> XERCES: XERCES_INCLUDE_DIRS=${XERCES_INCLUDE_DIRS}  ")
message (STATUS "EIB>> XERCES: XERCES_DIR=${XERCES_DIR} " )
message (STATUS "EIB>> XERCES: XERCES_LIBRARY_DIR=${XERCES_LIBRARY_DIR} ")
message (STATUS "EIB>> XERCES: XERCES_INCLUDE_DIR=${XERCES_INCLUDE_DIR} ")

if ( XERCES_LIBRARIES AND XERCES_INCLUDE_DIRS )

    # Do nothing. Variables are set. No need to search again

else(XERCES_LIBRARY_DIR AND XERCES_INCLUDE_DIR)

    # Cache variables
    if(XERCES_DIR)
        set(XERCES_DIR "${XERCES_DIR}" CACHE PATH "Path to search for XERCES include and library files")
    endif()

    if(XERCES_INCLUDE_DIR)
        set(XERCES_INCLUDE_DIR "${XERCES_INCLUDE_DIR}" CACHE PATH "Path to search for XERCES include files")
    endif()

    if(XERCES_LIBRARY_DIR)
        set(XERCES_LIBRARY_DIR "${XERCES_LIBRARY_DIR}" CACHE PATH "Path to search for XERCES library files")
    endif()

    # Search for include files
    # Search order preference:
    #  (1) XERCES_INCLUDE_DIR - check existence of path AND if the include files exist
    #  (2) XERCES_DIR/<include>
    #  (3) Default CMake paths See cmake --html-help=out.html file for more information.
    #
    set(xerces_inc_names "dom")
    #set(xerces_inc_suffixes  "xercesc" )
    if (XERCES_INCLUDE_DIR)

	message(STATUS "EIB>> 0 XERCES_INCLUDE_DIR = ${XERCES_INCLUDE_DIR}")
	set(DOM_INCLUDE_DIR "${XERCES_INCLUDE_DIR}/dom")
        if (EXISTS "${DOM_INCLUDE_DIR}")

            set(XERCES_INCLUDE_DIR "${XERCES_INCLUDE_DIR}")
	    message(STATUS "EIB>> 2 set XERCES_INCLUDE_DIR = ${XERCES_INCLUDE_DIR}")

        else()
            message(SEND_ERROR "XERCES_INCLUDE_DIR=${XERCES_INCLUDE_DIR} does not exist")
            set(XERCES_INCLUDE_DIR "XERCES_INCLUDE_DIR-NOTFOUND")
        endif()

    else() 

	message(STATUS "EIB>> not XERCES_INCLUDE_DIR")
	set(xerces_inc_suffixes "include" "include/xercesc" )
        if(XERCES_DIR)

            if (EXISTS "${XERCES_DIR}" )

		message (STATUS "EIB>> trying to find  ${xerces_inc_names} in "
			        "  ${XERCES_DIR} with  ${xerces_inc_suffixes}")
		find_path(XERCES_INCLUDE_DIR
		          NAMES ${xerces_inc_names}
		          HINTS ${XERCES_DIR}
		          PATH_SUFFIXES ${xerces_inc_suffixes}
		          NO_DEFAULT_PATH)

            else()
                 message(SEND_ERROR "XERCES_DIR=${XERCES_DIR} does not exist")
                 set(XERCES_INCLUDE_DIR "XERCES_INCLUDE_DIR-NOTFOUND")
            endif()    


        else()

            message(STATUS "EIB>> last option look in  ${xerces_inc_suffixes} "
	                    "for  ${xerces_inc_names}")
            find_path(XERCES_INCLUDE_DIR
                      NAMES ${xerces_inc_names}
                      PATH_SUFFIXES ${xerces_inc_suffixes})

        endif()

    endif()


    if ( NOT XERCES_INCLUDE_DIR )
        message(SEND_ERROR "Can not locate XERCES include directory")
    endif()

    message (STATUS "EIB>> set XERCES_INCLUDE_DIR = ${XERCES_INCLUDE_DIR}")

    # Search for libraries 
    # Search order preference:
    #  (1) XERCES_LIBRARY_DIR - check existence of path AND if the include files exist
    #  (2) XERCES_DIR/<lib,Lib>
    #  (3) Default CMake paths See cmake --html-help=out.html file for more information.
    #
    set(xerces_lib_names "xerces-c" )
    set(xerces_lib_suffixes  "xerces-c")
    if (XERCES_LIBRARY_DIR)

        if (EXISTS "${XERCES_LIBRARY_DIR}")

            find_library(XERCES_LIBRARY
                         NAMES ${xerces_lib_names}
                         HINTS ${XERCES_LIBRARY_DIR}
                         PATH_SUFFIXES ${xerces_lib_suffixes}
                         NO_DEFAULT_PATH)
        else()
            message(SEND_ERROR "XERCES_LIBRARY_DIR=${XERCES_LIBRARY_DIR} does not exist")
            set(XERCES_LIBRARY "XERCES_LIBRARY-NOTFOUND")
        endif()

    else() 

	message (STATUS "EIB>> not XERCES_LIBRARY_DIR")
        list(APPEND xerces_lib_suffixes "lib" "lib/xerces")
        list(APPEND xerces_Lib_suffixes "Lib" "Lib/xerces")
        if(XERCES_DIR)

            if (EXISTS "${XERCES_DIR}" )

		message (STATUS "EIB>> trying to find  ${xerces_lib_names} in "
			        "  ${XERCES_DIR} with  ${xerces_lib_suffixes}")
                find_library(XERCES_LIBRARY
                             NAMES ${xerces_lib_names}
                             HINTS ${XERCES_DIR}
                             PATH_SUFFIXES ${xerces_lib_suffixes}
                             NO_DEFAULT_PATH)

            else()
                 message(SEND_ERROR "XERCES_DIR=${XERCES_DIR} does not exist")
                 set(XERCES_LIBRARY "XERCES_LIBRARY-NOTFOUND")
            endif()    


        else()

            find_library(XERCES_LIBRARY
                         NAMES ${xerces_lib_names}
                         PATH_SUFFIXES ${xerces_lib_suffixes})

        endif()

    endif()

    if (NOT XERCES_LIBRARY )
        set(XERCES_LIBRARY XERCES_LIBRARY-NOTFOUND)
        message(SEND_ERROR "Can not locate XERCES library")
    endif()    

    # Grab the library dependencies from the libtool files lib*.la
    STRING(REGEX REPLACE "\\.a" ".la" XERCES_LIBTOOL_FILE ${XERCES_LIBRARY})
    file (STRINGS ${XERCES_LIBTOOL_FILE} XERCES_LIBRARY_DEPS REGEX "dependency_libs=.*")
    if(NOT "${XERCES_LIBRARY_DEPS}" STREQUAL "")
      STRING(REGEX REPLACE "^dependency_libs='" "" XERCES_LIBRARY_DEPS ${XERCES_LIBRARY_DEPS})
      if(NOT "${XERCES_LIBRARY_DEPS}" STREQUAL "")
      	STRING(REGEX REPLACE "'$" "" XERCES_LIBRARY_DEPS ${XERCES_LIBRARY_DEPS})
      	STRING(REPLACE " " ";" XERCES_LIBRARY_DEPS "${XERCES_LIBRARY_DEPS}")
      endif()
    endif(NOT "${XERCES_LIBRARY_DEPS}" STREQUAL "")
    message(STATUS "JDM>> XERCES_LIBRARY_DEPS ${XERCES_LIBRARY_DEPS}")

    # For now we don't recurse on *.la files
    set(XERCES_ICU_LIBRARIES "")
    foreach(ln ${XERCES_LIBRARY_DEPS})
      STRING(REGEX MATCH "\\.la" OUT_libtool ${ln})
      # Drop system libraries (-L/usr/*) because they should be in the system linker already
      # -- would be more robust to get ld search path, and then drop overlapping.
      STRING(REGEX MATCH "[-][L]/usr" OUT_lib_system ${ln})
      if ( NOT OUT_libtool AND NOT OUT_lib_system) 
         list(APPEND XERCES_ICU_LIBRARIES ${ln})
      endif()
    endforeach()

    # Add dependency on frameworks for OSX (it doesn't appear in this list for some reason)
    if ( APPLE ) 
      list (APPEND XERCES_ICU_LIBRARIES "-framework CoreServices")
    endif()

    message(STATUS "JDM>> XERCES_ICU_LIBRARIES ${XERCES_ICU_LIBRARIES}")

    # Define the LIBRARIES and INCLUDE_DORS
    set(XERCES_INCLUDE_DIRS ${XERCES_INCLUDE_DIR})
    set(XERCES_LIBRARIES    ${XERCES_LIBRARY})

    message (STATUS "EIB>> setting XERCES: XERCES_INCLUDE_DIRS=${XERCES_INCLUDE_DIR}")
    message (STATUS "EIB>> setting XERCES: XERCES_LIBRARIES   =${XERCES_LIBRARY}")

endif(XERCES_LIBRARIES AND XERCES_INCLUDE_DIRS )    

# Send useful message if everything is found
find_package_handle_standard_args(XERCES DEFAULT_MSG
                                           XERCES_INCLUDE_DIRS
					   XERCES_LIBRARIES)

# find_package)handle)standard_args should set XERCES_FOUND but it does not!
if ( XERCES_LIBRARIES AND XERCES_INCLUDE_DIRS)
    set(XERCES_FOUND TRUE)
else()
    set(XERCES_FOUND FALSE)
endif()

mark_as_advanced(
  XERCES_INCLUDE_DIR
  XERCES_INCLUDE_DIRS
  XERCES_LIBRARY
  XERCES_LIBRARIES
  XERCES_LIBRARY_DIR
  XERCES_ICU_LIBRARIES
)
