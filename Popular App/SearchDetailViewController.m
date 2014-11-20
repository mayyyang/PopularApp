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
#import <Parse/Parse.h>


@interface SearchDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *followingButton;
@property (strong, nonatomic) IBOutlet UIButton *followerButton;
@property (strong, nonatomic) IBOutlet UILabel *photoCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) NSArray *collectionViewArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SearchDetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionViewArray = @[];

    [self loadImagesFromProfile:self.profile];

    self.navigationItem.title = self.profile.name;
    self.detailImageView.image = [UIImage imageWithData:self.profile.avatarData];
    self.detailTextView.text = self.profile.memo;
    

}

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

-(void)errorAlertWindow:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ahtung!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"😭 Mkay..." style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
