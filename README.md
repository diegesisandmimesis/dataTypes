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
