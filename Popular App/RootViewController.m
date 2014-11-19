//
//  ViewController.m
//  Popular App
//
//  Created by May Yang on 11/17/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "RootViewController.h"
#import "PhotoCollectionViewCell.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <ParseUI/ParseUI.h>
#import "Profile.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *arrayOfRecentPhoto;
@property NSMutableArray *arrayOfPopularPhoto;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrayOfRecentPhoto = [@[]mutableCopy];
    self.arrayOfPopularPhoto = [@[]mutableCopy];

//    Profile *profile = [Profile object];
//    [profile setNameAndCanonicalName:@"Kevin McQuown"];
//    [profile save];
//
//    Profile *p2 = [Profile object];
//    [p2 setNameAndCanonicalName:@"Santa Clause"];
//    [p2 save];
//
//    profile.peopleIFollow = @[p2];
//    [profile save];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (![PFUser currentUser]) // No user logged in
    {
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc]init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate

        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc]init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate

        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];

        //Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.segmentControl.selectedSegmentIndex == 0)
    {
        return self.arrayOfRecentPhoto.count;
    }
    else
    {
        return self.arrayOfPopularPhoto.count;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSData *data = [NSData new];
    if (self.segmentControl.selectedSegmentIndex == 0)
    {
        data = self.arrayOfRecentPhoto[indexPath.item];
    }
    else
    {
        data = self.arrayOfPopularPhoto[indexPath.item];
    }
    UIImage *image = [UIImage imageWithData:data];
    cell.imageView.image = image;
    return cell;
}


@end
