//
//  ActivityViewController.m
//  Popular App
//
//  Created by May Yang on 11/17/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "ActivityViewController.h"
#import <Parse/PFObject+Subclass.h>
#import "RootDetailViewController.h"
#import "Profile.h"
#import "Photo.h"
#import "Comment.h"
#import "Tag.h"

@interface ActivityViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *activitySegementedControl;
@property (weak, nonatomic) IBOutlet UITableView *activityTableView;

@property NSArray *followingArray;
@property NSArray *followersArray;
@property NSArray *tempArrayForDisplay;


@end

@implementation ActivityViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.profile = [[PFUser currentUser] objectForKey:@"profile"];
//
//    [self queryForFollowing];
//    [self queryForFollowers];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.profile = [[PFUser currentUser] objectForKey:@"profile"];

    [self queryForFollowing];
//    [self queryForFollowers];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.activityTableView reloadData];
}

- (void)queryForFollowing
{
    PFQuery *queryForFollowing = [Profile query];
    [queryForFollowing includeKey:@"followings"];
    [queryForFollowing whereKey:@"objectId" equalTo:self.profile.objectId];
    [queryForFollowing findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {

        Profile *p = objects.firstObject;

        PFQuery *photosQuery = [Photo query];
            [photosQuery includeKey:@"profile"];
        [photosQuery orderByDescending:@"createdAt"];
        [photosQuery whereKey:@"profile" containedIn:p.followings];
        photosQuery.limit = 17;
        [photosQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             self.followingArray = objects;
             self.tempArrayForDisplay = self.followingArray;
             [self.activityTableView reloadData];


         }];

     }];
    

//    [q getObjectInBackgroundWithId:self.profile.objectId block:^(PFObject *object, NSError *error) {
//    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//
////        Profile *p = (Profile *)object;
//        Profile *p = objects.firstObject;
//        self.followingArray = p.followings;
//
//        self.tempArrayForDisplay = self.followingArray;
//        [self.activityTableView reloadData];
//    }];
//    return q;
}

- (void)queryForFollowers
{
    PFQuery *queryForFollowers = [Profile query];
    [queryForFollowers includeKey:@"followers"];
    [queryForFollowers whereKey:@"objectId" equalTo:self.profile.objectId];
    [queryForFollowers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

                Profile *p = objects.firstObject;

        PFQuery *photosQuery = [Photo query];
            [photosQuery includeKey:@"profile"];
        [photosQuery orderByDescending:@"createdAt"];
        [photosQuery whereKey:@"profile" containedIn:p.followers];
        [photosQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             self.followersArray = objects;
             self.tempArrayForDisplay = self.followersArray;
             [self.activityTableView reloadData];
             
             
         }];
        

    }];


}

//-(void)photosQuery:(PFQuery *)subQuery
//{
//    PFQuery *photosQuery = [Photo query];
//    [photosQuery orderByDescending:@"createdAt"];
//    [photosQuery whereKey:@"profile" matchesQuery:subQuery];
//    [photosQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        NSLog(@"got here");
//    }];
//}

//-(void)commentsQuery:(PFQuery *)subQuery
//{
//    PFQuery *commentsQuery = []
//}


- (IBAction)onActivitySegmentedControl:(id)sender
{


    if (self.activitySegementedControl.selectedSegmentIndex == 0)

    {

//        self.tempArrayForDisplay = self.followingArray;
          [self queryForFollowing];

    }else

    {

//        self.tempArrayForDisplay = self.followersArray;
            [self queryForFollowers];
    }

    [self.activityTableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempArrayForDisplay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Photo *photo = self.tempArrayForDisplay[indexPath.row];

    cell.imageView.image = [UIImage imageWithData:photo.imageData];
    Profile *profile= photo.profile;
    cell.textLabel.text = profile[@"name"];
    if (photo.tag)
    {
    NSString *detail = [NSString stringWithFormat:@"added photo with # %@", photo.tag];
    cell.detailTextLabel.text = detail;
    }
    else
    {
        cell.detailTextLabel.text = @"added a photo without #";
    }



////    NSData *data = [NSData new];
//    Profile *p = self.tempArrayForDisplay[indexPath.row];
//    cell.textLabel.text = p.name;
//
//
////    cell.detailTextLabel.text = self.tempArrayForDisplay[indexPath.row];
//
//    PFQuery *query = [Photo query];
//    [query whereKey:@"profile" equalTo:p];
//    [query orderByAscending:@"createdAt"];
//
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//
//        Photo *lastPhotoPosted = objects.firstObject;
//        NSData *d = lastPhotoPosted.imageData;
//        UIImage *image = [UIImage imageWithData:d];
//        cell.imageView.image = image;
//
//        NSString *tag = lastPhotoPosted.tag;
//        cell.detailTextLabel.text = tag;
//
//        [cell layoutSubviews];
//    }];

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RootDetailViewController *detailVC = segue.destinationViewController;
    NSIndexPath *indexPath = [self.activityTableView indexPathForCell:sender];
    detailVC.photo = self.tempArrayForDisplay[indexPath.row];
}
@end
