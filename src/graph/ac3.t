#charset "us-ascii"
//
// ac3.t
//
//	Implementation of the Arc Consistency Algorith #3, or AC-3, an
//	algorithm for solving constraint satisfaction problems.
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

// In AC-3, each variable is a vertex in a graph.
class AC3Variable: Vertex
	// The domain is a list of allowed values for this variable.
	domain = nil

	// List of unary constraints on this variable.
	unaryConstraints = nil

	// Getter and setter for the domain.
	getDomain() { return(domain); }
	setDomain(v) { return(isCollection(v) && ((domain = v) != nil)); }

	// Add a unary constraint to our list.
	addUnaryConstraint(fn) {
		if(unaryConstraints == nil)
			unaryConstraints = new Vector();

		unaryConstraints.append(new AC3UnaryConstraint(fn));

		return(true);
	}

	// Apply all our unary constraints and return boolean true if that
	// leaves anything in the domain, nil otherwise.
	checkUnaryConstraints() {
		local r;

		if(unaryConstraints == nil)
			return(domain.length > 0);

		// Vector for all the elements we want to remove.
		r = new Vector(domain.length);

		unaryConstraints.forEach(function(c) {
			domain.forEach(function(x) {
				if(c.checkConstraint(x) != true)
					r.append(x);
			});
		});

		// Remove the elements.
		r.forEach({ x: domain.removeElement(x) });

		// See if we still have any values available.
		return(domain.length > 0);
	}
;

// All constraints are defined by a callback function that returns
// boolean true if the given values satisfy the constraint, nil otherwise.
class AC3Constraint: object
	callback = nil

	// Set the constraint method.
	setConstraint(fn) {
		if(!isFunction(fn)) return(nil);
		if(callback == nil) callback = new Vector();
		callback.append(fn);
		return(true);
	}
;

// The unitary constraint is on a single variable.  The check function
// takes a single argument, the value to check.
class AC3UnaryConstraint: AC3Constraint
	construct(fn) { setConstraint(fn); }
	checkConstraint(arg) {
		local i;
		if(callback == nil) return(nil);
		for(i = 1; i <= callback.length; i++)
			if((callback[i])(arg) != true) return(nil);
		return(true);
	}
;

// Class for binary constraints.
// In AC-3, binary constraints are edges (or arcs) on a graph, connecting
// the constrained variables.
class AC3BinaryConstraint: AC3Constraint, DirectedEdge
	ac3ReverseArgs = nil

	// See if we can satisfy our constraint.
	checkConstraint() {
		local i, l;

		// Make sure we have a function to call.
		if(callback == nil)
			return(nil);

		// Vector to keep track of the values to remove from the
		// domain.
		l = new Vector(vertex0.domain.length);

		// We check each value of our domain to see if there's
		// a corresponding value for the other variable that
		// satisfies our constraint.
		for(i = 1; i <= vertex0.domain.length; i++) {
			// If we can't satisfy the constraint for this
			// value, add it to our list.
			if(!_satisfy(vertex0.domain[i]))
				l.append(vertex0.domain[i]);
		}

		// We're dropping no values, return nil.
		if(l.length == 0)
			return(nil);

		// Update the domain.
		l.forEach({ x: vertex0.domain.removeElement(x) });

		// Alert our caller that we've updated the domain.
		return(true);
	}

	// See if we can satisfy our constraint with this as our value.
	_satisfy(val) {
		local i, v0, v1;

		// Go through all values in the other variable's domain.
		for(i = 1; i <= vertex1.domain.length; i++) {
			// Check the flag to see if we're the first or
			// second argument.
			if(ac3ReverseArgs == nil) {
				v0 = val;
				v1 = vertex1.domain[i];
			} else {
				v0 = vertex1.domain[i];
				v1 = val;
			}

			if(check(v0, v1) == true)
				return(true);
		}

		// Nope, no way to satisfy our constraint with the argument.
		return(nil);
	}

	// Run the given values past all our check functions.
	check(v0, v1) {
		local i;

		if(callback == nil) return(nil);
		for(i = 1; i <= callback.length; i++)
			if((callback[i])(v0, v1) != true)
				return(nil);
		return(true);
	}
;

// The AC-3 solver is a graph in which each variable being solved for
// is a vertex and each binary constraint is an edge between variables.
// Unary constraints are handled as lists on the vertices.
class AC3: DirectedGraph, BT
	// Vertex and Edge subclasses for our special graph class.
	vertexClass = AC3Variable
	edgeClass = AC3BinaryConstraint

	forEachVariable(fn) { return(forEachVertex(fn)); }

	// Add a variable.  First arg is the variable name, second is a
	// list containing its allowed values.
	addVariable(id, domain) {
		local v;
		if((v = addVertex(id)) == nil)
			return(nil);

		return(v.setDomain(domain));
	}

	getVariable(id) { return(getVertex(id)); }

	// Run the solver.  Returns boolean true if a solution was found,
	// nil otherwise.
	solve() {
		forEachVertex({ x: x.domain = new Vector(x.domain) });

		if(!_checkUnaryConstraints())
			return(nil);

		return(_checkBinaryConstraints());
	}

	// Apply unary constraints on all variables with them.
	// Returns boolean true if the system is still solvable afterwards.
	_checkUnaryConstraints() {
		local b;

		// Start out true-ish.
		b = 1;

		// Become false-ish if any variable fails its unary
		// constraints.
		forEachVertex(
			{ x: b &= (x.checkUnaryConstraints() ? 1 : 0)});

		// Return true if we're true-ish, nil otherwise.
		return(b == 1);
	}

	// Apply the binary constraints, returning boolean true if a solution
	// is found, nil otherwise.
	_checkBinaryConstraints() {
		local ac3Queue, v;


		// Queue to hold the constraints we need to check.
		ac3Queue = new Vector();

		// Add all binary constraints to the queue.
		forEachEdge({ x: ac3Queue.append(x) });

		// Iterate over the queue as long as it's non-empty.
		while(ac3Queue.length > 0) {
			// Pick the first element of the queue, remove it.
			v = ac3Queue[1];
			ac3Queue.removeElement(v);

			// If the checkConstraint() method returns boolean
			// true, this means it updated its domain.  This
			// means we have to add all edges from this vertex
			// (not counting this one) to the queue.
			if(v.checkConstraint()) {
				// First, see if applying the constraints
				// emptied the first vertex's domain.  If
				// so, solution is not possible, fail
				// immediately.
				if(v.vertex0.domain.length < 1)
					return(nil);

				// Iterate over all the vertex's edges,
				// adding all of them except one we just
				// checked to the queue.
				v.vertex0.forEachEdge(function(x) {
					if(x == v) return;
					ac3Queue.append(x);
				});
			}
		}

		// If we reached this point we emptied the queue without
		// exhausting anybody's domain, win.
		return(true);
	}

	// Generic add a constraint method.
	addConstraint([args]) {
		// Two args means a unary constraint (var name, check
		// function).
		if(args.length == 2)
			return(_addUnaryConstraint(args[1], args[2]));

		// Three args is two variables and a check function.
		if(args.length == 3)
			return(_addBinaryConstraint(args...));

		// Everything else is an error.
		return(nil);
	}

	// Add a unary constraint.
	_addUnaryConstraint(id, fn) {
		local v;

		if((v = getVariable(id)) == nil)
			return(nil);
		
		return(v.addUnaryConstraint(fn));
	}

	_addBinaryConstraint(id0, id1, fn) {
		local e;

		if((e = getEdge(id0, id1)) == nil)
			e = addEdge(id0, id1);
		e.setConstraint(fn);

		if((e = getEdge(id1, id0)) == nil)
			e = addEdge(id1, id0);
		e.setConstraint(fn);
		e.ac3ReverseArgs = true;

		return(true);
	}
;


modify AC3
	accept(frm) {
		local e, i, l, t, v0, v1;

		if(!inherited(frm))
			return(nil);

		// Create a table out of our results.
		t = new LookupTable();
		for(i = 1; i <= frm.result.length; i++) {
			t[frm.vList[i]] = frm.pList[i][frm.result[i]];
		}

		// Iterate over every edge/constraint.
		l = getEdges();
		for(i = 1; i <= l.length; i++) {
			e = l[i];
			// Make sure our args are in the right order.
			if(e.ac3ReverseArgs == nil) {
				v0 = t[e.vertex0.vertexID];
				v1 = t[e.vertex1.vertexID];
			} else {
				v0 = t[e.vertex1.vertexID];
				v1 = t[e.vertex0.vertexID];
			}

			// If any of the constraints fail we immediately
			// return nil.
			if(e.check(v0, v1) != true) {
				return(nil);
			}
		}

		// No complaints from any of the constraints, we're good.
		return(true);
	}

	getSolutions() {
		local f, idList, domainList, r;

		solve();

		r = new Vector();

		idList = getVertexIDs();
		domainList = new Vector(idList.length);
		forEachVertex({ x: domainList.append(new Vector(x.domain)) });
		f = new BTFrame(idList, domainList, nil);
		while(f != nil) {
			if(run(f) != nil) {
				f = self.pop();
				r.append(saveAC3Frame(f));
				f = self.next(f);
			} else {
				f = nil;
			}
		}

		return(r);
	}

	// Returns a lookup table containing the key/value pairs from
	// the given stack frame.
	saveAC3Frame(f) {
		local i, t;

		// Table to hold the results.
		t = new LookupTable();

		// f.result is an array.  Its length is the same as
		// the number of variables, and each value in it is
		// an index in that variable's domain.
		// Here f.vList[i] is the ith variable's ID and
		// f.pList[i] is the same variable's domain.
		// f.result[i] picks an assignment for that variable, in the
		// form of an index in the variable's domain.
		// So if f.result[1] is 2, that means the result is
		// assigning the value of the first variable to be the 2nd
		// element of that variable's domain.
		// If the domain is [ 3, 5, 7, 11 ], then
		// f.pList[i][f.result[i]] would be 5, the 2nd element of
		// the domain array.
		for(i = 1; i <= f.result.length; i++)
			t[f.vList[i]] = f.pList[i][f.result[i]];
		return(t);
	}
;
