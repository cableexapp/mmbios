//
//  Constant.h
//  SmartCity
//
//  Created by wyfly on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef SmartCity_SynthesizeSingleton_h
#define SmartCity_SynthesizeSingleton_h

#import <objc/runtime.h>


#pragma mark -
#pragma mark Singleton

/* Synthesize Singleton For Class
 *
 * Creates a singleton interface for the specified class with the following methods:
 *
 * + (MyClass*) sharedInstance;
 * + (void) purgeSharedInstance;
 *
 * Calling sharedInstance will instantiate the class and swizzle some methods to ensure
 * that only a single instance ever exists.
 * Calling purgeSharedInstance will destroy the shared instance and return the swizzled
 * methods to their former selves.
 *
 * 
 * Usage:
 *
 * MyClass.h:
 * ========================================
 *    #import "SynthesizeSingleton.h"
 *
 *    @interface MyClass: SomeSuperclass
 *    {
 *        ...
 *    }
 *    SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(MyClass);
 *
 *    @end
 * ========================================
 *
 *
 *    MyClass.m:
 * ========================================
 *    #import "MyClass.h"
 *
 *    @implementation MyClass
 *
 *    SYNTHESIZE_SINGLETON_FOR_CLASS(MyClass);
 *
 *    ...
 *
 *    @end
 * ========================================
 *
 *
 * Note: Calling alloc manually will also initialize the singleton, so you
 * can call a more complex init routine to initialize the singleton like so:
 *
 * [[MyClass alloc] initWithParam:firstParam secondParam:secondParam];
 *
 * Just be sure to make such a call BEFORE you call "sharedInstance" in
 * your program.
 */

#define SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(__CLASSNAME__)    \
\
+ (__CLASSNAME__*) sharedInstance;    \
+ (void) purgeSharedInstance;


#define SYNTHESIZE_SINGLETON_FOR_CLASS(__CLASSNAME__)    \
\
static __CLASSNAME__* volatile _##__CLASSNAME__##_sharedInstance = nil;    \
\
+ (__CLASSNAME__*) sharedInstanceNoSynch    \
{    \
return (__CLASSNAME__*) _##__CLASSNAME__##_sharedInstance;    \
}    \
\
+ (__CLASSNAME__*) sharedInstanceSynch    \
{    \
@synchronized(self)    \
{    \
if(nil == _##__CLASSNAME__##_sharedInstance)    \
{    \
_##__CLASSNAME__##_sharedInstance = [[self alloc] init];    \
}    \
else    \
{    \
NSAssert2(1==0, @"SynthesizeSingleton: %@ ERROR: +(%@ *)sharedInstance method did not get swizzled.", self, self);    \
}    \
}    \
return (__CLASSNAME__*) _##__CLASSNAME__##_sharedInstance;    \
}    \
\
+ (__CLASSNAME__*) sharedInstance    \
{    \
return [self sharedInstanceSynch]; \
}    \
\
+ (id)allocWithZone:(NSZone*) zone    \
{    \
@synchronized(self)    \
{    \
if (nil == _##__CLASSNAME__##_sharedInstance)    \
{    \
_##__CLASSNAME__##_sharedInstance = [super allocWithZone:zone];    \
if(nil != _##__CLASSNAME__##_sharedInstance)    \
{    \
Method newSharedInstanceMethod = class_getClassMethod(self, @selector(sharedInstanceNoSynch));    \
method_setImplementation(class_getClassMethod(self, @selector(sharedInstance)), method_getImplementation(newSharedInstanceMethod));    \
method_setImplementation(class_getInstanceMethod(self, @selector(retainCount)), class_getMethodImplementation(self, @selector(retainCountDoNothing)));    \
method_setImplementation(class_getInstanceMethod(self, @selector(release)), class_getMethodImplementation(self, @selector(releaseDoNothing)));    \
method_setImplementation(class_getInstanceMethod(self, @selector(autorelease)), class_getMethodImplementation(self, @selector(autoreleaseDoNothing)));    \
}    \
}    \
}    \
return _##__CLASSNAME__##_sharedInstance;    \
}    \
\
+ (void)purgeSharedInstance    \
{    \
@synchronized(self)    \
{    \
if(nil != _##__CLASSNAME__##_sharedInstance)    \
{    \
Method newSharedInstanceMethod = class_getClassMethod(self, @selector(sharedInstanceSynch));    \
method_setImplementation(class_getClassMethod(self, @selector(sharedInstance)), method_getImplementation(newSharedInstanceMethod));    \
method_setImplementation(class_getInstanceMethod(self, @selector(retainCount)), class_getMethodImplementation(self, @selector(retainCountDoSomething)));    \
method_setImplementation(class_getInstanceMethod(self, @selector(release)), class_getMethodImplementation(self, @selector(releaseDoSomething)));    \
method_setImplementation(class_getInstanceMethod(self, @selector(autorelease)), class_getMethodImplementation(self, @selector(autoreleaseDoSomething)));    \
[_##__CLASSNAME__##_sharedInstance release];    \
_##__CLASSNAME__##_sharedInstance = nil;    \
}    \
}    \
}    \
\
- (id)copyWithZone:(NSZone *)zone    \
{    \
return self;    \
}    \
\
- (id)retain    \
{    \
return self;    \
}    \
\
- (NSUInteger)retainCount    \
{    \
NSAssert1(1==0, @"SynthesizeSingleton: %@ ERROR: -(NSUInteger)retainCount method did not get swizzled.", self);    \
return NSUIntegerMax;    \
}    \
\
- (NSUInteger)retainCountDoNothing    \
{    \
return NSUIntegerMax;    \
}    \
- (NSUInteger)retainCountDoSomething    \
{    \
return [super retainCount];    \
}    \
\
- (oneway void)release    \
{    \
NSAssert1(1==0, @"SynthesizeSingleton: %@ ERROR: -(void)release method did not get swizzled.", self);    \
}    \
\
- (void)releaseDoNothing{}    \
\
- (void)releaseDoSomething    \
{    \
@synchronized(self)    \
{    \
[super release];    \
}    \
}    \
\
- (id)autorelease    \
{    \
NSAssert1(1==0, @"SynthesizeSingleton: %@ ERROR: -(id)autorelease method did not get swizzled.", self);    \
return self;    \
}    \
\
- (id)autoreleaseDoNothing    \
{    \
return self;    \
}    \
\
- (id)autoreleaseDoSomething    \
{    \
return [super autorelease];    \
}

#endif
