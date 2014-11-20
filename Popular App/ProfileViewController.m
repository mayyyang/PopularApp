//
//  ProfileViewController.m
//  Popular App
//
//  Created by May Yang on 11/17/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "ProfileViewController.h"
#import "PhotoCollectionViewCell.h"
#import "RootViewController.h"
#import "FollowListViewController.h"
#import "EditProfileViewController.h"
#import <ParseUI/ParseUI.h>
#import "User.h"
#import "Profile.h"
#import "Photo.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UIButton *followerButton;
@property Profile *profile;
@property Photo *photo;

@property NSArray *arrayOfPhoto;

@end

@implementation ProfileViewController

//MARK: life cycle of view
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadProfile];
    [self reloadPhoto];
}

//MARK: load user's name, memo, avatar, followers count, and followings count from parse
- (void)reloadProfile
{
    User *user = [User currentUser];
    PFQuery *profileQuery = [Profile query];
    [profileQuery whereKey:@"objectId" equalTo:[user[@"profile"] objectId]];
    [profileQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
             self.profile = objects.firstObject;
             self.nameLabel.text = self.profile.name;
             self.descriptionTextView.text = self.profile.memo;
             UIImage *image = [UIImage imageWithData:self.profile.avatarData];
             self.imageView.image = image;
             self.followerButton.titleLabel.text = [NSString stringWithFormat:@"Fers:%lu",(unsigned long)self.profile.followers.count];
             self.followingButton.titleLabel.text = [NSString stringWithFormat:@"Fings:%lu",(unsigned long)self.profile.followings.count];
        }
        else
        {
             [self Error:error];
        }
    }];
}

//MARK: load user's photo and photo count from parse and reload collectionview
- (void)reloadPhoto
{
    User *user = [User currentUser];
    PFQuery *photoQuery = [Photo query];
    [photoQuery whereKey:@"profile" equalTo:user[@"profile"]];
    [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            self.arrayOfPhoto = objects;
            self.photoLabel.text = [NSString stringWithFormat:@"Photo:%lu",(unsigned long)self.arrayOfPhoto.count];
            [self.collectionView reloadData];
        }
        else
        {
            [self Error:error];
        }
    }];
}

//MARK: segue to followings tableview
- (IBAction)followingListOnButtonPressed:(UIButton *)sender
{
//    [self performSegueWithIdentifier:@"followingSegue" sender:sender];
}

//MARK: segue to followers tableview
- (IBAction)followerListOnButtonPressed:(UIButton *)sender
{
//    [self performSegueWithIdentifier:@"followerSegue" sender:sender];
}

//MARK: logout user account on button pressed
- (IBAction)logoutButton:(UIButton *)sender
{
    [PFUser logOut];
    RootViewController *rootVC = [[RootViewController alloc]init];
    [self presentViewController:rootVC animated:YES completion:nil];
}

//MARK: pass different arrays based on different segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"followerSegue"])
    {
        FollowListViewController *flvc = segue.destinationViewController;
        //TODO: pass data
    }
    else if ([segue.identifier isEqual:@"followingSegue"])
    {
        FollowListViewController *flvc = segue.destinationViewController;
        //TODO: pass data
    }
}

//MARK: delete user's photo in parse and reload collectionview
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"What do you want"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                {
                                    Photo *deletedPhoto = self.arrayOfPhoto[indexPath.item];
                                    [deletedPhoto deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                                    {
                                        [self reloadPhoto];
                                    }];
                                }];
    [alert addAction:deleteAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//MARK: collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayOfPhoto.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    Photo *photo = self.arrayOfPhoto[indexPath.item];
    UIImage *image = [UIImage imageWithData:photo.imageData];
    cell.imageView.image = image;
    return cell;
}

//MARK: UIAlert
- (void)Error:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
