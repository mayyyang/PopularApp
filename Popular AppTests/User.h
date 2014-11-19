//
//  User.h
//  Popular App
//
//  Created by Andrew Liu on 11/18/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "Profile.h"

@interface User : PFUser <PFSubclassing>

@property (nonatomic, strong) Profile *profile;

@end
