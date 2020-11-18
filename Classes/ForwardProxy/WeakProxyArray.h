//
//  WeakProxyArray.h
//  MCCommom
//
//  Created by Shangen Zhang on 2020/1/17.
//  Copyright © 2020 Mi Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WeakProxyArray : NSObject

- (nonnull instancetype)initWithDelegates:(NSArray<id> * __nonnull)delegates NS_REFINED_FOR_SWIFT;

- (void)addProxy:(id _Nonnull)delegate;

- (void)removeProxy:(id _Nonnull)delegate;
@end
