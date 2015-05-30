//
//  Page.h
//  HW_CoreData
//
//  Created by Евгений Сергеев on 29.05.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Page : NSManagedObject

@property (nonatomic, retain) id img;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * url;

@end
