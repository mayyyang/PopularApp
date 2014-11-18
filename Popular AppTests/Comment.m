//
//  Comment.m
//  Popular App
//
//  Created by Andrew Liu on 11/18/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@dynamic profileID;
@dynamic text;
@dynamic createdAt;
@dynamic photo;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Comment";
}

@end
