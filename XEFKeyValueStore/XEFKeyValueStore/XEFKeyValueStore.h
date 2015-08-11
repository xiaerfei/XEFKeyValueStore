//
//  XEFKeyValueStore.h
//  XEFKeyValueStore
//
//  Created by xiaerfei on 15/8/7.
//  Copyright (c) 2015年 RongYu100. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XEFKeyValueItem : NSObject

@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) id       itemObject;
@property (strong, nonatomic) NSDate   *createdTime;

@end


@interface XEFKeyValueStore : NSObject

@end
