//
//  WeakProxyArray.m
//  MCCommom
//
//  Created by Shangen Zhang on 2020/1/17.
//  Copyright © 2020 Mi Cheng. All rights reserved.
//

#import "WeakProxyArray.h"

@interface WeakProxyArray ()
@property (nonnull, nonatomic, strong) NSHashTable<NSObject *> *delegates;
@end

@implementation WeakProxyArray

- (instancetype)initWithDelegates:(NSArray<id> *)delegates {
    self = [super init];
    if (self != nil) {
        self.delegates = [NSHashTable weakObjectsHashTable];
        for (id delegate in delegates) {
            [self addProxy:delegate];
        }
    }
    return self;
}

- (void)addProxy:(id)delegate {
    if (![delegate isKindOfClass:[NSObject class]] || [delegate isKindOfClass:[NSNull class]]) {
        return;
    }
    [self.delegates addObject:delegate];
}

- (void)removeProxy:(id)delegate {
    if ([delegate isKindOfClass:[NSObject class]]) {
        [self.delegates removeObject: delegate];
    }
}

// MARK: - 消息转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    for (NSObject *delegate in self.delegates) {
        if ([delegate respondsToSelector:aSelector]) {
            return [delegate methodSignatureForSelector:aSelector];
        }
    }
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    for (NSObject *delegate in self.delegates) {
        if ([delegate respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:delegate];
        }
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    for (NSObject *delegate in self.delegates) {
        if ([delegate respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}
@end
