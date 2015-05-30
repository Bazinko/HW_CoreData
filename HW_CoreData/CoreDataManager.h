//
//  CoreDataManager.h
//  HW_CoreData
//
//  Created by Евгений Сергеев on 29.05.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Page.h"

@interface CoreDataManager : NSObject

+ (instancetype)shared;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSManagedObjectContext *)getContextForCurrentQueue;
-(void)save;
-(void)savePage:(Page*)page;
-(void)deletePage:(Page*)page;
-(void)getAllPages:(void(^)(NSArray *pagesArr))completion;

@end
