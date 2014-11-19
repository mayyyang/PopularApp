//
//  Tag.m
//  Popular App
//
//  Created by Andrew Liu on 11/18/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "Tag.h"

@implementation Tag

@dynamic tag;
@dynamic photosOfTag;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Tag";
}

@end
