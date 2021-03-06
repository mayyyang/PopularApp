//
//  Photo.m
//  Popular App
//
//  Created by Andrew Liu on 11/18/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "Photo.h"
#import "Profile.h"

@implementation Photo

@dynamic profile;
@dynamic createdAt;
@dynamic description;
@dynamic imageData;
@dynamic likeCount;
@dynamic profilesLiked;
@dynamic tag;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Photo";
}

- (void)saveInBackgroundWithCompletion:(savePhotoBlock)complete
{
    Photo *photo = [Photo object];
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!error)
         {
             complete(YES,nil);
         }
         else
         {
             complete(NO,error);
         }
     }];
}

@end
