//
//  SearchViewController.m
//  Popular App
//
//  Created by May Yang on 11/17/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "SearchViewController.h"
#import <Parse/Parse.h>
#import "Tag.h"
#import "Profile.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property NSArray *tableViewArray;

@end

@implementation SearchViewController


//MARK: app load sequence
- (void)viewDidLoad
{
    [super viewDidLoad];


    //refresh on pull
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshDisplay:withClass:withSearchText:withOrderByKey:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

}


//MARK: delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.tableViewArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        Tag *tag = self.tableViewArray[indexPath.row];
//        PFObject *tag = self.tableViewArray[indexPath.row];
//        NSString *text = tag[@"tag"];
        cell.textLabel.text = tag.tag;
    }
    else
    {

        Profile *profile = self.tableViewArray[indexPath.row];
//        PFObject *profile = self.tableViewArray[indexPath.row];
//        NSString *text = profile[@"name"];
//        NSString *detail = profile[@"description"];
        cell.textLabel.text = profile.name;
        cell.detailTextLabel.text = profile.description;
        NSData *imageData = profile.avatarData;
        cell.imageView.image = [UIImage imageWithData:imageData];
    }

    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    //    searchText

    if (searchText.length != 0)
    {
        if (self.segmentedControl.selectedSegmentIndex == 0)
        {
            [self refreshDisplay:nil withClass:@"Tag" withSearchText:searchText withOrderByKey:@"tag"];
        }
        else
        {
            [self refreshDisplay:nil withClass:@"Profile" withSearchText:searchText withOrderByKey:@"lowercaseName"];
        }

    }
    else
    {
        if (self.segmentedControl.selectedSegmentIndex == 0)
        {
            [self refreshDisplay:nil withClass:@"Tag" withSearchText:searchText withOrderByKey:@"tag"];
        }
        else
        {
            [self refreshDisplay:nil withClass:@"Profile" withSearchText:searchText withOrderByKey:@"lowercaseName"];
        }
    }

    [self.tableView reloadData];
}

//MARK: custom methods
- (IBAction)segmentedControl:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        self.tableViewArray = @[];
        [self.tableView reloadData];
    }
    else
    {
        self.tableViewArray = @[];
        [self.tableView reloadData];
    }
}

-(void)refreshDisplay:(UIRefreshControl *)refreshControl withClass:(NSString *)class withSearchText:(NSString *)searchText withOrderByKey:(NSString *)orderKey
{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ BEGINSWITH %@",orderKey, searchText];
//    PFQuery *query = [PFQuery queryWithClassName:class predicate:predicate]; //crash point
    PFQuery *query = [PFQuery queryWithClassName:class];

    [query whereKey:orderKey hasPrefix:searchText]; //parse query format, better than predicate
    [query orderByAscending:orderKey]; //sort query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
             [self errorAlertWindow:error.localizedDescription];
         }
         else
         {
             self.tableViewArray = objects;
             [self.tableView reloadData];
         }

         [refreshControl endRefreshing];

     }];


}


-(void)errorAlertWindow:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ahtung!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"😭 Mkay..." style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
