//
//  ActivityViewController.m
//  Popular App
//
//  Created by May Yang on 11/17/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "ActivityViewController.h"
#import <Parse/PFObject+Subclass.h>
#import "Profile.h"
#import "Photo.h"
#import "Tag.h"

@interface ActivityViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *activitySegementedControl;
@property (weak, nonatomic) IBOutlet UITableView *activityTableView;

@property NSArray *followingArray;
@property NSArray *followersArray;
@property NSArray *tempArrayForDisplay;

@property NSMutableArray *followingTagArray;
@property NSMutableArray *followersTagArray;

@end

@implementation ActivityViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.profile = [[PFUser currentUser] objectForKey:@"profile"];

    [self queryForFollowing];
    [self queryForFollowers];
//[self queryForFollowingImages];

}

- (PFQuery *)queryForFollowing
{
    PFQuery *q = [Profile query];
    [q includeKey:@"followings"];
    [q getObjectInBackgroundWithId:self.profile.objectId block:^(PFObject *object, NSError *error) {
        Profile *p = (Profile *)object;
        self.followingArray = p.followings;

        self.tempArrayForDisplay = self.followingArray;
        [self.activityTableView reloadData];
    }];
    return q;
}

- (PFQuery *)queryForFollowers
{
        PFQuery *q2 = [Profile query];
        [q2 includeKey:@"followers"];
        [q2 getObjectInBackgroundWithId:self.profile.objectId block:^(PFObject *object, NSError *error) {
            Profile *p = (Profile *)object;
            self.followersArray = p.followers;
    
        }];
    return q2;
}



- (void)queryForFollowingImages
{
    PFQuery *p = [Photo query];
    //[p whereKey:<#(NSString *)#> equalTo:<#(id)#>]
    [p findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        Photo *pho = [objects objectAtIndex:0];
        self.photo.imageData = pho.imageData;


    }];
}


- (IBAction)onActivitySegmentedControl:(id)sender {


    if (self.activitySegementedControl.selectedSegmentIndex == 0){

        self.tempArrayForDisplay = self.followingArray;

    }else{

        self.tempArrayForDisplay = self.followersArray;

    }

    [self.activityTableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempArrayForDisplay.count;
//    if (self.activitySegementedControl.selectedSegmentIndex == 0)
//    {
//        return self.followingArray.count;
//    }
//    else
//    {
//        return self.followersArray.count;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];


//    NSData *data = [NSData new];
    Profile *p = self.tempArrayForDisplay[indexPath.row];
    cell.textLabel.text = p.name;
    cell.detailTextLabel.text = self.tempArrayForDisplay[indexPath.row];

    PFQuery *query = [Photo query];
    [query whereKey:@"profile" equalTo:p];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        Photo *lastPhotoPosted = objects.firstObject;
        NSData *d = lastPhotoPosted.imageData;
        UIImage *image = [UIImage imageWithData:d];
        cell.imageView.image = image;
        [cell layoutSubviews];
    }];

    return cell;
}
@end
