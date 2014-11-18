//
//  ActivityViewController.m
//  Popular App
//
//  Created by May Yang on 11/17/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "ActivityViewController.h"

@interface ActivityViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *activitySegementedControl;
@property (weak, nonatomic) IBOutlet UITableView *activityTableView;
@property NSMutableArray *followingArray;
@property NSMutableArray *followersArray;
@property NSMutableArray *followingTagArray;
@property NSMutableArray *followersTagArray;

@end

@implementation ActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.followingArray = [@[]mutableCopy];
    self.followersArray = [@[]mutableCopy];
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
    if (self.activitySegementedControl.selectedSegmentIndex == 0)
    {
        NSData *data = [NSData new];
        cell.textLabel.text = self.followingArray[indexPath.row];
        cell.detailTextLabel.text = self.followingTagArray[indexPath.row];
        cell.imageView.image = [UIImage imageWithData:data];
    }
    else
    {
        NSData *data = [NSData new];
        cell.textLabel.text = self.followersArray[indexPath.row];
        cell.detailTextLabel.text = self.followersTagArray[indexPath.row];
        cell.imageView.image = [UIImage imageWithData:data];
    }

    return cell;
}
@end
