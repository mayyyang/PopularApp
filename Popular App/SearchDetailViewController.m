//
//  SearchDetailViewController.m
//  Popular App
//
//  Created by May Yang on 11/17/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "PhotoCollectionViewCell.h"
#import "Photo.h"
#import "User.h"
#import <Parse/Parse.h>


@interface SearchDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *followingButton;
@property (strong, nonatomic) IBOutlet UILabel *photoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fersCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) NSArray *collectionViewArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSString *followingsCount;
@property Profile *currentUserProfile;

@end

@implementation SearchDetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionViewArray = @[];

    [self loadImagesFromProfile:self.profile];

    self.navigationItem.title = self.profile.name;
    if (self.profile.avatarData)
    {
        UIImage *image = [UIImage imageWithData:self.profile.avatarData];
        self.detailImageView.image = image;
    }
    else
    {
        UIImage *image = [UIImage imageNamed:@"avatar"];
        self.detailImageView.image = image;
    }
    self.detailTextView.text = self.profile.memo;

    self.fersCountLabel.text = [NSString stringWithFormat:@"Fers:%lu",(unsigned long)self.profile.followers.count];

    self.followingsCount = [NSString stringWithFormat:@"Fings:%lu",(unsigned long)self.profile.followings.count];

    [self.followingButton setTitle:self.followingsCount forState:UIControlStateNormal];



}

//- (BOOL)isCurrentUserProfile
//{
//    User *user = [User currentUser];
//    PFQuery *profileQuery = [Profile query];
//    [profileQuery includeKey:@"followers"];
//    [profileQuery includeKey:@"followings"];
//    [profileQuery getObjectInBackgroundWithId:[user[@"profile"] objectId] block:^(PFObject *object, NSError *error)
//     {
//         if (!error)
//         {
//            self.currentUserProfile = (Profile *)object;
//             if (self.profile isEqual:self.currentUserProfile)
//             {
//                 return YES;
//             }
//         }
//         else
//         {
//             [self errorAlertWindow:error.localizedDescription];
//         }
//     }];
//    return NO;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionViewArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    NSData *data = [self.collectionViewArray[indexPath.item] imageData];

    cell.imageView.image = [UIImage imageWithData:data];
    
    return cell;
}

-(void)loadImagesFromProfile:(Profile *)profile
{
    PFQuery *query = [Photo query];
    [query whereKey:@"profile" equalTo:profile];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (error)
        {
            [self errorAlertWindow:error.localizedDescription];
        }
        else
        {
            self.collectionViewArray = objects;
            self.photoCountLabel.text = [NSString stringWithFormat:@"Photos: %lu",(unsigned long)self.collectionViewArray.count];
            [self.collectionView reloadData];
        }

    }];


}

- (IBAction)followingOnButtonPressed:(UIButton *)sender
{
    User *user = [User currentUser];
    PFQuery *profileQuery = [Profile query];
    [profileQuery includeKey:@"followers"];
    [profileQuery includeKey:@"followings"];
    [profileQuery getObjectInBackgroundWithId:[user[@"profile"] objectId] block:^(PFObject *object, NSError *error)
     {
         if (!error)
         {
//             self.currentUserProfile = (Profile *)object;
//             NSMutableArray *followingArray = [@[]mutableCopy];
//             followingArray = [profile.followings mutableCopy];
//             [followingArray addObject:self.profile];






         }
         else
         {
             [self errorAlertWindow:error.localizedDescription];
         }
     }];
}

-(void)errorAlertWindow:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ahtung!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"😭 Mkay..." style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
