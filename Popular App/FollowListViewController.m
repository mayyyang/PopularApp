//
//  FollowListViewController.m
//  Popular App
//
//  Created by Andrew Liu on 11/17/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "FollowListViewController.h"

@interface FollowListViewController ()  <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *arrayOfFollow;

@end

@implementation FollowListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrayOfFollow = [@[]mutableCopy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.arrayOfFollow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    NSString *text = self.arrayOfFollow[indexPath.row];

    cell.textLabel.text = text;
    return cell;
}

@end
