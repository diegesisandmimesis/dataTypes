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
* [Dependencies](#dependencies)
* [Installing](#install)
* [Compiling and Running Demos](#running)

[Data Types](#data-types)
* [Graphs](#graph-section)
  * [Graph](#graph)
  * [Vertex](#vertex)
  * [Edge](#edge)
  * [AdjacencyMatrix](#adjacency-matrix)
* [Finite State Machines](#fsm-section)
  * [FSM](#fsm)
  * [FSMState](#fsm-state)
  * [Transition](#fsm-transition)
* [Markov Chains](#markov-section)
  * [MarkovChain](#markov-chain)
  * [MarkovState](#markov-state)
  * [MarkovTransition](#markov-transition)
* [Rules and Rulebooks](#rulebook-section)
  * [RuleObject](#rule-object)
  * [Rule](#rule)
  * [Rulebook](#rulebook)
* [Tuple](#tuple)
* [Trigger](#trigger)
* [HashTable](#hashTable)
* [Matrix](#matrix)
* [TS](#ts)
* [TSProf](#tsProf)
* [Recursive Backtracker](#bt-section)
  * [BT](#bt)
  * [BTStack](#btStack)
  * [BTFrame](#btFrame)
* [XY](#xy)
* [Rectangle](#rectangle)
* [LineSegment](#linesegment)
* [QuadTree](#quadtree)
* [RTree](#rtree)

[Changes To Stock Classes](#changes)
* [Collection](#collection)
* [TadsObject](#tads-object)
* [Vector](#vector)
* [LookupTable](#lookuptable)

[Macros](#macros)
* [Type Tests](#type-tests)
* [General Utility](#general-utility)
* [Module Specific](#module-specific)

<a name="getting-started"/></a>
## Getting Started

<a name="dependencies"/></a>
### Dependencies

* TADS 3.1.3
* adv3 3.1.3

  These are the most recent versions of the TADS3 VM and adv3 library.

  Any TADS3 toolkit with these versions should work, although all of the
  [diegesisandmimesis](https://github.com/diegesisandmimesis) modules are
  primarily tested with [frobTADS](https://github.com/realnc/frobtads).

* git

  This module is distributed via github, so you'll need some way of
  cloning a git repo to obtain it.

  The process should be similar on any platform using any tools, but the
  command line examples given below were tested on an Ubuntu linux
  machine.  Other OSes and git tools will have a slightly different usage.

<a name="install"/></a>
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

After the ``git`` command, the module source will be in
``/home/username/tads/dataTypes``.

<a name="running"/></a>
### Compiling and Running Demos

Once the repo has been cloned you should be able to ``cd`` into the
``./demo/`` subdirectory and compile the demonstration/test code that
comes with the module.

All the demos are structured in the expectation that they will be compiled
and run from the ``./demo/`` directory.  Again assuming that the module
is installed in ``/home/username/tads/dataTypes/``, enter the directory with:
```
# cd /home/username/tads/dataTypes/demo
```
Then make one of the demos, for example:
```
# make -a -f rulebookTest.t3m
```
This should produce a bunch of output from the compiler but no errors.  When
it is done you can run the demo from the same directory with:
```
# frob games/rulebookTest.t3
```
In general the name of the makefile and the name of the compiled story file
will be the same except for the extensions (``.t3m`` for makefiles and
``.t3`` for story files).


<a name="data-types"/></a>
## Data Types

<a name="graph-section"/></a>
### Graphs

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

  * ``testVertices(fn)``

    Returns boolean ``true`` if test function ``fn`` returns boolean ``true``
    for each vertex.

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

* **General Methods**

  * ``adjacencyMatrix(vertexList?)``

    Returns an ``AdjacencyMatrix`` instance for this graph.  Optional
    argument is a list of vertex IDs to use for the ordering of the
    matrix.  If no argument is given the vertex IDs are sorted in
    ASCIIbetical order.

  * ``clone()``

    Returns a shallow copy of the graph.

    This creates a dupilcate ``Graph`` instance containing the same vertex
    IDs and edges as the calling graph.  It **does not** copy any data
    defined on the vertices or edges.

  * ``difference(g)``

    Returns a new ``Graph`` instance containing the difference of the
    calling graph and the argument graph.

  * ``equals(g)``

    Returns boolean ``true`` if the argument, which must be a ``Graph``
    instance, has the same vertices and edges as the calling graph.

  * ``join(g, v0, v1, recip?, destruct?)``

    Adds the vertices and edges in the argument graph ``g`` to the
    calling graph.  Vertex ``v0`` in the calling graph will be
    connected to vertex ``v1`` in the argument graph.  If the graphs
    are directed and the ``recip`` argument is boolean ``true`` an
    edge from ``v1`` to ``v0`` will also be added.

    This will always modify the calling graph.  If the ``destruct``
    argument is boolean ``true`` the vertices and edges from the
    argument graph will be moved from the argument graph into
    the calling graph, modifying the argument graph.  If the
    ``destruct`` argument is **not** boolean ``true`` new edges
    and vertices will be created and the argument graph will
    not be modified.  The former case is intended for cases where
    edges and vertices might have bespoke data on them that needs
    to be preserved in the new graph.

  * ``intersection(g)``

    Returns a new ``Graph`` instance containing the intersection of the
    calling graph and the argument graph.

  * ``mergeVertices(v0, v1)``

    Merges vertex ``v1`` into ``v0``, removing ``v1`` in the process.

    In this module this means removing all edges from ``v0`` and
    connecting them to ``v1`` instead.  Subclasses are responsible
    for overriding the method to handle any subclass-specific data
    on the vertices or edges that needs to be transferred.

  * ``union(g)``

    Returns a new ``Graph`` instance consisting of the union of the calling
    graph and the argument graph.

##### Subclasses

* ``Graph``

  The base class.  Undirected.

* ``DirectedGraph``

  Class for directed graphs.

##### Examples

There are multiple syntaxes which may be used to declare a ``Graph``
instance.

First is the "long form" declaration, using the standard TADS3 lexical
``+`` syntax:
```
// "Long form" graph declaration.
graph: DirectedGraph;
+foo: Vertex 'foo';
++Edge ->bar;
++Edge ->baz;
+bar: Vertex 'bar';
++Edge ->foo;
++Edge ->baz;
+baz: Vertex 'baz';
++Edge ->foo;
++Edge ->bar;
```

This will create a graph with three vertices, ``foo``, ``bar``, and ``baz``,
each of which is connected to all of the others.

This is equivalent to:
```
// Same as above, using IDs instead of obj references in edge declarations
graph: DirectedGraph;
+Vertex 'foo';
++Edge 'bar';
++Edge 'baz';
+Vertex 'bar';
++Edge 'foo';
++Edge 'baz';
+Vertex 'baz';
++Edge 'foo';
++Edge 'bar';
```

Graphs can also be declared using two arrays:  one of the vertex IDs and then a
"flattened" adjacency matrix.  For example:
```
// "Short form" graph declaration
graph: DirectedGraph
        [       'foo',  'bar',  'baz' ]
        [
                0,      1,      1,	// edges from "foo"...
                1,      0,      1,	// edges from "bar"...
                1,      1,      0	// edges from "baz"...
        ]
;
```
The first array enumerates the vertex IDs, and the second is a one-dimensional
array that works like a flattened 2D matrix.  Each element is the length of
the corresponding edge.  So reading off the example above, the edge from
"foo" to "foo" is length zero (it doesn't exist).  Then (next element in the
array) the length of the edge from "foo" to "bar" is 1.  Then the length of
the edge from "foo" to "baz" is 1.  Next row, "bar" to "foo" is 1, "bar" to
"bar" is zero, and "bar" to "baz" is 1.  Finally "baz" to "foo" is 1,
"baz" to "bar" is 1, and "baz" to "baz" is 0.

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

<a name="adjacency-matrix"/></a>
#### Adjacency Matrix

A utility class used to hold an adjacency matrix representation of a graph.
This includes the vertex list (in a canonical ordering) and a matrix
describing the edges connecting them.

Example:

Given a three-vertex graph consisting of vertices foo, bar, and baz each
connected to both of the others, the ``AdjacencyMatrix`` would consist
of a list of the vertex IDs in ASCIIbetical order:
```
     [ 'bar', 'baz', 'foo' ]
```
...and a matrix...
```
     0     1     1
     1     0     1
     1     1     0
```
...where the coordinates left to right and top to bottom are 'bar', 'baz',
and 'foo' (in that order) and the intersection is the answer to "what is
the length of the edge between" the two vertices, with zero indicating
no edge.

##### Methods

* ``getVertices()``

  Returns the vertex list.

* ``getMatrix()``

  Returns the matrix.

<a name="fsm-section"/></a>
### Finite State Machines

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
### Markov Chains

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

##### Examples

The format for declaring Markov Chains is largely the same as for ``Graph``.
The main difference is the addition of an initialization vector, which
defines the probabilities used for assigning the initial state:

```
chain: MarkovChain
        [       'foo',  'bar',  'baz'   ]
        [
                0,      0.75,   0.25,
                0.67,   0,      0.33,
                0.5,    0.5,    0
        ]
        [       0.34,   0.33,   0.33    ]
;
```

This creates a Markov chain with the following:
* Three states: "foo", "bar", and "baz" (defined in the first array)
* State "foo" transitions to "bar" 75% of the time and "baz" 25% of the time
(defined in the first row of the second array)
* State "bar" transitions to "foo" 67% of the time and "baz" 33% of the time
(defined in the second row of the second array)
* State "baz" transitions to "foo" or "bar" with equal probability (defined
in the third row of the second array)
* The initial state is "foo" 34% of the time, "bar" 33% of the time, and
"baz" 33% of the time

Note that each row's probabilities sum to 100% (which is the reason the
initial probabilities are not *quite* equal).

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
### Rules and Rulebooks

In this module a rulebook is a data structure containing one or more rules.
Each rule consists of a method implementing some arbitrary check and
returning a boolean ``true`` or ``nil`` value.  The returned value is then
the value of the rule itself.  And the rulebook in turn has a boolean
``true`` or ``nil`` value based on the value of its rules.

The base ``Rulebook`` superclass has several subclasses for different
basic rulebook behaviors:

* ``RulebookMatchAll`` is a rulebook whose default value is ``nil`` and
  becomes ``true`` when **all** of its rules are ``true``

* ``RulebookMatchAny`` is a rulebook whose default value is ``nil`` and
  becomes ``true`` when **any** of its rules are ``true``

* ``RulebookMatchNone`` is a rulebook whose default value is ``true`` and
  becomes ``nil`` when **any** of its rules are ``true``


<a name="rule-object"/></a>
#### RuleObject

The ``RuleObject`` class is the base for both ``Rule`` and ``Rulebook``,
providing most of the base lifecycle methods.

##### Properties

* ``active = true``

  Boolean indicating if the rule/rulebook is currently active.  This is
  **not** the same as the *value*.  The ``active`` flag rather determines
  whether or not the rule/rulebook should even be evaluated.

* ``value = nil``

  The current value of the rule or rulebook.  This property should not be
  set directly.

* ``defaultValue = nil``

  The default value.  The value of the object will be this unless and until
  the match() method (below) returns ``true``, at which point the value
  will be the inverse of the default value.

##### Methods

* ``isActive()``

  ``setActive(active?)``

  Getter and setter for the ``active`` property.

* ``getValue()``

  ``setValue(newValue?)``

  Getter and setter for the object's ``value`` property.  This method
  implements no checks or special logic, it merely handles the nuts and bolts
  task of manipulating the underlying ``value`` property.

  These methods should probably not be called directly;  the value should
  normally be set by calling the ``eval()`` method (below) to figure out
  what the value should be.

* ``eval(data?)``

  Evaluate the current value of the rule/rulebook.  The argument is an
  arbitrary data object.

  This method first checks to see if the value *should* be evaluated when
  it is called (e.g. if the rule/rulebook is currently active).  If so
  it will then call the ``match()`` method to apply whatever bespoke
  logic the rule or rulebook implements.

  This method will update the object's value (which can then be read
  via ``getValue()``.

  The return value is boolean ``true`` if the value was updated, ``nil``
  otherwise.  It is **not** the value itself.

* ``updateValue()``

Returns boolean ``true`` if the rule/rulebook's value should be updated.

* ``match(data?)``

Method for applying whatever logic the rule or rulebook implements.

This is designed to be overwritten by instances and subclasses to do
whatever arbitrary checks the game logic needs.  It need not, and should
not, implement any checks, try to save or update the object's value itself,
or anything like that.

The argument is an arbitrary data object.

<a name="rule"/></a>
#### Rule

##### Properties

* ``ruleID = nil``

  Unique-ish ID for this rule.

* ``rulebook = nil``

  The rulebook this rule is in.

##### Methods

* ``getRulebook()``

  Returns this rule's parent ``Rulebook``.

<a name="rulebook"/></a>
#### Rulebook

##### Properties

* ``rulebookID = nil``

Unique-ish ID for this rulebook.

##### Methods

* ``addRule(ruleObj)``

  Adds a ``Rule`` instance to our list.

  Returns boolean ``true`` on success, ``nil`` otherwise.

* ``removeRule(ruleObj)``

  Removes a ``Rule`` instance from our list.

  Returns boolean ``true`` on success, ``nil`` otherwise.

* ``checkRule(ruleObj, data?)``

  Method for checking an individual rule.

  First argument is the ``Rule`` instance being checked.  Second argument
  is an arbitrary data object.

  This is intended to make it easier for subclasses to implement decisions
  about when and how to check rules.

<a name="tuple"/></a>
### Tuple

A ``Tuple`` is a data structure for holding basic information about a turn
and its action.

#### Tuple

##### Properties

* ``action = nil``

  An ``Action`` instance.

* ``dstActor = nil``

  The ``Actor`` instance receiving the action.  If ``dstObject`` is not
  ``nil`` this will probably be ``dstObject.getCarryingActor()``.

* ``dstObject = nil``

  The ``Object`` instance receiving the action.

* ``room = nil``

  The location the action is taking place.  This will probably be the
  outermost ``Room`` containing the actor taking the action.

* ``srcActor = nil``

  The actor taking the action.

* ``srcObject = nil``

  The object being used to do the action, if applicable.  If the command
  is ``>HIT ROCK WITH PICKAXE`` then ``srcObject`` will be the pickaxe,
  ``dstObject`` will be the rock, and the ``srcActor`` will be ``gActor``.

##### Methods

* ``matchAction(obj)``

  ``matchDstActor(obj)``

  ``matchDstObject(obj)``

  ``matchLocation(obj)``

  ``matchSrcActor(obj)``

  ``matchSrcObject(obj)``

  Returns boolean ``true`` if the passed ``obj`` matches the given property
  on the ``Tuple``.

  A match is when the argument and the property are identical (``==``) or
  if ``obj.ofKind()`` is ``true`` for the given property.

  For example if ``dstObject = Pebble`` and ``bobsPebble`` is an instance
  of ``Pebble``, then ``matchDstObject(bobsPebble)`` will return ``true``.

* ``matchSrcAndDstObjects(object0, object1)``

  Returns boolean ``true`` if ``object0`` matches ``srcObject`` and
  ``object1`` matches ``dstObject``.

* ``matchSrcAndDstActors(actor0, actor1)``

  Returns boolean ``true`` if ``actor0`` matches ``srcActor`` and
  ``actor1`` matches ``dstActor``.

* ``toTuple(data?)``

  Returns a ``Tuple`` instance whose properties are set by the passed
  data object.

  That is, if ``data = object { srcActor = bob }``, then the return value will
  be a ``Tuple`` whose ``srcActor`` property will be ``bob``.  Properties
  not part of the ``Tuple`` class will not be set.

  If ``data`` is already a ``Tuple`` it will be returned instead.

* ``exactMatchTuple(tuple)``

  Returns boolean ``true`` if ``tuple`` is an exact match for this ``Tuple``.

  An exact match means that:

  * ``tuple`` is a ``Tuple``
  * all properties set on ``tuple`` are set on the called tuple and *vice versa*
  * no properties are set on one but not the other
  * all set properties are equal

<a name="trigger"/></a>
### Trigger

In this module a ``Trigger`` is a ``Rule`` that is also a ``Tuple``.

#### Trigger

##### Methods

* ``match(data?)``

  By default ``Trigger.match()`` will merge whatever is passed as an argument
  with a ``Tuple`` representing the current turn and then return
  boolean ``true`` if calling ``matchTuple()`` with the result is ``true``.

  In other words if this trigger's ``action = TakeAction``
  and ``dstObject = pebble``, then ``match()`` will return ``true`` on
  a turn where the action is ``>TAKE PEBBLE`` and ``nil`` on a turn
  where the action is ``>TAKE SANDWICH``.

* ``getTriggerAction()``

  ``getTriggerDstActor()``

  ``getTriggerDstObject()``

  ``getTriggerRoom()``

  ``getTriggerSrcActor()``

  ``getTriggerSrcObject()``

  Returns the corresponding property on the tuple computed by ``match()``
  (above).

<a name="hashTable"></a>
### HashTable

The ``HashTable`` class implements associative arrays in which key
collisions are handled by storing them in a linear array.

#### HashTable
##### Methods

* ``insert(id, value)``

  Stores the value ``value`` with the ID ``id``.

* ``delete(id, value)``

  Removes the given key-value pair.

* ``query(id, callback?)``

  Returns the values associated with ID ``id`` as a list, or ``nil`` on
  failure.

  If the optional ``callback`` argument is given and is a function it will
  be used to test each value.  Values for which ``callback([that value])``
  returns boolean ``true`` will be included in the results list.

<a name="matrix"></a>
### Matrix

The ``Matrix`` class implements multi-dimensional arrays.

In general matrices must be dimensioned when constructed and cannot
be resized.  Example:

```
	// Create a 7x5x3 matrix
	local m = new Matrix(7, 5, 3);
```

Querying values outside the dimensioned bounds will return ``nil`` but
will not generate an error.

**Note**: the semantics of all methods on ``Matrix`` use coordinates
in the form of column x row, rather than row x column (as is more common
in mathematics).  So ``new Matrix(3, 2)`` produces a matrix with three
columns and two rows (as if the arguments were x and y).

#### Matrix
##### Properties

* ``dim = nil``

  The number of dimensions.  Should not be modified by hand.

* ``size = nil``

  An array containing the size of each dimension.  Example:  in a 2x3
  matrix this will be ``[ 2, 3 ]``.  Should not be modified by hand.

##### Methods

* ``set(x, y[...], value)``

  Sets the value for the given matrix element.  The number of arguments
  must be the same as the number of dimensions plus one.

* ``get(x, y[...])``

  Returns the value for the given matrix element.  The number of arguments
  must be the same as the number of dimensions.

* ``fill(value)``

  Sets every element of the array to be ``value``.

* ``load(array)``

  Loads the contents of ``array`` into the matrix.

  If the matrix was initialized "blank" the value of ``array`` must be a
  linearized 2-dimensional square matrix.  That is, a 2x2 matrix stored
  as a 4-element list, a 3x3 matrix stored as a 9-element list, and so on.

  Example: to make the matrix:

  ```
       a  b
       c  d
  ```
  ...the syntax would be...
  ```
       local m = new Matrix();
       m.load([ 'a', 'b', 'c', 'd' ]);
  ```
  A non-square matrix can be loaded by declaring a dimensioned matrix.

  Example: to make the matrix:
  ```
       a b
       c d
       e f
  ```
  ...use...
  ```
       local m = new Matrix(2, 3);
       m.load([ 'a', 'b', 'c', 'd', 'e', 'f' ]);
  ```

* ``transpose()``

  Returns the transpose of the matrix.  That is, given a matrix
  ```
       a b
       c d
       e f
  ```
  the transpose is
  ```
       a c e
       b d f
  ```

* ``equals(m)``

  Returns boolean ``true`` if the argument matrix is identical to this
  matrix.

* ``linearize()``

  Returns the contents of the matrix as a linearized array in row-first
  order.  That is, the same format expected by ``Matrix.load()`` above.

* ``clone()``

  Returns a copy of the calling matrix.

#### IntegerMatrix

The ``IntegerMatrix`` class is a subclass of ``Matrix`` which only accepts
integer values.

##### Methods

* ``determinant()``

  Returns the determinant of the matrix, or ``nil`` on error.

  Only works for 2-dimensional square matrices.

* ``multiply(m)``

  Returns the product of the calling matrix and the argument matrix.

  Only works for 2-dimensional matrices.

<a name="ts"></a>
### TS

The ``TS`` class provides a very simple wall-clock timestamp service.

When an instance is created the constructor records the time, and then
the number of seconds since creation can be returned via ``getInterval()``.

#### TS
##### Methods

* ``getInterval()``

  Returns the number of seconds since this instance was created.

<a name="tsProf"></a>
### TSProf

The ``TSProf`` class implements a simple performance profiler using the ``TS`` class.

#### Properties

* ``label = 'tsProf'``

  Label for output.  Only used by the ``report()`` method.

#### Methods

* ``start(id)``

  Starts a timer associated with the ID ``id``.

* ``stop(id)``

  Stops the timer associated with the ID ``id``, if one exists.

* ``total(id)``

  Returns the cumulative time elapsed, in seconds, for the timer ``id``.

* ``report()``

  Prints a list of all the timer IDs and their elapsed times.


<a name="bt-section"></a>
### Recursive Backtracker

The ``BT`` class and its support classes implement a simple recursive backtracker, intended to provide a method replacing tail recursion with a resumable, iterative solution finder.

<a name="bt"></a>
#### BT

The ``BT`` class implements a mostly generic recursive backtracking solver


##### Methods

* ``pop()``

  Pops the top frame off the stack and returns it.

* ``push(f)``

  Pushes the frame ``f`` onto the top of the stack.

* ``reject(f)``

  Rejection method.  This should return boolean ``true`` if the frame ``f`` and any frames derived from it should be rejected.
  
  Subclasses will want to implement their own logic here.  The stock method only fails on invalid frames.

  Returning ``true`` from this method means "stop trying this solution, it will never work".  It does **NOT** just mean "this frame is invalid" (although an invalid frame is *one of* the possible failure modes)

* ``accept(f)``

  Acceptance method.  This should return boolean ``true`` if the frame ``f`` is a valid solution to the problem being solved.
  
  Subclasses will want to implement their own logic.  The stock method just checks to see if a value is assigned to each variable being solved for.
  
  Returning ``true`` from this method means "stop processing, you've found the answer".

* ``next(f)``

  Returns the next frame following frame ``f``.
  
  By default this will just be the next permutation of the variable/value assignments.

* ``step(f)``

  Advances processing a single step starting from frame ``f``.
  
  Returns boolean ``true`` if the next step yielded a solution, placing the solution itself at the top of the stack; boolean ``nil`` if the next step was rejected (that is, resulted in a permanent failure for the branch being explored); and the next frame if the step resulted in neither a solution nor a failure.

* ``run(f)``

  Step through frames starting with frame ``f``, continuing until either a frame is accepted (that is, a solution is found) or rejected (that is, no further solutions are available from the starting frame).

<a name="btStack"></a>
#### BTStack

Stack for the recursive backtracker.  This generally won't need to be interacted with directly unless you're wrting a subclass of ``BT`` with a bunch of problem-specific logic.

##### Methods

* ``clear()``

  Clears the stack.

* ``push(f)``

  Pushes the frame ``f`` onto the top of the stack

* ``pop()``


  Pops the top frame off the stack and returns it.

* ``validateFrame(f)``

  Returns boolean ``true`` if ``f`` is a valid frame for this stack.

<a name="btFrame"></a>
#### BTFrame

Stack frame type for the recursive backtracker.

##### Properties

* ``vList = nil``

  List of variables we're trying to assign values to.

* ``pList = nil``

  List of possible values to assign to the variables.

* ``result = nil``

  List of assignments so far.
  
  **NOTE**: The *indices* in ``result`` correspond to indicies in ``vList``.  That is, the *i*th value of ``result`` is a possible assignment for the *i*th variable in ``vList``.  The *values*in ``result`` correspond to indices in ``pList``.  That is, they aren't the values being assigned they're the index of a value in ``pList``.
  
  Example:  If ``vList = [ 'Alice', 'Bob', 'Carol' ]`` and ``pList = [ 'asparagus', 'broccoli', 'carrots', 'daikon' ]``, then ``result[2] = 3`` means "Bob is assigned carrots".

##### Methods

* ``clone()``

  Returns a copy of this frame.

* ``next()``

  Returns the frame that follows this one.  The stock class proceeds by simple permutation.

<a name="xy"/></a>
### XY

The ``XY`` class is a simple data structure for handling 2D coordinates.

#### XY

##### Methods

* ``clone()``

  Returns a new XY instance with the same values as the current one.

* ``copy(v)``

  Copies the values from the argument, which must be another ``XY``
  instance.


* ``length()``

  Returns an integer approximation of the distance between the
  coordinates and the origin.

* ``add(v)``
  ``subtract(v)``

  Returns an ``XY`` instance equal to the sum or difference of the current
  instance and the argument, which must be another ``XY`` instance.

  Does not modify the either of the original instances.

* ``multiply(n)``
  ``divide(n)``

  Returns an ``XY`` instance equal to the current instance scaled up or
  down by a factor of ``n``, which must be an integer.

  Does not modify the original instance.

* ``distance(v)``

  Returns an integer approximation of the scalar distance between the current
  ``XY`` instance and the passed argument, which must also be an
  ``XY`` instance.

  This should be equivalent to ``subtract(v).length()``.

* ``normalize()``

  Treats the ``XY`` instance as a vector (in the mathematical sense, not
  in the TADS3 ``Vector`` sense) and "normalizes" it.

  A real normal is unit length, but that doesn't work here because
  everything in the ``XY`` class is integer-valued.  So ``normalize()``
  scales the base vector by a factor of 10 before "normalizing".  This
  produces a "normal" whose length is approximately 10.

  The expected use case is to compute the normal, multiply it by some
  other scalar, and then divide the result by 10.  This should
  produce an integer approximation of a vector of the same length
  as the scalar in the direction of the orginal vector.

* ``equals(v)``

  Returns boolean ``true`` if the passed argument is an ``XY`` instance
  whose values are the same as the current instance, ``nil`` otherwise.

* ``isAdjacent(v)``

  Returns boolean ``true`` if the passed argument is an ``XY`` instance
  in the Moore neighborhood (checkerboard adjacent, including diagonals),
  ``nil`` otherwise.

* ``isAdjacentToAll(lst)``

  Returns boolean ``true`` if the argument is a list of ``XY`` instances
  and all of them are adjacent to the calling instance.

* ``dot(v)``

  Treats the current ``XY`` instance as a vector and computes the dot
  product of it with the argument, which must be another ``XY`` instance.

* ``toStr()``

  Returns the values as an ordered pair.  Example:  with ``x = 1`` and
  ``y = 2``, will return the string ``(1, 2)``.

<a name="rectangle"></a>
### Rectangle

#### Rectangle

##### Properties

* ``height``

  ``width``

  The height and width of the rectangle.  Auto-computed;  should not be
  manually set.

* ``upperLeft``

  ``upperRight``

  ``lowerLeft``

  ``lowerRight``

  An ``XY`` instance giving the coordinates of the given corner of
  the rectangle.  Auto-computed;  should not be manually set.

##### Methods

* ``clone()``

  Returns a new ``Rectangle`` instance with the same values as the current one.

* ``contains(x, y?)``

  Returns boolean ``true`` if the given point is inside the rectangle.

  Can be called with two integer arguments or a single ``XY`` instance
  argument.

* ``overlaps(x, y?)``

  ``overlaps(rect)``

  Returns boolean ``true`` if the rectangle contains point (*x*, *y) (first
  usage) or overlaps rectangle *rect* (second usage).

* ``expand(x, y?)``

  Expands the rectangle to include the given point.

  Can be called with two integer arguments or a single ``XY`` instance
  argument.

* ``offset(x, y?)``

  Returns the minimum offset between the rectangle and the given point.

  Can be called with two integer arguments or a single ``XY`` instance
  argument.

* ``manhattanDistance(x, y?)``

  Returns the minimum Manhattan/taxi distance between the rectangle
  and the given point.

  Can be called with two integer arguments or a single ``XY`` instance
  argument.

<a name="linesegment"/></a>
### LineSegment

The ``LineSegment`` class implements line segments.

An instance is defined by its two endpoints, ``XY`` instances, which are
the arguments for the class constructor.

#### LineSegment

##### Methods

* ``contains(xy)``

  Returns boolean ``true`` if the argument ``XY`` instance lies on the
  line segment.

* ``equals(ls)``

  Returns boolean ``true`` if the argument line segment has the same
  endpoints as the calling line segment.

* ``coincident(ls)``

  Returns boolean ``true`` if the argument line segment shares exactly
  one endpoint with the calling line segment.

* ``intersects(ls, ignoreEndpoints?)``

  Returns boolean ``true`` if the argument line segment intersects the
  calling endpoint.  If the optional second argument is boolean ``true``
  intersection only at one of the endpoints will be ignored.

<a name="quadtree"></a>
### QuadTree

The ``QuadTree`` class implements simple quadtrees.

Quadtrees are a data structure for querying data that is
spatially indexed (that is, looking things up by x-y coordinates and so on).
Internally they work by evenly partitioning the geometric region they cover,
and so are most efficient when data is roughly evenly distributed.

A ``QuadTree`` instance must be declared by passing its bounding rectangle
to the constructor:

```
	// Bounding box is 5 units wide and 3 units tall, with
	// the upper-left corner at the origin and lower-right
	// corner at (5, 3).
	local tree = new QuadTree(0, 0, 5, 3);
```

#### QuadTree

##### Properties

* ``maxData = 10``

  The maximum number of data records per node.

##### Methods

* ``insert(x, y, d)``

  ``insert(v, d)``

  Inserts data record ``d`` into the tree at the location (*x*, *y*) (first
  usage) or the location given by ``XY`` instance *v* (second usage).

* ``query(x, y)``

  ``query(v)``

  Returns the data records stored at the given location.  Argument can
  be a single point or a bounding rectangle.

  The return value will be a list containing all matching records on
  success, an empty list if no records match, or ``nil`` on error.

* ``delete(x, y, d)``

  ``delete(v, d)``

  Deletes the data record ``d`` from location (*x*, *y*).

  Note that both a position and the data record itself are needed, as
  a single location can contain multiple records.

<a name="rtree"></a>
### RTree

The ``RTree`` class implements simple R-trees.

R-trees are a data structure for efficient querying of data that is
spatially indexed (that is, looking things up by x-y coordinates and so on).

Internally R-trees are self-balancing and ensure a constant query complexity
across all data stored in them (that is, all queries take roughly the
same amount of time).  They're most efficient when data is unevenly
distributed, and when query performance is more important than
insert performance.

#### RTree

##### Properties

* ``maxBranches = 10``

  The maximum number of branches per node.  This is the main tuning
  parameter.  A larger value will result in faster inserts but slower
  queries, a smaller value will result in slower inserts and faster
  queries.

##### Methods

* ``insert(x, y, d)``

  ``insert(v, d)``

  Inserts data record ``d`` into the tree at the location (*x*, *y*) (first
  usage) or the location given by ``XY`` instance *v* (second usage).

* ``query(x, y)``

  ``query(v)``

  Returns the data records stored at the given location.  Argument can
  be a single point or a bounding rectangle.

  The return value will be a list containing all matching records on
  success, an empty list if no records match, or ``nil`` on error.

* ``delete(x, y, d)``

  ``delete(v, d)``

  Deletes the data record ``d`` from location (*x*, *y*).

  Note that both a position and the data record itself are needed, as
  a single location can contain multiple records.


<a name="changes"/></a>
## Changes To Stock Classes

<a name="collection"/></a>
### Collection

#### Methods

* ``permutations()``

  Returns a ``Vector`` containing all the permuations of the elements of the
  calling ``Collection``.

  The maximum length of a ``Collection`` for which the TADS VM can generate
  all the permutations is ``8``.  Called on a longer ``Collection``
  ``permutations()`` will return ``nil``.

  Permutations are generated using a recursive implementation of the Heap
  algorithm.

<a name="tads-object"/></a>
### TadsObject

#### Methods

* ``copyProps(obj)``

  Copies all of the properties directly defined on the passed object ``obj``
  which correspond to properties defined (at all) on the calling object.

  For example, given:

  ```
  obj0: object { foo = 1 bar = 2 }
  obj1: object { foo = nil }
  ```

  Then ``obj1.copyProps(obj0)`` will produce:

  ```
  obj1: object { foo = 1 }
  ```

  Alternately, if instead ``obj0.copyProps(obj1)`` is executed, then:

  ```
  obj0: object { foo = nil bar = 2 }
  ```

<a name="vector"/></a>
### Vector

* ``swap(i, j)``

  Swaps elements *i* and *j*.

  Returns boolean ``true`` on success, ``nil`` on error.

* ``union(v)``

  Returns the union of this vector and the argument vector, modifying neither.
  This is equivalent to ``Vector.appendUnique()`` without modifying the
  original.

* ``intersection(v)``

  Returns the intersection of this vector and the argument vector.  That is,
  it returns the elements that are present in both vectors.

* ``complement(v)``

  Returns the complement of this vector with the argument vector.  That is,
  the elements of this vector that are not in the argument vector.  Or
  in set theoretic terms, if this vector is A and the argument vector is
  B, A \ B.

* ``equals(v, ord?)``

  Returns boolean ``true`` if this vector and the argument vector contain
  the same elements.  If the second argument is boolean ``true`` the
  elements must be in the same order, if not they can be in any order.

* ``rotate(n?)``

  Rotates the vector by *n* steps, defaulting to 1 if no argument is given.
  Number of steps can be positive or negative, indicating right or left
  rotation respectively.  See also ``rotateRight()`` and ``rotateLeft()``
  below.

* ``rotateRight(n?)``

  Rotate the vector right by *n* steps, defaulting to 1.  Right rotation
  moves all elements "up", wrapping elements at the end back to the
  start.

  Example:  ``[ 1, 2, 3, 4 ]`` rotated right one step becomes
  ``[ 4, 1, 2, 3]``.  The same vector rotated right two steps becomes
  ``[ 3, 4, 1, 2]``.

* ``rotateLeft(n?)``

  Rotate the vector left by *n* steps, defaulting to 1.  Left rotation
  moves all elements "down", wrapping elements at the start onto the
  end.

  Example:  ``[ 1, 2, 3, 4 ]`` rotated left one step becomes
  ``[ 2, 3, 4, 1 ]``.  The same vector rotated left two steps becomes
  ``[ 3, 4, 1, 2 ]``.

<a name="lookuptable"/></a>
### LookupTable

* ``keyWhich(fn)``

  Returns the first value for which the check function ``fn`` returns
  boolean ``true`` when called with the corresponding value.

  For example, given
  ```
  t = [ 'a' -> 1, 'b' -> 2, 'c' -> 3 ];
  ```
  then ``t.keyWhich({ x: x == 2 })`` will return ``b``.

<a name="macros"/></a>
## Macros

<a name="type-tests"/></a>
### Type Tests

The module provides a number of macros that evaluate ``true`` if an argument
is non-``nil`` and an instance of a given class.

* ``isType(obj, cls)``

   Evaluates as ``true`` if ``obj`` is non-``nil`` and an instance of
   ``cls``.

* ``isAction(obj)``

  ``isActor(obj)``

  ``isCollection(obj)``

  ``isInteger(obj)``

  ``isList(obj)``

  ``isLocation(obj)``

  ``isObject(obj)``

  ``isRoom(obj)``

  ``isString(obj)``

  ``isThing(obj)``

  ``isVector(obj)``

  Evaluates as ``true`` if ``obj`` is non-``nil`` and is of
  the named type.

* ``isEdge(obj)``

  ``isFSM(obj)``

  ``isGraph(obj)``

  ``isMarkovChain(obj)``

  ``isMarkovTransition(obj)``

  ``isMarkovState(obj)``

  ``isRule(obj)``

  ``isRulebook(obj)``

  ``isTuple(obj)``

  ``isTrigger(obj)``

  ``isVertex(obj)``

  Evaluates as ``true`` if ``obj`` is non-``nil`` and is of
  the named, module-specific, type.

<a name="general-utility"/></a>
### General Utility

* ``inRange(value, min, max)``

  Evaluates ``true`` if ``value`` is an integer between ``min`` and
  ``max`` (inclusive).

* ``nilToInt(value, default)``

  Evaluates to ``default`` if ``v`` is ``nil``, ``v`` (cast as an integer)
  otherwise.

  Example:  ``n = nil; m = nilToInt(n, 0)`` will yield ``m = 0``.
  ``n = '5'; m = nilToInt(n, 0)`` will yield ``m = 5``.

* ``noClobber(obj, value)``

  Sets ``obj`` to be ``value``, but only if ``obj`` is currently ``nil``.

  Example:  ``n = nil; noClobber(n, 2)`` will yield ``n = 2``.
  ``n = 5;  noClobber(n, 2)`` will yield ``n = 5``.

