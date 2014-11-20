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

@property NSArray *arrayOfPhoto;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
             self.followerButton.titleLabel.text = [NSString stringWithFormat:@"Followers:%d",self.profile.followers.count];
             self.followingButton.titleLabel.text = [NSString stringWithFormat:@"Followings:%d",self.profile.followings.count];

         }
         else
         {
             [self Error:error];
         }
     }];

    PFQuery *photoQuery = [Photo query];
    [photoQuery whereKey:@"profile" equalTo:user[@"profile"]];
    [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             self.arrayOfPhoto = objects;
             self.photoLabel.text = [NSString stringWithFormat:@"Photo:%d",self.arrayOfPhoto.count];
             [self.collectionView reloadData];
         }
         else
         {
             [self Error:error];
         }
     }];

}

#pragma mark - UIBUTTONS

- (IBAction)followingListOnButtonPressed:(UIButton *)sender
{
    //TODO: push following list viewcontroller
}
- (IBAction)followerListOnButtonPressed:(UIButton *)sender
{
    //TODO: push follower list viewcontroller
}
- (IBAction)logoutButton:(UIButton *)sender
{
    [PFUser logOut];
    RootViewController *rootVC = [[RootViewController alloc]init];
    [self presentViewController:rootVC animated:YES completion:nil];
}

#pragma mark - UICOLLECTIONVIEW METHODS

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"What do you want"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *EditAction = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //TODO: segue to rootdetailviewcontroller
    }];
    [alert addAction:EditAction];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //TODO: delete photo
    }];
    [alert addAction:deleteAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}



- (IBAction)addAvatarOnButtonPressed:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickerImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(pickerImage, 0.2);
    self.profile.avatarData = imageData;
    [self.profile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

        if (!error)
        {
            self.imageView.image = pickerImage;

        }
        else
        {
            [self Error:error];
        }
    }];

    [picker dismissViewControllerAnimated:YES completion:nil];
}


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
