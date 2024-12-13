//
// dataStructures.h
//

#define FINITE_STATE_MACHINE
#define GRAPH

#ifndef nilToInt
#define nilToInt(v, def) ((v == nil) ? def : toInteger(v))
#endif // nilToInt

#ifdef FINITE_STATE_MACHINE

#define DefineFSM(name) \
	function name() { return(name##FSM.getState()); }; \
	function name##ID() { local st; return(((st = name##FSM.getState()) == nil) ? nil : st.getStateID()); } \
	name##FSM: FSM

FiniteStateMachineState template 'stateID';

#endif // FINITE_STATE_MACHINE

#ifdef GRAPH
#define isGraph(obj) ((obj != nil) && obj.ofKind(Graph))
#define isVertex(obj) ((obj != nil) && obj.ofKind(Vertex))
#define isEdge(obj) ((obj != nil) && obj.ofKind(Edge))

Vertex template 'vertexID';
Edge template ->vertex1;

Graph template @_vertexList @_edgeMatrix;

#endif // GRAPH


#define DATA_STRUCTURES_H
