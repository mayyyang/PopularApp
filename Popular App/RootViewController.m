//
//  ViewController.m
//  Popular App
//
//  Created by May Yang on 11/17/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "RootViewController.h"
#import "PhotoCollectionViewCell.h"
#import "ProfileViewController.h"
#import "RootDetailViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <ParseUI/ParseUI.h>
#import "Profile.h"
#import "LoginViewController.h"
#import "SignupViewController.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *arrayOfRecentPhoto;
@property NSMutableArray *arrayOfPopularPhoto;
@property NSArray *collectionViewArray;

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
    if (self.tagPhotoArray != nil)
    {
        self.collectionViewArray = self.tagPhotoArray;
        [self.navigationItem.titleView setHidden:YES];
    }
    else
    {
            PFQuery *query = [Photo query];
            [query includeKey:@"createdAt"];
            [query orderByDescending:@"createdAt"];
            query.limit = 10;
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
            {
                if (error)
                {
                    [self errorAlertWindow:error.localizedDescription];
                }
                else
                {
                    self.collectionViewArray = objects;
                    [self.collectionView reloadData];
                }

            }];
           

        }



}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (![PFUser currentUser]) // No user logged in
    {
        // Instantiate our custom login view controller
        LoginViewController *logInViewController = [[LoginViewController alloc]init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton | PFLogInFieldsDismissButton;

        // Customize the Sign Up View Controller
        SignupViewController *signUpViewController = [[SignupViewController alloc]init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        signUpViewController.fields = PFSignUpFieldsDefault;

        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];

        //Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];


    }

}



- (void)logInViewController:(LoginViewController *)logInController didLogInUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    Profile *profile = [Profile object];
    [user setObject:profile forKey:@"profile"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];


}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (self.segmentControl.selectedSegmentIndex == 0)
//    {
//        return self.arrayOfRecentPhoto.count;
//    }
//    else
//    {
//        return self.arrayOfPopularPhoto.count;
//    }
    return self.collectionViewArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    Photo *photo = self.collectionViewArray[indexPath.item];
    UIImage *image = [UIImage imageWithData:photo.imageData];
    cell.imageView.image = image;

//    NSData *data = [NSData new];
//    if (self.segmentControl.selectedSegmentIndex == 0)
//    {
//        data = self.arrayOfRecentPhoto[indexPath.item];
//    }
//    else
//    {
//        data = self.arrayOfPopularPhoto[indexPath.item];
//    }
//    UIImage *image = [UIImage imageWithData:data];
//    cell.imageView.image = image;

    return cell;
}
- (IBAction)onSegmentedControlTapped:(UISegmentedControl *)sender
{
    if (self.segmentControl.selectedSegmentIndex == 0)
    {
        PFQuery *query = [Photo query];
        [query includeKey:@"createdAt"];
        [query orderByDescending:@"createdAt"];
        query.limit = 10;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (error)
             {
                 [self errorAlertWindow:error.localizedDescription];
             }
             else
             {
                 self.collectionViewArray = objects;
                 [self.collectionView reloadData];
             }

         }];


    }
    else
    {
        PFQuery *query = [Photo query];
//        [query whereKey:@"likeCount" greaterThan:@1];
        [query orderByDescending:@"likeCount"];
//        [query orderByDescending:@"createdAt"];
        query.limit = 10;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (error)
             {
                 [self errorAlertWindow:error.localizedDescription];
             }
             else
             {
                 self.collectionViewArray = objects;
                 [self.collectionView reloadData];
             }

         }];


    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RootDetailViewController *detailVC = segue.destinationViewController;
//    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
//    PhotoCollectionViewCell *cell = sender;
//    NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems].firstObject;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    detailVC.photo = self.collectionViewArray[indexPath.item];
}

-(void)errorAlertWindow:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ahtung!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"😭 Mkay..." style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
