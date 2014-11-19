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
@import Parse;

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UIButton *followerButton;

@property NSMutableArray *arrayOfPhoto;
@property PFUser *user;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrayOfPhoto = [@[]mutableCopy];
    self.user = [PFUser currentUser];
    //TODO: name, avator, description
    //TODO: follower count
    //TODO: following count


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
    NSLog(@"test");
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


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.arrayOfPhoto.count;

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSData *data = self.arrayOfPhoto[indexPath.item];

    UIImage *image = [UIImage imageWithData:data];
    cell.imageView.image = image;
    return cell;
}

@end
