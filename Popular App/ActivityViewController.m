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
@property NSMutableArray *followersArray;
@property NSArray *tempArrayForDisplay;

@property NSMutableArray *followingTagArray;
@property NSMutableArray *followersTagArray;

@end

@implementation ActivityViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.profile = [[PFUser currentUser] objectForKey:@"profile"];
    
    PFQuery *q = [Profile query];
    [q includeKey:@"followers"];
    [q getObjectInBackgroundWithId:self.profile.objectId block:^(PFObject *object, NSError *error) {
        Profile *p = (Profile *)object;
        self.followingArray = p.followers;
        [self.activityTableView reloadData];
    }];

    self.followingArray = @[@"d", @"f", @"g"].mutableCopy;
    //self.followersArray = [@[]mutableCopy];

    // set defualt array to dispaly
    self.tempArrayForDisplay = self.followersArray;
    [self.activityTableView reloadData];
}

- (void)refreshDisplay
{
    PFQuery *photoQuery = [Photo query];
    [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else
        {
            
        }
    }];
}

- (IBAction)onActivitySegmentedControl:(id)sender {


    if (self.activitySegementedControl.selectedSegmentIndex == 0){

        self.tempArrayForDisplay = self.followersArray;

    }else{

        self.tempArrayForDisplay = self.followingArray;

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

    NSData *data = [NSData new];
    Profile *p = self.tempArrayForDisplay[indexPath.row];
    cell.textLabel.text = p.name;
    cell.detailTextLabel.text = self.tempArrayForDisplay[indexPath.row];
    cell.imageView.image = [UIImage imageWithData:data];

    return cell;
}
@end
