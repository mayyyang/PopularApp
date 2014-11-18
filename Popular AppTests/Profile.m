//
//  Profile.m
//  Popular App
//
//  Created by Andrew Liu on 11/18/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "Profile.h"

@implementation Profile

@dynamic objectID;
@dynamic name;
@dynamic description;
@dynamic avatarData;
@dynamic followers;
@dynamic followings;
@dynamic user;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Profile";
}

@end
