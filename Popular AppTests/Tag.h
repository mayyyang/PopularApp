//
//  Tag.h
//  Popular App
//
//  Created by Andrew Liu on 11/18/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "Photo.h"

typedef void(^saveTagBlock)(BOOL succeeded, NSError *error);

@interface Tag : PFObject  <PFSubclassing>

@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSArray *photosOfTag;

- (void) saveInBackgroundWithCompletion:(saveTagBlock)complete;

@end
