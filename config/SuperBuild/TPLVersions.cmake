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
# TPLVersions
#
#    Define the versions, approved download locations for each TPL
#

#
# TPL: Jali Collection of TPLs
#
#   Define a "version number" for the collection of TPLs listed here.
#   It's not clear this is the best way to include this information, 
#   but it's a reasonable place to start.
#   
#   Upgrade History:
#
#   1.0.0       - first version reference used in installations
#                   Xerces          3.1.1
#                   MPI version     1.4.4
#                   Curl            7.37.0
#                   Zlib            1.2.6
#                   Metis           5.1.0
#                   Boost           1.57
#                   BoostCmake      1.46.1
#                   HDF5            1.8.8
#                   NetCDF          4.3.2
#                   NetCDF fortran  4.2
#                   Exodus II       6.06
#                   MSTK            2.25
#                   Trilinos        12.2.2
#                   Seacas          12.2.2
#   1.0.1       - Boost updated to 1.58
#   1.0.2       - MSTK updated to 2.25rc1
#   1.0.3       - Trilinos updated to 12.2.2
#   1.0.4       - MSTK updated to 2.25
#   1.0.5       - MSTK updated to 2.26rc1 and Jali-tpl-config.cmake includes variables indicating if METIS and/or ZOLTAN are enabled
#   1.0.6       - MSTK updated to 2.26rc2
#   1.0.7       - MSTK updated to 2.27rc2
#   1.0.8       - MSTK updated to 2.27rc3
#   1.0.9       - MSTK updated to 2.27 and UnitTest++ updated to 1.6.0

include(CMakeParseArguments)

MACRO(LIST_LENGTH var)
  SET(entries)
  FOREACH(e ${ARGN})
    SET(entries "${entries}.")
  ENDFOREACH(e)
  STRING(LENGTH "${entries}" ${var})
ENDMACRO(LIST_LENGTH)

# this macro appends version number defines to the tpl_versions.h include file
macro(Jali_tpl_version_write)
  set(singleValueArgs FILENAME PREFIX)
  set(multiValueArgs VERSION)
  set(options "")
  
  cmake_parse_arguments(LOCAL "${options}" "${singleValueArgs}" "${multiValueArgs}" ${ARGN})

  list_length(length ${LOCAL_VERSION})

  if (length GREATER 0) 
    list(GET LOCAL_VERSION 0 MAJOR)
    file(APPEND ${LOCAL_FILENAME} "#define ${LOCAL_PREFIX}_MAJOR ${MAJOR}\n")
  else()
    file(APPEND ${LOCAL_FILENAME} "#define ${LOCAL_PREFIX}_MAJOR\n")
  endif()

  if (length GREATER 1)
    list(GET LOCAL_VERSION 1 MINOR)
    file(APPEND ${LOCAL_FILENAME} "#define ${LOCAL_PREFIX}_MINOR ${MINOR}\n")
  else()
    file(APPEND ${LOCAL_FILENAME} "#define ${LOCAL_PREFIX}_MINOR\n")
  endif()

  if (length GREATER 2)
    list(GET LOCAL_VERSION 2 PATCH)
    file(APPEND ${LOCAL_FILENAME} "#define ${LOCAL_PREFIX}_PATCH ${PATCH}\n")
  else()
    file(APPEND ${LOCAL_FILENAME} "#define ${LOCAL_PREFIX}_PATCH\n")
  endif()

  file(APPEND ${LOCAL_FILENAME} "\n")

endmacro(Jali_tpl_version_write)


set (JALI_TPLS_VERSION_MAJOR 1)
set (JALI_TPLS_VERSION_MINOR 0)
set (JALI_TPLS_VERSION_PATCH 2)
set (JALI_TPLS_VERSION ${JALI_TPLS_VERSION}.${JALI_TPLS_VERSION_MINOR}.${JALI_TPLS_VERSION_PATCH})
#   Not sure how to create a meaningful hash key for the collection

#
# TPL: Xerces
#
set(XERCES_VERSION_MAJOR 3)
set(XERCES_VERSION_MINOR 1)
set(XERCES_VERSION_PATCH 1)
set(XERCES_VERSION ${XERCES_VERSION_MAJOR}.${XERCES_VERSION_MINOR}.${XERCES_VERSION_PATCH})
set(XERCES_URL_STRING     "http://software.lanl.gov/ascem/tpls")
set(XERCES_ARCHIVE_FILE   xerces-c-${XERCES_VERSION}.tar.gz)
set(XERCES_MD5_SUM        6a8ec45d83c8cfb1584c5a5345cb51ae ) 

#
# TPL: OpenMPI
#
set(OpenMPI_VERSION_MAJOR 1)
set(OpenMPI_VERSION_MINOR 4)
set(OpenMPI_VERSION_PATCH 4)
set(OpenMPI_VERSION ${OpenMPI_VERSION_MAJOR}.${OpenMPI_VERSION_MINOR}.${OpenMPI_VERSION_PATCH})
set(OpenMPI_URL_STRING     "http://software.lanl.gov/ascem/tpls")
set(OpenMPI_ARCHIVE_FILE   openmpi-${OpenMPI_VERSION}.tar.bz2)
set(OpenMPI_MD5_SUM        e58a1ea7b8af62453aaa0ddaee5f26a0) 

#
# TPL: CURL
#
set(CURL_VERSION_MAJOR 7)
set(CURL_VERSION_MINOR 37)
set(CURL_VERSION_PATCH 0)
set(CURL_VERSION ${CURL_VERSION_MAJOR}.${CURL_VERSION_MINOR}.${CURL_VERSION_PATCH})
set(CURL_URL_STRING     "http://software.lanl.gov/ascem/tpls")
set(CURL_ARCHIVE_FILE   curl-${CURL_VERSION}.tar.bz2)
set(CURL_MD5_SUM        7dda0cc2e4136f78d5801ac347be696b)

#
# TPL: zlib
#
set(ZLIB_VERSION_MAJOR 1)
set(ZLIB_VERSION_MINOR 2)
set(ZLIB_VERSION_PATCH 6)
set(ZLIB_VERSION ${ZLIB_VERSION_MAJOR}.${ZLIB_VERSION_MINOR}.${ZLIB_VERSION_PATCH})
set(ZLIB_URL_STRING     "http://software.lanl.gov/ascem/tpls")
set(ZLIB_ARCHIVE_FILE   zlib-${ZLIB_VERSION}.tar.gz)
set(ZLIB_MD5_SUM        618e944d7c7cd6521551e30b32322f4a) 

#
# TPL: METIS
#
set(METIS_VERSION_MAJOR 5)
set(METIS_VERSION_MINOR 1)
set(METIS_VERSION_PATCH 0)
set(METIS_VERSION ${METIS_VERSION_MAJOR}.${METIS_VERSION_MINOR}.${METIS_VERSION_PATCH})
set(METIS_URL_STRING     "http://software.lanl.gov/ascem/tpls")
set(METIS_ARCHIVE_FILE   metis-${METIS_VERSION}.tar.gz)
set(METIS_MD5_SUM        5465e67079419a69e0116de24fce58fe)

#
# TPL: UnitTest
#
set(UnitTest_VERSION_MAJOR 1)
set(UnitTest_VERSION_MINOR 6)
set(UnitTest_VERSION_PATCH 0)
set(UnitTest_VERSION ${UnitTest_VERSION_MAJOR}.${UnitTest_VERSION_MINOR}.${UnitTest_VERSION_PATCH})
set(UnitTest_URL_STRING     "http://software.lanl.gov/ascem/tpls")
set(UnitTest_ARCHIVE_FILE   unittest-cpp-${UnitTest_VERSION}.zip)
set(UnitTest_MD5_SUM       bca285acea948ab3cd76e8cb17f65d24) 

#
# TPL: Boost
#
set(Boost_VERSION_MAJOR 1)
set(Boost_VERSION_MINOR 58)
set(Boost_VERSION_PATCH 0)
set(Boost_VERSION        ${Boost_VERSION_MAJOR}.${Boost_VERSION_MINOR}.${Boost_VERSION_PATCH})
set(Boost_VERSION_STRING ${Boost_VERSION_MAJOR}_${Boost_VERSION_MINOR}_${Boost_VERSION_PATCH})
set(Boost_URL_STRING     "http://software.lanl.gov/ascem/tpls")
set(Boost_ARCHIVE_FILE   boost_${Boost_VERSION_STRING}.tar.bz2)
set(Boost_MD5_SUM        b8839650e61e9c1c0a89f371dd475546)

#
# TPL: BoostCmake
#
set(BoostCmake_VERSION_MAJOR 1)
set(BoostCmake_VERSION_MINOR 46)
set(BoostCmake_VERSION_PATCH 1)
set(BoostCmake_VERSION        ${BoostCmake_VERSION_MAJOR}.${BoostCmake_VERSION_MINOR}.${BoostCmake_VERSION_PATCH})
set(BoostCmake_URL_STRING     "http://software.lanl.gov/ascem/tpls")
set(BoostCmake_ARCHIVE_FILE   boost-cmake-cmake-${BoostCmake_VERSION}.tar.gz)
set(BoostCmake_MD5_SUM        ) 

#
# TPL: HDF5
#
set(HDF5_VERSION_MAJOR 1)
set(HDF5_VERSION_MINOR 8)
set(HDF5_VERSION_PATCH 8)
set(HDF5_VERSION ${HDF5_VERSION_MAJOR}.${HDF5_VERSION_MINOR}.${HDF5_VERSION_PATCH})
set(HDF5_URL_STRING    "http://software.lanl.gov/ascem/tpls")
set(HDF5_ARCHIVE_FILE   hdf5-${HDF5_VERSION}.tar.gz)
set(HDF5_MD5_SUM        1196e668f5592bfb50d1de162eb16cff)      

#
# TPL: NetCDF
#
set(NetCDF_VERSION_MAJOR 4)
set(NetCDF_VERSION_MINOR 3)
set(NetCDF_VERSION_PATCH 2)
set(NetCDF_VERSION ${NetCDF_VERSION_MAJOR}.${NetCDF_VERSION_MINOR}.${NetCDF_VERSION_PATCH})
set(NetCDF_URL_STRING     "http://software.lanl.gov/ascem/tpls")
set(NetCDF_ARCHIVE_FILE   netcdf-${NetCDF_VERSION}.tar.gz)
set(NetCDF_MD5_SUM        2fd2365e1fe9685368cd6ab0ada532a0)

#
# TPL: NetCDF Fortran
#
set(NetCDF_Fortran_VERSION_MAJOR 4)
set(NetCDF_Fortran_VERSION_MINOR 2)
set(NetCDF_Fortran_VERSION ${NetCDF_Fortran_VERSION_MAJOR}.${NetCDF_Fortran_VERSION_MINOR})
set(NetCDF_Fortran_URL_STRING     "http://software.lanl.gov/ascem/tpls")
set(NetCDF_Fortran_ARCHIVE_FILE   netcdf-fortran-${NetCDF_Fortran_VERSION}.tar.gz)
set(NetCDF_Fortran_MD5_SUM        cc3bf530223e8f4aff93793b9f197bf3) 

#
# TPL: ExodusII
#
set(ExodusII_VERSION_MAJOR 6)
set(ExodusII_VERSION_MINOR 06)
set(ExodusII_VERSION ${ExodusII_VERSION_MAJOR}.${ExodusII_VERSION_MINOR})
set(ExodusII_URL_STRING    "http://software.lanl.gov/ascem/tpls")
set(ExodusII_ARCHIVE_FILE  exodus-${ExodusII_VERSION}.tar.gz)
set(ExodusII_MD5_SUM       cfd240dbc1251b08fb1d0ee2de40a44c)

#
# TPL: MSTK
#
set(MSTK_VERSION_MAJOR 2)
set(MSTK_VERSION_MINOR 27)
set(MSTK_VERSION_PATCH )
if (MSTK_VERSION_PATCH)
  set(MSTK_VERSION ${MSTK_VERSION_MAJOR}_${MSTK_VERSION_MINOR}_${MSTK_VERSION_PATCH})
else (MSTK_VERSION_PATCH)
  set(MSTK_VERSION ${MSTK_VERSION_MAJOR}_${MSTK_VERSION_MINOR})
endif (MSTK_VERSION_PATCH)
set(MSTK_URL_STRING     "https://github.com/MeshToolkit/MSTK/archive")
set(MSTK_ARCHIVE_FILE   MSTK-${MSTK_VERSION}.tar.gz)
set(MSTK_MD5_SUM       d14a28ff45d4c13790ea066524c7fafa)

#
# TPL: MOAB
#
set(MOAB_VERSION_MAJOR  r4276)
set(MOAB_VERSION_MINOR  )
set(MOAB_VERSION_PATCH  )
set(MOAB_URL_STRING     "http://software.lanl.gov/ascem/tpls")
set(MOAB_ARCHIVE_FILE   MOAB-${MOAB_VERSION}.tar.gz)
set(MOAB_MD5_SUM        49da04e8905f6d730d92521e7ca7400e) 

#
# TPL: Trilinos
#
set(Trilinos_VERSION_MAJOR 12)
set(Trilinos_VERSION_MINOR 2)
set(Trilinos_VERSION_PATCH 2)
set(Trilinos_VERSION ${Trilinos_VERSION_MAJOR}.${Trilinos_VERSION_MINOR}.${Trilinos_VERSION_PATCH})
set(Trilinos_URL_STRING     "http://software.lanl.gov/ascem/tpls")
set(Trilinos_ARCHIVE_FILE   trilinos-${Trilinos_VERSION}-Source.tar.bz2)
set(Trilinos_MD5_SUM        90bbb175505b55878401a51a1d17463c)

#
# TPL: SEACAS
#  SEACAS is available in Trilinos 10.8 and above
set(SEACAS_VERSION_MAJOR 12)
set(SEACAS_VERSION_MINOR 2)
set(SEACAS_VERSION_PATCH 2)
set(SEACAS_VERSION ${SEACAS_VERSION_MAJOR}.${SEACAS_VERSION_MINOR}.${SEACAS_VERSION_PATCH})
set(SEACAS_URL_STRING     "http://software.lanl.gov/ascem/tpls")
set(SEACAS_ARCHIVE_FILE   trilinos-${SEACAS_VERSION}-Source.tar.bz2)
set(SEACAS_MD5_SUM        90bbb175505b55878401a51a1d17463c)

