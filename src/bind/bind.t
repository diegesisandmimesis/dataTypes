#charset "us-ascii"
//
// bind.t
//
//	Mechanism for binding a function to a context.
//
//
// USAGE
//
//	Bind a method to a context using bind():
//
//		// fn is the foozle method on foo.
//		local fn = bind(&foozle, foo);
//
//		// call the bound method, equivalent to foo.foozle()
//		fn();
//
//	Additionally bind arguments:
//
//		// fn() will be foo.foozle('bar')
//		local fn = bind(&foozle, foo, 'bar');
//		fn();
//
//	Mix bound and unbound arguments:
//
//		// fn() will be foo.foozle('foo', 'bar')
//		local fn = bind(&foozle, foo, 'foo');
//		fn('bar');
//
//
// NOTE
//
//	The bind() mechanism doesn't verify that the number of bound and
//	unbound arguments is the correct number for the bound method.  It's
//	up to the implementor to keep track.
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

class Bind: object
	fn = nil
	ctx = nil
	args = nil
	construct(cb, obj, [argList]) {
		fn = cb;
		ctx = obj;
		args = argList;
	}
	execute([a2]) { return(ctx).(fn)((args + a2)...); }
;

bind(cb, obj, [args]) {
	if((obj == nil) || !obj.ofKind(Object))
		return(nil);
	if((cb == nil) || (dataTypeXlat(cb) != TypeProp))
		return(nil);
	return(function([a2]) { return((new Bind(cb, obj, args...)).execute(a2...)); });
}
