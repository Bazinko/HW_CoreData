//
//  WebViewController.m
//  HW_CoreData
//
//  Created by Евгений Сергеев on 28.05.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_webView loadData:_data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:_url];
}

@end
