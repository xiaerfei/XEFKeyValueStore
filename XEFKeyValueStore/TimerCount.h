//
//  TimerCount.h
//  XEFKeyValueStore
//
//  Created by xiaerfei on 15/8/11.
//  Copyright (c) 2015年 RongYu100. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ItemProperty : NSObject

@property (nonatomic,copy)   NSString *name;
@property (nonatomic,assign) NSInteger time;
@property (nonatomic,assign) BOOL valid;
@property (nonatomic,copy)   void(^item)();

@end

@interface TimerCount : NSObject
+ (id)sharedEngine;

- (void)addItem:(void (^)())item withName:(NSString *)name withTime:(NSInteger)time;

- (void)itemValid:(BOOL)valid withName:(NSString *)name;

- (void)itemOver;
- (void)itemRestart;
@end
