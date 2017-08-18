/*
Copyright (c) 2017, Los Alamos National Security, LLC
All rights reserved.

Copyright 2017. Los Alamos National Security, LLC. This software was
produced under U.S. Government contract DE-AC52-06NA25396 for Los
Alamos National Laboratory (LANL), which is operated by Los Alamos
National Security, LLC for the U.S. Department of Energy. The
U.S. Government has rights to use, reproduce, and distribute this
software.  NEITHER THE GOVERNMENT NOR LOS ALAMOS NATIONAL SECURITY,
LLC MAKES ANY WARRANTY, EXPRESS OR IMPLIED, OR ASSUMES ANY LIABILITY
FOR THE USE OF THIS SOFTWARE.  If software is modified to produce
derivative works, such modified software should be clearly marked, so
as not to confuse it with the version available from LANL.
 
Additionally, redistribution and use in source and binary forms, with
or without modification, are permitted provided that the following
conditions are met:

1.  Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
2.  Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
3.  Neither the name of Los Alamos National Security, LLC, Los Alamos
National Laboratory, LANL, the U.S. Government, nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.
 
THIS SOFTWARE IS PROVIDED BY LOS ALAMOS NATIONAL SECURITY, LLC AND
CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LOS
ALAMOS NATIONAL SECURITY, LLC OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/**
 * @file   LogicalRegion.hh
 * @author Rao Garimella
 * @date
 *
 * @brief  Declaration of Logical Region class which derives
 *         an operation on one or two other regions
 *
 *
 */

#ifndef _LogicalRegion_hh_
#define _LogicalRegion_hh_

#include <vector>
#include <string>

#include "Region.hh"

namespace JaliGeometry {

// -------------------------------------------------------------
//  class LogicalRegion
// -------------------------------------------------------------
/// A region defined by a logical operation on one or two other regions
///
/// Operations supported on a single region are only the NOT operation
///
/// Operations supported on a pair of regions are UNION, SUBTRACT and
/// INTERSECT
///

class LogicalRegion : public Region {
 public:

  /// Default constructor

  LogicalRegion(const std::string name,
                const unsigned int id,
                const std::string operation_str,
                const std::vector<std::string> region_names,
                const LifeCycle_type lifecycle = LifeCycle_type::PERMANENT);


  LogicalRegion(const std::string,
                const unsigned int id,
                const Bool_type bool_op_type,
                const std::vector<std::string> region_names,
                const LifeCycle_type lifecycle = LifeCycle_type::PERMANENT);


  /// Protected copy constructor to avoid unwanted copies.
  LogicalRegion(const LogicalRegion& old);

  /// Destructor
  ~LogicalRegion(void);

  // Type of the region
  inline Region_type type() const { return Region_type::LOGICAL; }

  // Label in the file
  inline JaliGeometry::Bool_type operation() const { return operation_; }

  /// Is the the specified point inside this region
  bool inside(const Point& p) const;

  inline std::vector<std::string> const &component_regions() const
  { return region_names_; }


 protected:
  JaliGeometry::Bool_type operation_;  // logical operation to be performed
  const std::vector<std::string> region_names_;  // participating region names
};

/// A smart pointer to LogicalRegion instances
// typedef Teuchos::RCP<LogicalRegion> LogicalRegionPtr;

// RVG: I am not able to correctly code a region factory using smart
// pointers so I will revert to a simpler definition

typedef LogicalRegion *LogicalRegionPtr;

}  // namespace JaliGeometry


#endif