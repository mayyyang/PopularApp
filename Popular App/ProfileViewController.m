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
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UIButton *followerButton;
@property NSString *followersCount;
@property NSString *followingsCount;
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
    [profileQuery includeKey:@"followers"];
    [profileQuery includeKey:@"followings"];
    [profileQuery getObjectInBackgroundWithId:[user[@"profile"] objectId] block:^(PFObject *object, NSError *error)
    {
        if (!error)
        {
            self.profile = (Profile *)object;
            self.navigationItem.title = self.profile.name;
            self.descriptionTextView.text = self.profile.memo;
            if (self.profile.avatarData)
            {
                UIImage *image = [UIImage imageWithData:self.profile.avatarData];
                self.imageView.image = image;
            }
            else
            {
                UIImage *image = [UIImage imageNamed:@"avatar"];
                self.imageView.image = image;
            }
            self.followersCount = [NSString stringWithFormat:@"Fers:%lu",(unsigned long)self.profile.followers.count];
            [self.followerButton setTitle:self.followersCount forState:UIControlStateNormal];
            self.followingsCount = [NSString stringWithFormat:@"Fings:%lu",(unsigned long)self.profile.followings.count];
            [self.followingButton setTitle:self.followingsCount forState:UIControlStateNormal];
        }
        else
        {
             [self error:error];
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
            [self error:error];
        }
    }];
}

//MARK: logout user account on button pressed
- (IBAction)logoutButton:(UIButton *)sender
{
    [PFUser logOut];
    RootViewController *rootVC = [[RootViewController alloc]init];
    [self presentViewController:rootVC animated:YES completion:nil];
}

//MARK: segue to followings tableview
- (IBAction)followingListOnButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"followListSegue" sender:self.profile.followings];
}

//MARK: segue to followers tableview
- (IBAction)followerListOnButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"followListSegue" sender:self.profile.followers];
}

//MARK: pass different arrays based on different segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"editSegue"])
    {
        EditProfileViewController *epvc = segue.destinationViewController;
        epvc.user = [User currentUser];
        epvc.profile = self.profile;
    }
    else if ([segue.identifier isEqual:@"followListSegue"])
    {
        FollowListViewController *flvc = segue.destinationViewController;
        if ([sender isEqual:self.profile.followings])
        {
            flvc.arrayOfFollow = sender;
            flvc.isFollowing = YES;
        }
        else
        {
            flvc.arrayOfFollow = sender;
            flvc.isFollowing = NO;
        }
    }
}

//MARK: delete user's photo in parse and reload collectionview
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirmation"
                                                                   message:@"Are you sure you would like to delete this photo"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                {
                                    Photo *deletedPhoto = self.arrayOfPhoto[indexPath.item];
                                    [deletedPhoto deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                                    {
                                        if (!error)
                                        {
                                            [self reloadPhoto];
                                        }
                                        else
                                        {
                                            [self error:error];
                                        }
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
- (void)error:(NSError *)error
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
