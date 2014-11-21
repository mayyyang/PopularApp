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
    if (self.isFollowing == NO)
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

//MARK: tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfFollow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Profile *profile = self.arrayOfFollow[indexPath.row];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirmation"
                                                                   message:@"Are you sure you would like to delete this fing?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action)
                                   {
                                       NSMutableArray *tempArray = self.arrayOfFollow;
                                       Profile *profile = self.arrayOfFollow[indexPath.row];
                                       [profile deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                           if (!error)
                                           {
                                               [self.tableView reloadData];
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
