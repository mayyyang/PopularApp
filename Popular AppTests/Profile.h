//
//  Profile.h
//  Popular App
//
//  Created by Andrew Liu on 11/18/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "Photo.h"

@interface Profile : PFObject  <PFSubclassing>

@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lowercaseName;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSData *avatarData;
@property (nonatomic, strong) NSArray *peopleIFollow;
@property (nonatomic, strong) NSArray *followings;
@property (nonatomic, strong) PFUser *user;

-(void)setNameAndCanonicalName:(NSString *)name;

@end
