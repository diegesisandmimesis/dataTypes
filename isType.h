//
// isType.h
//


#ifndef IS_TYPE_H
#define IS_TYPE_H

// Utility define for testing an object to see if it is an instance of some
// class
#ifndef isType
#define isType(obj, cls) ((obj != nil) && (dataType(obj) == TypeObject) && obj.ofKind(cls))
#endif

#ifndef isIntrinsicType
#define isIntrinsicType(obj, cls) ((obj != nil) && obj.ofKind(cls))
#endif // isIntrinsicType

// Defines to test for common adv3 object types
#ifndef isThing
#define isThing(obj) (isType(obj, Thing))
#endif
#ifndef isAction
#define isAction(obj) (isType(obj, Action))
#endif
#ifndef isLocation
#define isLocation(obj) (isType(obj, BasicLocation))
#endif
#ifndef isRoom
#define isRoom(obj) (isType(obj, Room))
#endif
#ifndef isTravelConnector
#define isTravelConnector(obj) (isType(obj, TravelConnector))
#endif
#ifndef isActor
#define isActor(obj) (isType(obj, Actor))
#endif

#ifndef isCollection
#define isCollection(obj) (isIntrinsicType(obj, Collection))
#endif
#ifndef isEvent
#define isEvent(obj) (isType(obj, Event))
#endif
#ifndef isList
#define isList(obj) (isIntrinsicType(obj, List))
#endif
#ifndef isLookupTable
#define isLookupTable(obj) (isType(obj, LookupTable))
#endif
#ifndef isObject
#define isObject(obj) ((obj != nil) && (dataType(obj) == TypeObject))
#endif
#ifndef isString
#define isString(obj) ((obj != nil) && (dataType(obj) == TypeSString))
#endif
#ifndef isVector
#define isVector(obj) (isIntrinsicType(obj, Vector))
#endif

#ifndef isEmptyList
#define isEmptyList(obj) (isCollection(obj) && (obj.length() < 1))
#endif
#ifndef isNilOrEmpty
#define isNilOrEmpty(obj) (!isCollection(obj) || (obj.length() < 1))
#endif

#ifndef isInteger
#define isInteger(obj) ((obj != nil) && (dataType(obj) == TypeInt))
#endif

#ifndef isFunction
//#define isFunction(obj) ((dataType(obj) != TypeNil) && ((dataType(obj) == TypeProp) || (dataType(obj) == TypeCode) || (dataType(obj) == TypeFuncPtr)) || (dataType(obj) == TypeObject))
#define isFunction(obj) ((dataType(obj) != TypeNil) && ( \
	((dataType(obj) == TypeProp) && ((propType(obj) == TypeFuncPtr) \
		|| (propType(obj) == TypeCode))) \
	|| (dataTypeXlat(obj) == TypeFuncPtr) \
))
#endif

#ifndef isDirection
#define isDirection(obj) (isType(obj, Direction))
#endif

#ifndef isDirProp
#define isDirProp(v) ((dataType(v) != TypeNil) && (Direction.allDirections.indexWhich({ x: x.dirProp == v }) != nil))
#endif

#endif // IS_TYPE_H
