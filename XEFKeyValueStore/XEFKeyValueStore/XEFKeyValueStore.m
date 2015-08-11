//
//  XEFKeyValueStore.m
//  XEFKeyValueStore
//
//  Created by xiaerfei on 15/8/7.
//  Copyright (c) 2015年 RongYu100. All rights reserved.
//

#import "XEFKeyValueStore.h"
#import <FMDatabase.h>
#import <FMDatabaseAdditions.h>
#import <FMDatabaseQueue.h>



#ifdef DEBUG
#define debugLog(...)    NSLog(__VA_ARGS__)
#define debugMethod()    NSLog(@"%s", __func__)
#define debugError()     NSLog(@"Error at %s Line:%d", __func__, __LINE__)
#else
#define debugLog(...)
#define debugMethod()
#define debugError()
#endif

#define PATH_OF_DB    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
/**********************sql语句*********************/
static NSString *const DEFAULT_DB_NAME = @"database.sqlite";
static NSString *const CREATE_TABLE_SQL =
@"CREATE TABLE IF NOT EXISTS %@ ( \
id TEXT NOT NULL, \
json TEXT NOT NULL, \
createdTime TEXT NOT NULL, \
PRIMARY KEY(id)) \
";  
static NSString *const CLEAR_ALL_SQL = @"DELETE from %@";

@implementation XEFKeyValueItem

- (NSString *)description
{
    return [NSString stringWithFormat:@"id=%@, value=%@, timeStamp=%@", _itemId, _itemObject, _createdTime];
}

@end


@interface XEFKeyValueStore ()

@property (strong, nonatomic) FMDatabaseQueue * dbQueue;

@end

@implementation XEFKeyValueStore

#pragma mark - public methods
- (id)initDBWithName:(NSString *)dbName
{
    self = [super init];
    if (self) {
        NSString * dbPath = [PATH_OF_DB stringByAppendingPathComponent:dbName];
        debugLog(@"dbPath = %@", dbPath);
        if (_dbQueue) {
            [self close];
        }
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

/**
 *   @author xiaerfei, 15-08-11 18:08:43
 *
 *   创建table表
 *
 *   @param tableName
 */
- (void)createTableWithName:(NSString *)tableName {
    if ([XEFKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    NSString * sql = [NSString stringWithFormat:CREATE_TABLE_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to create table: %@", tableName);
    }
}

- (BOOL)isTableExists:(NSString *)tableName{
    if ([XEFKeyValueStore checkTableName:tableName] == NO) {
        return NO;
    }
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db tableExists:tableName];
    }];
    if (!result) {
        debugLog(@"ERROR, table: %@ not exists in current DB", tableName);
    }
    return result;
}

- (void)clearTable:(NSString *)tableName {
    if ([XEFKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    NSString * sql = [NSString stringWithFormat:CLEAR_ALL_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to clear table: %@", tableName);
    }
}


#pragma mark - private methods
/**
 *   @author xiaerfei, 15-08-11 18:08:44
 *
 *   检查tableName是否为nil、空、含有空格
 *
 *   @param tableName tableName
 *
 *   @return bool
 */
+ (BOOL)checkTableName:(NSString *)tableName
{
    if (tableName == nil || tableName.length == 0 || [tableName rangeOfString:@" "].location != NSNotFound) {
        debugLog(@"ERROR, table name: %@ format error.", tableName);
        return NO;
    }
    return YES;
}
/**
 *   @author xiaerfei, 15-08-11 18:08:17
 *
 *   关闭 queue
 */
- (void)close
{
    [_dbQueue close];
    _dbQueue = nil;
}
@end
