//
//  Photo.h
//  Popular App
//
//  Created by Andrew Liu on 11/18/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "Profile.h"

@class Profile;

typedef void(^savePhotoBlock)(BOOL succeeded, NSError *error);

@interface Photo : PFObject  <PFSubclassing>

@property (nonatomic, strong) Profile *profile;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSArray *profilesLiked;
@property (nonatomic, strong) NSString *tag;

- (void) saveInBackgroundWithCompletion:(savePhotoBlock)complete;

@end
