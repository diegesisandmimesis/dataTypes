# dataTypes

A TADS3/adv3 module providing several basic data structures.

## Description

This is a TADS3/adv3 module providing classes for graphs (in the graph theory
sense), rules and rulebooks, finite state machines, and Markov chains, as
well as an abstract action tuple class and an action trigger class.

This module is intended for the data structures themselves.  The only
automation provided by the module is related to initialization of the
various classes: adding vertices to graphs via standard TADS3 lexical
inheritence rules, for example.  For more advanced features, like automating
state machine state transitions, see
the [eventScheduler](https://github.com/diegesisandmimesis/eventScheduler)
module.

## Table of Contents

[Getting Started](#getting-started)

[Data Types](#data-types)
 * [Graph](#graph-section)
   * [Graph](#graph)
   * [Vertex](#vertex)
   * [Edge](#edge)
 * [Finite State Machine](#fsm-section)
   * [FSM](#fsm)
   * [FSMState](#fsm-state)
   * [Transition](#fsm-transition)
 * [Markov Chain](#markov-section)
   * [MarkovChain](#markov-chain)
   * [MarkovState](#markov-state)
   * [MarkovTransition](#markov-transition)
 * [Rulebook](#rulebook-section)
   * [Rulebook](#rulebook)
   * [Rule](#rule)
 * [Tuple](#tuple)
 * [Trigger](#trigger)

## Getting Started

### Dependencies

* TADS 3.1.3
* adv3 3.1.3
* git

### Installing

All of the [diegesisandmimesis](https://github.com/diegesisandmimesis) modules
are designed to be installed and used from a common base install directory.

In this example we'll use ``/home/username/tads`` as the base directory.

* Create the module base directory if it doesn't already exists:

`mkdir -p /home/username/tads`

* Make it the current directory:

``cd /home/username/tads``

* Clone this repo:

``git clone https://github.com/diegesisandmimesis/dataTypes.git``

### Compiling and Running Demos


<a name="data-types"/></a>
## Data Types

<a name="graph-section"/></a>
### Graph

In this module graph consists of three kinds of components:  a single
``Graph`` instance; one or more ``Vertex`` instances; and one or more ``Edge``
instances.

In general vertices and edges should be managed via the methods on ``Graph``
rather than by directly manipulating the individual ``Vertex`` and ``Edge``
objects.

<a name="graph"/></a>
#### Graph

##### Properties

* ``directed = nil``

  Boolean indicating whether or not the graph is directed.

* ``vertexClass = Vertex``

  Default class to use when creating vertices.

* ``edgeClass = Edge``

  Default class to use when creating edges.

##### Methods

* **Vertex Methods**
 * ``addVertex(vertexID, vertexInstance?)``

   Adds a vertex to the graph, creating a new ``Vertex`` instance if one is
   not provided.

   Returns the added ``Vertex``.

 * ``getVertex(vertexID)``

   Returns the given ``Vertex`` or ``nil`` on failure.

 * ``removeVertex(vertex)``

   Removes the given vertex.  Argument can be the vertex ID or the
   ``Vertex`` instance.

 * ``getVertices()``

   Returns a ``Vector`` of the graph's ``Vertex`` instances.

 * ``getVertexIDs()``

   Returns a ``Vector`` of the graph's vertex IDs.

* **Edge Methods**

 * ``addEdge(vertex0, vertex1, edgeInstance?)``

   Adds an edge to the graph, creating a new ``Edge`` instance if one is
   not given.

   The first two arguments specify the vertices connected by the edge.
   They can be either vertex IDs or ``Vertex`` instances.

 * ``getEdge(vertex0, vertex1)``

   Returns the given ``Edge`` or ``nil`` if it does not exist.

   The arguments can be either vertex IDs or ``Vertex`` instances.

 * ``removeEdge(vertex0, vertex1)``

    Removes the given edge.  Returns ``true`` on success, ``nil`` otherwise.

    The arguments can be either vertex IDs or ``Vertex`` instances.

 * ``getEdges()``

    Returns a ``Vector`` containing all of the graph's ``Edge`` instances.

 * ``createEdge(vertex0, vertex1, length?, directed?)``

    Convenience method for creating a new ``Edge`` instance.

    The vertices can be IDs or ``Vertex`` instances.

    The ``length`` and ``directed`` arguments are optional.  If given,
    ``length`` is the length of the edge and ``directed`` is a boolean
    indicating whether or not the edge is directed.  Both take their
    default values from the ``edgeClass`` defined on the graph.

##### Subclasses

* ``Graph``

  The base class.  Undirected.

* ``DirectedGraph``

  Class for directed graphs.

<a name="vertex"/></a>
#### Vertex

##### Properties

* ``vertexID = nil``

  Unique-ish ID for the vertex.  Should be a single-quoted string.

##### Methods

* ``addEdge(vertexInstance, edgeInstance)``

  Add an edge to this vertex.  Arguments must be instances, not IDs.

  Returns boolean ``true`` on success, ``nil`` otherwise.

* ``getEdge(vertexInstance)``

  Returns the edge connecting this vertex to the given vertex, if one
  exists.  Returns ``nil`` if no such edge exists.

* ``getEdges()``

  Returns a ``List`` of all of the vertice's ``Edge`` instances.

* ``getEdgeIDs()``

  Returns ` ``List`` of all of the vertice's edge IDs.

* ``removeEdge(vertexInstance)``

  Removes the given vertex.

  Returns boolean ``true`` on success, ``nil`` otherwise.

* ``removeEdges()``

  Removes all of the vertex's edges.

* ``getDegree()``

  Returns the number of edges on this vertex.

* ``isAdjacent(vertexID)``

  Returns boolean ``true`` if the vertex is adjacent to a vertex with the given
  vertex ID, ``nil`` otherwise.

<a name="edge"/></a>
#### Edge

##### Properties

* ``length = 1``

  The edge length.

* ``vertex0 = nil``

  ``vertex1 = nil``

  ``Vertex`` instances connected by this edge.  In a directed graph
  the edge connects ``vertex0`` to ``vertex1``.  In an undirected graph
  the order is arbitrary.

##### Methods

* ``getLength()``

  Returns the edge length.

* ``setLength(length)``

  Sets the edge length.

  The argument should be a numeric value.  By default most classes expect an
  integer length, but some (like ``MarkovChain``) use floating point lengths.

##### Subclasses

* ``Edge``

  The base class.  Undirected.

* ``DirectedEdge``

  Class for directed edges.


<a name="fsm-section"/></a>
### FiniteStateMachine

A finite state machine consists of a set of states of which exactly one is
always the current state, and a set of allowed transitions between states.

In this module ``FiniteStateMachine`` (or ``FSM``) is a kind of
``DirectedGraph``, ``FiniteStateMachineState`` (or ``FSMState``) is a kind
of ``Vertex``, and ``FiniteStateMachineTransition`` (or ``Transition``) is a
kind of ``Edge``.

<a name="fsm"/></a>
#### FSM

##### Properties

* ``currentState = nil``

  The FSM's current state.  When non-``nil``, should be an instance
  of ``FSMState``.

* ``stateClass = FiniteStateMachineState``

  Class to use when creating new states.

* ``transitionClass = FiniteStateMachineTransition``

  Class to use when creating new transitions.

##### Methods

* ``addFSMState(stateID, fsmState?)``

  Adds a state to the machine, creating a new ``FSMState`` instance if
  one is not provided.

  Returns the added ``FSMState``.

* ``getFSMState()``

  Returns the current state.

* ``getFSMStateID()``

  Returns the state ID of the current state.

* ``setFSMState(state)``

  Sets the current state.  This method doesn't check the validity of the
  state transition, it merely handles updating the state.  Most callers
  should probably use ``toFSMState()`` instead, unless bypassing the normal
  state transition logic is desired.

  The argument can be either a state ID or ``FSMState`` instance.

* ``toFSMState(state)``

  Handle a state transition to the requested state.  This method will
  verify that the state transition is valid, returning ``true`` on
  success and ``nil`` otherwise.

  The argument can be either a state ID or ``FSMState`` instance.

<a name="fsm-state"/></a>
#### FSMState

##### Properties

* ``active = true``

  Boolean flag indicating whether or not the state is currentl active.  Note
  that this is not the same thing as being the FSM's current state.  The
  active flag indicates whether or not the state is *eligible* to become
  the current state.

* ``stateID = nil``

  The state's ID.  This should be a single-quoted string.

##### Methods

* ``isActive()``

  Returns boolean ``true`` if the state is currently active (see note on
  the ``active`` property above), ``nil`` otherwise.

* ``setActive(val)``

  Sets the state's ``active`` property to ``true`` if the argument is ``true``,
  sets it to ``nil`` otherwise.

<a name="fsm-transition"/></a>
#### Transition

##### Methods

* ``getFSM()``

  Returns the state's parent finite state machine.

* ``getFSMState()``

  Returns the parent FSM's current state.  Return value will be a
  ``FSMState`` instance.

* ``getFSMStateID()``

  Returns the state ID of the parent FSM's current state.

<a name="markov-section"/></a>
### MarkovChain

A Markov chain is a state machine with probabilistic state transitions.

A state machine is a directed graph, at any time one vertex is the current
state, and the edges leading from the current state to adjacent states
represent allowed state transitions.

In this Markov chain implementation, the length of an edge represents the
probability of the transition it represents.

Edge lengths can be declared as floating point numbers or as integers.

If floating point numbers are used then they will be interpreted as decimal
percentages:  0.25 is a 25% chance of picking that transition, 0.33 is a 33%
chance, and so on.  In this case all edges leading away from each state/vertex
should sum to 1.0.

If integers are used then they will be used as weights, with the probability
of a transition being the ratio of the individual edge weight to the sum
of the edge weights of all edges leading away from the state/vertex.  For
example if there are two edges with weights 250 and 750, then the first
will be selected 25% of the time and the other 75% of the time.  Equivalently
the weights could be given as 1 and 3, respectively.

If floating point probabilities are used in declaring a Markov chain they
will be converted at preinit into integer weights.

<a name="markov-chain"/></a>
#### MarkovChain

##### Properties

* ``markovBaseWeight = 1000``

The base weight to use for edges.  Only used if an explicit weight is not
given.

* ``stateClass = MarkovState``

Class to use when creating new Markov states.

* ``transitionClass = MarkovTransition``

Class to use when creating new Markov transitions.

##### Methods

* ``getPRNG()``

  ``setPRNG(prngInstance)``

  Getter and setter for the chain's PRNG.  Useful if compiling with the
  [notReallyRandom](https://github.com/diegesisandmimesis/notReallyRandom)
  module.

  If not specified, ``MarkovChain`` will default to using TADS3's native
  ``rand()`` for randomness.

* ``getWeight(state0, state1)``

  Returns the transition weight for the transition from the first state to
  the second state.  Arguments can be either state IDs or ``MarkovState``
  instances.

  Returns ``0`` (not ``nil``) if the transition in question does not exist
  or is not valid.

* ``setWeight(state0, state1, weight)``

  Sets the weight on the edge from the first state to the second.  States
  may be specified via state ID or as ``MarkovState`` instances.  The weight
  should be an integer weight.

* ``pickTransition(fromState?, prng?)``

  Picks a random, weighted state transition.

  The optional first argument is the state to start from, defaulting to
  the Markov chain's current state.  If given the state can either be
  a state ID or a ``MarkovState`` instance.

  The optional second argument is a PRNG instance.  If none is given,
  TADS3's ``rand()`` will be used.

  Calling this method will attempt to change the Markov chain's state.

  Return value is the state ID of the new state, or ``nil`` on error.

<a name="markov-state"/></a>
#### MarkovState

##### Methods

* ``getTransitions()``

  Returns a ``List`` containing all of this state's ``MarkovTransition``
  instances.

* ``pickTransition(prng?)``

  Select a random, weighted state transition.

  This method will not change the state of the parent Markov chain, it
  merely runs through the random selection process and reports the result.

  Return value will be the selected ``MarkovTransition``.

<a name="markov-transition"/></a>
#### MarkovTransition

##### Properties

* ``markovBaseWeight = 1000``

The base weight for this transition.  This property should probably not be
edited as it is set by the parent ``MarkovChain`` during initialization.

##### Methods

* ``getWeight()``

  ``setWeight(weight)``

  Getter and setter for the transition weight.  These should probably not
  be used directly, the corresponding methods on ``MarkovChain`` should
  probably be used instead.

<a name="rulebook-section"/></a>
### Rulebook

<a name="rulebook"/></a>
#### Rulebook
<a name="rule"/></a>
#### Rule

<a name="tuple"/></a>
### Tuple

#### Tuple

<a name="trigger"/></a>
### Trigger

#### Trigger
