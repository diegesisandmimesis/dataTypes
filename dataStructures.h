//
// dataStructures.h
//

#define FINITE_STATE_MACHINE
#define GRAPH

#ifndef nilToInt
#define nilToInt(v, def) ((v == nil) ? def : toInteger(v))
#endif // nilToInt

#ifdef FINITE_STATE_MACHINE

#define DefineFSM(name, v0) \
	function name() { return(name##FSM.getState()); }; \
	function name##ID() { local st; return(((st = name##FSM.getState()) == nil) ? nil : st.getStateID()); } \
	name##FSM: FSM \
		@v0

FiniteStateMachine template @_vertexList @_edgeMatrix?;

FiniteStateMachineState template 'stateID';

Transition template '_id0' '_id1';

#endif // FINITE_STATE_MACHINE

#ifdef GRAPH
#define isGraph(obj) ((obj != nil) && obj.ofKind(Graph))
#define isVertex(obj) ((obj != nil) && obj.ofKind(Vertex))
#define isEdge(obj) ((obj != nil) && obj.ofKind(Edge))

Vertex template 'vertexID';
Edge template ->vertex1;
Edge template '_id0' '_id1';

Graph template @_vertexList @_edgeMatrix;

#define DeclareGraph(name, v0, v1) \
	name: Graph \
		@v0 \
		@v1

#endif // GRAPH


#define DATA_STRUCTURES_H
