//
//  ViewController.m
//  Popular App
//
//  Created by May Yang on 11/17/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "RootViewController.h"
#import "PhotoCollectionViewCell.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

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
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.segmentControl == 0)
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
    if (self.segmentControl == 0)
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
