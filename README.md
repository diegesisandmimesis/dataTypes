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

## Data Types

### Graph

#### Graph

Vertex methods:

* ``addVertex(vertexID, vertexInstance?)``

 Adds a vertex to the graph, creating a new ``Vertex`` instance if one is not
provided.

 Returns the added ``Vertex``.

* ``getVertex(vertexID)``

 Returns the given ``Vertex`` or ``nil`` on failure.

* ``removeVertex(vertex)``

 Removes the given vertex.  Argument can be the vertex ID or the ``Vertex``
instance.

* ``getVertices()``

 Returns a ``Vector`` of the graph's ``Vertex`` instances.

* ``getVertexIDs()``

 Returns a ``Vector`` of the graph's vertex IDs.


Edge methods:

* ``addEdge(vertex0, vertex1, edgeInstance?)``

 Adds an edge to the graph, creating a new ``Edge`` instance if one is not
given.

 The first two arguments specify the vertices connected by the edge.  They
can be either vertex IDs or ``Vertex`` instances.

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

 The ``length`` and
``directed`` arguments are optional.  If given, ``length`` is the length
of the edge and ``directed`` is a boolean indicating whether or not the edge is directed.  Both take their default values from the ``edgeClass`` defined on the graph.

#### Vertex

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

#### Edge

* ``getLength()``

 Returns the edge length.

* ``setLength(length)``

 Sets the edge length.

 The argument should be a numeric value.  By default most classes expect an
integer length, but some (like ``MarkovChain``) use floating point lengths.


### FiniteStateMachine

#### FSM
#### FSMState
#### Transition

### MarkovChain

#### MarkovChain
#### MarkovState
#### MarkovTransition

### Rulebook

#### Rulebook
#### Rule

### Tuple

#### Tuple

### Trigger

#### Trigger
