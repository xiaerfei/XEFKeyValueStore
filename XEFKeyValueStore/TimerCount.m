//
//  TimerCount.m
//  XEFKeyValueStore
//
//  Created by xiaerfei on 15/6/11.
//  Copyright (c) 2015年 RongYu100. All rights reserved.
//

#import "TimerCount.h"

@implementation ItemProperty 

@end

@implementation TimerCount
{
    NSMutableArray *_itemArray;
    NSTimer *_timer;
}


+ (id)sharedEngine
{
    static id _f = nil;
    if (_f == nil) {
        _f = [[[self class] alloc] init];
    }
    return _f;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemArray = [[NSMutableArray alloc] init];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return self;
}

static int n = 0;
- (void)timerAction
{
    n++;
    for (ItemProperty *ani in _itemArray) {
        if (ani.valid && n%ani.time == 0) {
            ani.item();
        }
    }
}

- (void)addItem:(void (^)())item withName:(NSString *)name withTime:(NSInteger)time
{
    ItemProperty *ani = [[ItemProperty alloc] init];
    ani.name    = name;
    ani.time    = time;
    ani.item    = item;
    ani.valid   = YES;
    [_itemArray addObject:ani];
}

- (void)itemValid:(BOOL)valid withName:(NSString *)name
{
    for (ItemProperty *a in _itemArray) {
        if ([a.name isEqualToString:name]) {
            a.valid = valid;
            break;
        }
    }
}

- (void)itemOver
{
    [_timer setFireDate:[NSDate distantFuture]];
}
- (void)itemRestart
{
    [_timer setFireDate:[NSDate distantPast]];
}

@end
