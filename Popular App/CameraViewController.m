//
//  CameraViewController.m
//  Popular App
//
//  Created by May Yang on 11/17/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "CameraViewController.h"


@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}


@end
