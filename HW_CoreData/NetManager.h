//
//  NetManager.h
//  HW_CoreData
//
//  Created by Евгений Сергеев on 29.05.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Page.h"
#import <UIKit/UIKit.h>

@interface NetManager : NSObject

+(instancetype)sharedInstance;
-(void)loadPage:(Page *)page:(void(^)(Page *page))completion;

@end
