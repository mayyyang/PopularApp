//
//  MainTabBarController.m
//  Popular App
//
//  Created by May Yang on 11/20/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"DidLogout" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        self.selectedViewController = self.viewControllers.firstObject;
    }];
//[[UITabBar appearance] setBackgroundColor:[UIColor colorWithRed:185.0/255.0 green:237.0/255.0 blue:239.0/255.0 alpha:0.0]];

    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:(185.0/255.0) green:(237.0/255.0) blue:(239.0/255.0) alpha:0.0]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
