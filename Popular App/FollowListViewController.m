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
@property NSArray *arrayOfFollowList;

@end

@implementation FollowListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.isFollowing == NO)
    {
        self.arrayOfFollowList = self.profile.followers;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else
    {
        self.arrayOfFollowList = self.profile.followings;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

//MARK: tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfFollowList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Profile *profile = self.arrayOfFollowList[indexPath.row];
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
    return cell;
}

//MARK: delete relationship of follower and following
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirmation"
                                                                   message:@"Are you sure you would like to delete your fing?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action)
                                   {
                                       NSMutableArray *followingArray = [self.arrayOfFollowList mutableCopy];
                                       Profile *profile = self.arrayOfFollowList[indexPath.row];
                                       [followingArray removeObject:profile];
                                       self.arrayOfFollowList = followingArray;
                                       self.profile.followings = self.arrayOfFollowList;
                                       [self.profile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                                       {
                                           if (!error)
                                           {
                                               NSMutableArray *followerArray = [profile.followers mutableCopy];
                                               for (PFObject *object in followerArray)
                                               {
                                                   if ([[object objectId] isEqual:self.profile.objectId])
                                                   {
                                                       [followerArray removeObject:object];
                                                       profile.followers = followerArray;
                                                       [profile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                                                        {
                                                            if (!error)
                                                            {
                                                                [self.tableView reloadData];
                                                            }
                                                            else
                                                            {
                                                                [self error:error];
                                                            }
                                                        }];
                                                   }
                                               }
                                           }
                                           else
                                           {
                                               [self error:error];
                                           }
                                       }];
                                   }];
    [alert addAction:deleteAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//MARK: delete following list by button pressed
- (IBAction)deleteOnButtonPressed:(UIBarButtonItem *)sender
{
    if ([sender.title isEqual: @"Edit"])
    {
        self.tableView.editing = YES;
        sender.title = @"Delete";
    }
    else
    {
        self.tableView.editing = NO;
        sender.title = @"Edit";
    }
}

//MARK: UIAlert
- (void)error:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
