//
//  Profile.m
//  Popular App
//
//  Created by Andrew Liu on 11/18/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "Profile.h"

@interface Profile (PrimitiveAccessors)

@end

@implementation Profile

@dynamic objectId;
@dynamic name;
@dynamic lowercaseName;
@dynamic description;
@dynamic avatarData;
@dynamic followers;
@dynamic followings;

-(void)setNameAndCanonicalName:(NSString *)name
{
    self.name = name;
    self.lowercaseName = [name lowercaseString];
}

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Profile";
}

@end
