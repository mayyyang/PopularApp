//
//  CustomUINavigationBar.m
//  Popular App
//
//  Created by May Yang on 11/21/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "CustomUINavigationBar.h"

@interface CustomUINavigationBar ()
@property (nonatomic, strong) CALayer *colorLayer;

@end

@implementation CustomUINavigationBar

- (void)viewDidLoad {
    [super viewDidLoad];
    static CGFloat const kDefaultColorLayerOpacity = 0.5f;
    static CGFloat const kSpaceToCoverStatusBars = 20.0f;}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
