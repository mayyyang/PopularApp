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

@property NSMutableArray *followingArray;
@property NSMutableArray *followersArray;
@property NSMutableArray *tempArrayForDisplay;

@property NSMutableArray *followingTagArray;
@property NSMutableArray *followersTagArray;

@end

@implementation ActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.followersArray = @[@"a", @"b", @"c"].mutableCopy;
    self.followingArray = @[@"d", @"f", @"g"].mutableCopy;
    //self.followersArray = [@[]mutableCopy];

    // set defualt array to dispaly
    self.tempArrayForDisplay = self.followersArray;
    [self.activityTableView reloadData];
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
    if (self.activitySegementedControl.selectedSegmentIndex == 0)
    {
        return self.followingArray.count;
    }
    else
    {
        return self.followersArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    NSData *data = [NSData new];
    cell.textLabel.text = self.tempArrayForDisplay[indexPath.row];
    cell.detailTextLabel.text = self.tempArrayForDisplay[indexPath.row];
    cell.imageView.image = [UIImage imageWithData:data];

    return cell;
}
@end
