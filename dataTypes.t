#charset "us-ascii"
//
// dataTypes.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

// Module ID for the library
dataTypesModuleID: ModuleID {
        name = 'Data Types Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

// Extension to the builtin Vector class.
modify Vector
	// Swap the ith and jth elements.
	swap(i, j) {
		local tmp;

		if(!inRange(i, 0, length()) || !inRange(j, 0, length()))
			return(nil);
		tmp = self[j];
		self[j] = self[i];
		self[i] = tmp;

		return(true);
	}

	// Returns the union of this vector and the argument vector,
	// modifying neither.
	union(v) {
		local r;

		if(!isVector(v))
			return(nil);

		r = new Vector(self);
		v.forEach(function(x) {
			if(hasEquals(x)) {
				if(r.subset({ y: x.equals(y) }).length == 0)
					r.append(x);
			} else {
				r.appendUnique(x);
			}
		});

		return(r);
	}

	// Returns the intersection of this vector and the argument vector.
	intersection(v) {
		if(!isVector(v))
			return(nil);
		return(self.subset(function(x) {
			if(hasEquals(x))
				return(v.subset({ y: x.equals(y) })
					.length != 0);
			else
				return(v.indexOf(x) != nil);
		}));
	}

	// Returns boolean true if this vector and the argument vector
	// share no elements.
	isDisjoint(v) {
		return(isVector(v) ? (intersection(v).length == 0) : nil);
	}

	// Returns the a vector containing the elements of this vector that
	// are not in the argument vector.
	complement(v) {
		if(!isVector(v))
			return(nil);

		return(self.subset(function(x) {
			if(hasEquals(x))
				return(v.subset({ y: x.equals(y) })
					.length == 0);
			else
				return(v.indexOf(x) == nil);
		}));
	}

	// Returns a vector containing all the elements that are in exactly
	// one of the two vectors.  Computed as the complement of the union
	// and the intersection.
	symmetricDifference(v) {
		return(isVector(v) ? union(v).complement(intersection(v))
			: nil);
	}

	// Returns boolean true if this vector and the argument vector
	// contain the same elements.  If the second argument is boolean
	// true the elements must be in the same order, if not they can
	// be in any order.
	// Optional third argument is a test function.  If given, it will
	// be passed two arguments (elements from the vectors being
	// compared) and should return boolean true if they should be
	// considered equal.
	equals(v, ord?) {
		local i, s;

		if(!isVector(v)) return(nil);
		if(self.length() != v.length()) return(nil);
		for(i = 1; i <= self.length(); i++) {
			if(ord == true) {
				if(hasEquals(self[i])) {
					if(self[i].equals(v[i]) != true)
						return(nil);
				} else {
					if(self[i] != v[i])
						return(nil);
				}
			} else {
				if(hasEquals(self[i])) {
					s = v.subset({ x: self[i].equals(x) });
					if(s.length < 1)
						return(nil);
				} else {
					if(v.indexOf(self[i]) == nil)
						return(nil);
				}
				if(hasEquals(v[1])) {
					s = self.subset({ x: v[i].equals(x) });
					if(s.length < 1)
						return(nil);
				} else {
					if(self.indexOf(v[i]) == nil)
						return(nil);
				}
			}
		}
		return(true);
	}

	// Returns boolean true if the argument vector contains all the
	// elements of the calling vector.
	// Optional second argument is a test function.  If defined,
	// it will be called with two arguments (elements of the arrays
	// being tested) and should return boolean true if they should
	// be considered equal.
	isSubsetOf(v) {
		local i, s;

		if(!isVector(v)) return(nil);
		if(v.length < self.length) return(nil);
		for(i = 1; i <= self.length(); i++) {
			if(hasEquals(self[i])) {
				s = v.subset({ x: self[i].equals(x) });
				if(s.length < 1) return(nil);
			} else {
				if(v.indexOf(self[i]) == nil) return(nil);
			}
		}
		return(true);
	}

	rotate(n?) {
		n = (n ? n : 1);
		if(!isInteger(n)) return;
		if(n < 1) rotateLeft(abs(n));
		else rotateRight(n);
	}

	operator >>(x) { rotateRight(x); return(self); }

	rotateRight(n) {
		local i, tmp;

		n = (n ? n : 1);
		if(!isInteger(n)) return;
		n = abs(n);
		n = n % length;
		if(n == 0) return;

		i = 1;
		while(i <= n) {
			tmp = self[length];
			self.removeElementAt(length);
			self.prepend(tmp);
			i += 1;
		}
	}

	operator <<(x) { rotateLeft(x); return(self); }

	rotateLeft(n) {
		local i, tmp;

		n = (n ? n : 1);
		if(!isInteger(n)) return;
		n = abs(n);
		n = n % length;
		if(n == 0) return;

		i = 1;
		while(i <= n) {
			tmp = self[1];
			self.removeElementAt(1);
			self.append(tmp);
			i += 1;
		}
	}

	invert() {
		local i, l;

		l = new Vector(self.length);
		for(i = self.length; i > 0; i--)
			l.append(self[i]);
		return(l);
	}

	prependUnique(v) {
		if(indexOf(v) != nil) return(nil);
		prepend(v);
		return(true);
	}

	push(v) { append(v); }
	pop() {
		local r;
		if(self.length == 0) return(nil);
		r = self[self.length];
		removeElementAt(-1);
		return(r);
	}
;

modify Collection
	// Generate permutations using Heap's algorithm.
	// Collection must contain 8 or fewer items; more will
	// return (instead of generating a runtime error as the
	// VM explodes).
	permutations() {
		local r;

		// Sanity check the argument.
		if(length() > 8) return(nil);

		// For the return value.
		r = new Vector();

		// Call the "private" method.
		_heapPermute(r, length(), new Vector(self));

		return(r);
	}

	// "Private" function used by the above.  This is the recursive
	// Heap algorithm.
	_heapPermute(r, n, lst) {
		local i;

		if(n == 1) {
			r.append(new Vector(lst));
			return;
		}

		for(i = 1; i <= n; i++) {
			_heapPermute(r, n - 1, lst);
			if(n % 2)
				lst.swap(1, n);
			else
				lst.swap(i, n);
		}
	}

	validIndex(idx) {
		return(isInteger(idx) && (idx > 0) && (idx <= self.length()));
	}
;

modify TadsObject
	// Copy all the properties directly defined on the argument onto
	// this object, if the corresponding property is defined (at all,
	// not necessarily directly) on it.
	// So given:
	//
	//	obj0: object { foo = 1 bar = 2 }
	//	obj1: object { foo = nil }
	//
	// Then obj1.copyProps(obj0) will produce:
	//
	//	obj1: object { foo = 1 }
	//
	// Or alternately (without the first copyProps() call above),
	// obj0.copyProps(obj1) will produce:
	//
	//	obj0: object { foo = nil bar = 2 }
	//
	copyProps(cfg) {
		if(cfg == nil) cfg = object {};
		cfg.getPropList().forEach(function(o) {
			if(!cfg.propDefined(o, PropDefDirectly)) return;
			if(!self.propDefined(o)) return;
			self.(o) = cfg.(o);
		});
	}
;

// Modify LookupTable to add a method that returns the first key for
// which a given check function returns true for when given the corresponding
// value.
// Example:  given the table
//		t = [ 'a' -> 1, 'b' -> 2, 'c' -> 3 ];
// 	then
//		t.keyWhich({ x: x == 2 });
//	will return "b".
modify LookupTable
	keyWhich(cb) {
		local i, l;

		if(!isFunction(cb)) return(nil);
		l = keysToList();
		for(i = 1; i <= l.length(); i++)
			if((cb)(self[l[i]])) return(l[i]);
		return(nil);
	}
;
