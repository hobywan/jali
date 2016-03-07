/*---------------------------------------------------------------------------~*
 * Copyright (c) 2015 Los Alamos National Security, LLC
 * All rights reserved.
 *---------------------------------------------------------------------------~*/

#ifndef JALI_STATE_H_
#define JALI_STATE_H_

/*!
  @class State jali_state.h
  @brief State is a class that stores all of the state data associated 
  with a mesh
*/

#include <iostream>
#include <vector>
#include <string>
#include <boost/iterator/permutation_iterator.hpp>

#include "Mesh.hh"    // Jali mesh header

#include "JaliStateVector.h"  // Jali-based state vector


namespace Jali {

class State {
 public:
  
  //! Constructor
  
  State(Jali::Mesh * const mesh) : mymesh_(mesh) {}
  
  // Copy constructor (disabled)
  
  State(const State &) = delete;
           
  // Assignment operator (disabled)
              
  State & operator=(const State &) = delete;
                   
  //! Destructor
                       
  ~State() {}
                           
  //! Typedefs for iterators for going through all the state vectors

  typedef std::vector<std::shared_ptr<BaseStateVector>>::iterator iterator;
  typedef
  std::vector<std::shared_ptr<BaseStateVector>>::const_iterator const_iterator;
  typedef std::vector<std::string>::iterator string_iterator;

  //! Typedef for permutation iterators to allow iteration through only
  //! the state vectors on a specified entity

  typedef
  boost::permutation_iterator<std::vector<std::shared_ptr<BaseStateVector>>::iterator, std::vector<int>::iterator> permutation_type;

  //! Typedef for permutation iterators to allow iteration through only
  //! the state vector _names_ on a specified entity

  typedef boost::permutation_iterator<std::vector<std::string>::iterator,
                                      std::vector<int>::iterator>
  string_permutation;

  
  iterator begin() {return state_vectors_.begin();}
  iterator end() {return state_vectors_.end();}
  const_iterator cbegin() const {return state_vectors_.begin();}
  const_iterator cend() const {return state_vectors_.end();}

  //! Iterators for vector names

  string_iterator names_begin() {return names_.begin();}
  string_iterator names_end()   {return names_.end();}

  //! Permutation iterators for iterating over state vectors on a
  //! specific entity type

  permutation_type entity_begin(Jali::Entity_kind entitykind) {
    return
        boost::make_permutation_iterator(state_vectors_.begin(),
                                         entity_indexes_[entitykind].begin());
  }
  permutation_type entity_end(Jali::Entity_kind entitykind) {
    return
        boost::make_permutation_iterator(state_vectors_.begin(),
                                         entity_indexes_[entitykind].end());
  }

  //! Iterators for vector names of specific entity types
  
  string_permutation names_entity_begin(Jali::Entity_kind entitykind) {
    return
        boost::make_permutation_iterator(names_.begin(),
                                         entity_indexes_[entitykind].begin());
  }
  string_permutation names_entity_end(Jali::Entity_kind entitykind) {
    return
        boost::make_permutation_iterator(names_.begin(),
                                         entity_indexes_[entitykind].end());
  }

  //! References to state vectors
  
  typedef std::shared_ptr<BaseStateVector> pointer;
  typedef const std::shared_ptr<BaseStateVector> const_pointer;

  //! Return pointer to i'th state vector
  pointer operator[](int i) { return state_vectors_[i]; }

  //! Return const pointer to the i'th state vector
  const_pointer operator[](int i) const { return state_vectors_[i]; }
  
  //! Number of state vectors
  int size() const {return state_vectors_.size();}


  //! \brief Find state vector

  //! Find iterator to state vector by name and what type of entity it
  //! is on.  The type of entity (parameter on_what) may be specified
  //! as ANY_KIND if caller does not care if the vector is on a
  //! particular entity type or knows that there is only one vector by
  //! this name defined on a specific entity kind. The function
  //! returns an iterator to a state vector in the state manager if
  //! found; otherwise, it returns State::end()

  iterator find(std::string const name, Entity_kind const on_what) {
    iterator it = state_vectors_.begin();
    while (it != state_vectors_.end()) {
      BaseStateVector const & vector = *(*it);
      if ((vector.name() == name) &&
          ((on_what == ANY_KIND) || (vector.on_what() == on_what)))
        break;
      else
        ++it;
    }
    return it;
  }

  //! Find state vector by name and what type of entity it is on - const version

  //! Find const_iterator to state vector by name and what type of
  //! entity it is on.  The type of entity (parameter on_what) may be
  //! specified as ANY_KIND if caller does not care if the vector is
  //! on a particular entity type or knows that there is only one
  //! vector by this name defined on a specific entity kind. The
  //! function returns an iterator to a state vector in the state
  //! manager if found; otherwise, it returns State::end()

  const_iterator find(std::string const name,
                      Jali::Entity_kind const on_what) const {
    const_iterator it = state_vectors_.cbegin();
    while (it != state_vectors_.cend()) {
      BaseStateVector const & vector = *(*it);
      if ((vector.name() == name) &&
          ((on_what == Entity_kind::ANY_KIND) || (vector.on_what() == on_what)))
        break;
      else
        ++it;
    }
    return it;
  }

  //! \brief Get state vector
  
  //! Get a statevector with the given name and particular entity kind
  //! it is on. The function returns true if such a vector was found;
  //! false otherwise. The caller must know the type of elements in
  //! the state vector, int, double, std::array<double,3> or whatever
  //! else. The calling routine must declare the state vector as "T
  //! vector" where T is StateVector<int> or StateVector<double> or
  //! StateVector<some_other_type>. Even though this is a copy into
  //! *vector, its an inexpensive shallow copy of the meta data only

  template <class T>
    bool get(std::string const name, Jali::Entity_kind const on_what,
             StateVector<T> *vector) {
    
    iterator it = find(name, on_what);
    if (it != state_vectors_.end()) {
      *vector = *(std::static_pointer_cast<StateVector<T>>(*it));
      return true;
    } else {
      return false;
    }
  }

  //! \brief Get state vector
  
  //! Get a shared_ptr to a statevector with the given name and
  //! particular entity kind it is on. The function returns true if
  //! such a vector was found; false otherwise. The caller must know
  //! the type of elements in the state vector, int, double,
  //! std::array<double,3> or whatever else. The calling routine must
  //! declare the state vector as "std::shared_ptr<T> vector" where T
  //! is StateVector<int> or StateVector<double> or
  //! StateVector<some_other_type>

  template <class T>
  bool get(std::string const name, Jali::Entity_kind const on_what,
           std::shared_ptr<StateVector<T>> *vector_ptr) {    
    iterator it = find(name, on_what);
    if (it != state_vectors_.end()) {
      *vector_ptr = std::static_pointer_cast<StateVector<T>>(*it);
      return true;
    } else {
      return false;
    }
  }

  //! \brief Add state vector

  //! Add state vector - returns reference to the added StateVector.
  //! The data is copied from the input memory location into an
  //! internal buffer.

  template <class T>
    StateVector<T> & add(std::string const name,
                         Jali::Entity_kind const on_what, T* data) {
    iterator it = find(name, on_what);
    if (it == end()) {
      // a search of the state vectors by name and kind of entity turned up
      // empty, so add the vector to the list; if not, warn about duplicate
      // state data
    
      std::shared_ptr<StateVector<T>> vector(new StateVector<T>(name, on_what,
                                                                mymesh_, data));
      state_vectors_.emplace_back(vector);
    
      // add the index of this vector in state_vectors_ to the vector of
      // indexes for this entity type, to allow iteration over state
      // vectors on this entity type with a permutation iterator

      entity_indexes_[on_what].emplace_back(state_vectors_.size()-1);
      names_.emplace_back(name);

      // emplace back may cause reallocation of the vector so the iterator
      // may not be valid. Use [] operator to get reference to vector

      return (*vector);
    } else {
      // found a state vector by same name
      std::cerr <<
          "Attempted to add duplicate state vector. Ignoring\n" << std::endl;
      return (*(std::static_pointer_cast<StateVector<T>>(*it)));
    }
  };



  //! Add a new state vector to the state manager based on data from
  //! the input state vector. Meta data is copied from one vector to
  //! another and A DEEP COPY IS MADE of the input vector data

  template <class T>
  StateVector<T> & add(StateVector<T>& in_vector) {
    iterator it = find(in_vector.name(), in_vector.on_what());
    if (it == end()) {
      
      // a search of the state vectors by name and kind of entity turned up
      // empty, so add the vector to the list
      if (mymesh_ != in_vector.mesh()) {
      
        // the input vector is defined on a different mesh? copy the
        // vector data onto a vector defined on mymesh and then add
        std::shared_ptr<StateVector<T>> 
          vector_copy(new StateVector<T>(in_vector.name(), in_vector.on_what(),
                                         mymesh_, &(in_vector[0])));
        state_vectors_.emplace_back(vector_copy);
      } else {
        std::shared_ptr<StateVector<T>>
            vector_copy(new StateVector<T>(in_vector));
        state_vectors_.emplace_back(vector_copy);
      }

      // add the index of this vector in state_vectors_ to the vector of
      // indexes for this entity type, to allow iteration over state
      // vectors on this entity type with a permutation iterator

      entity_indexes_[in_vector.on_what()].emplace_back(state_vectors_.size()-1);
      names_.emplace_back(in_vector.name());

      // emplace back may cause reallocation of the vector so the iterator
      // may not be valid. Use [] operator to get reference to vector

      int nvec = state_vectors_.size();
      return
          (*(std::static_pointer_cast<StateVector<T>>(state_vectors_[nvec-1])));
    } else {
      // found a state vector by same name
    
      std::cerr << "Attempted to add duplicate state vector. Ignoring\n" <<
          std::endl;
      return in_vector;
    }

  };


  //! \brief Import field data from mesh
  //! Initialize state vectors in the statemanager from mesh field data
  
  void init_from_mesh();


  //! \brief Export field data to mesh
  //! Export data from state vectors to mesh fields

  void export_to_mesh();


 private:
  
  //! Constant pointer to the mesh associated with this state
  Jali::Mesh * const mymesh_;

  //! All the state vectors
  std::vector<std::shared_ptr<BaseStateVector>> state_vectors_;

  //! Stores which indices of state_vectors_ correspond to data stored
  //! on each entity kind
  std::vector<int> entity_indexes_[NUM_ENTITY_KINDS];

  //! Names of the state vectors
  std::vector<std::string> names_;

};


std::ostream & operator<<(std::ostream & os, State const & s);

}  // namespace Jali
  
#endif  // JALI_STATE_H_
