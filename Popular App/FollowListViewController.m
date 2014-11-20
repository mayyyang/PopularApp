//
//  FollowListViewController.m
//  Popular App
//
//  Created by Andrew Liu on 11/17/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "FollowListViewController.h"
#import "Profile.h"

@interface FollowListViewController ()  <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FollowListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//MARK: tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfFollow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    PFObject *object = self.arrayOfFollow[indexPath.row];
    PFQuery *query = [Profile query];
    [query whereKey:@"objectId" equalTo:[object objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        Profile *profile = objects.firstObject;
        cell.textLabel.text = profile.name;
        cell.detailTextLabel.text = profile.memo;
        if (profile.avatarData)
        {
            UIImage *image = [UIImage imageWithData:profile.avatarData];
            cell.imageView.image = image;
        }
        else
        {
            UIImage *image = [UIImage imageNamed:@"avatar"];
            cell.imageView.image = image;
        }
        [self.tableView reloadData];
    }];
    return cell;
}

@end
