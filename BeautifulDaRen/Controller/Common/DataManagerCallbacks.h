#ifndef DataManagerCallbacks_h
#define DataManagerCallbacks_h

typedef void(^ProcessFinishBlock)(NSError *error);
typedef void(^ProcessObjectFinishBlock)(NSError *error, id object);
typedef void(^ProcessStringFinishBlock)(NSError* error, NSString* data);
typedef void(^ProcessArrayFinishBlock)(NSError* error, NSArray* data);

#endif
