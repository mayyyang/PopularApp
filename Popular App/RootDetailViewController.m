//
//  RecentDetailViewController.m
//  Popular App
//
//  Created by May Yang on 11/17/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "RootDetailViewController.h"
#import "Comment.h"
@import MessageUI;
@import Social;

@interface RootDetailViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) NSMutableArray *commentArray;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation RootDetailViewController


-(void)viewDidLoad
{
    [super viewDidLoad];

    self.commentTextField.delegate = self;

    self.imageView.image = [UIImage imageWithData:self.photo.imageData];
    [self.likeButton setTitle:[NSString stringWithFormat:@"Likes: %@", self.photo.likeCount] forState:UIControlStateNormal];
    [self loadCommentsByPhoto:self.photo];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //TODO: row count
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Comment *comment = self.commentArray[indexPath.row];
    cell.textLabel.text = comment.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy @ HH:mm:ss"];
    NSString *date = [dateFormatter stringFromDate:comment.createdAt];

    PFQuery *profileQuery = [Profile query];
//    [profileQuery includeKey:comment.profileID];
    [profileQuery getObjectInBackgroundWithId:comment.profileID
                                        block:^(PFObject *object, NSError *error)
    {
        Profile *commentProfile = (Profile *)object;

        cell.detailTextLabel.text = [NSString stringWithFormat:@"by %@ on %@", commentProfile.name, date];
    }];
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.commentTextField)
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

//MARK: Actions

- (IBAction)onLikeButtonPressed:(UIButton *)sender
{
    self.photo.likeCount = [NSNumber numberWithInt:[self.photo.likeCount intValue] + 1];
    [self.likeButton setTitle:[NSString stringWithFormat:@"Likes: %@", self.photo.likeCount] forState:UIControlStateNormal];
    [self.photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
            [self errorAlertWindow:error.localizedDescription];
        }
    }];
}

- (IBAction)onFavoriteButtonPressed:(UIButton *)sender
{
    
}


- (IBAction)onShareButtonPressed:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Share" message:@"Let the whole world to see the picture!" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *emailButton = [UIAlertAction actionWithTitle:@"Email it" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self sendEmail:self.photo.imageData];
    }];
    UIAlertAction *twitButton = [UIAlertAction actionWithTitle:@"Twit it" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self sendTwit:self.photo.imageData];

    }];
//    UIAlertAction *deleteButton = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        [self.favoritesArray removeObjectAtIndex:indexPath.item];
//
//        [self.collectionView reloadData];
//
//        NSLog(@"Removed object. Array count = %lu", (unsigned long)self.favoritesArray.count);
//        NSURL *plistURL = [[self documentsDirectory]URLByAppendingPathComponent:@"fovorites.plist"];
//        [self.favoritesArray writeToURL:plistURL atomically:YES];
//    }];
    UIAlertAction *nothigButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }];

    [alert addAction:emailButton];
    [alert addAction:twitButton];
//    [alert addAction:deleteButton];
    [alert addAction:nothigButton];

    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onReportButtonPressed:(UIButton *)sender
{
    [self reportThePhotoEmail:self.photo.imageData];
}

- (IBAction)commentTextField:(UITextField *)sender
{
if (![self.commentTextField.text isEqual:@""])
{
    Comment *comment = [Comment object];
    comment.text = sender.text;
    comment.photo = self.photo;
    comment.profileID = [[PFUser currentUser][@"profile"] objectId];
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self loadCommentsByPhoto:self.photo];
    }];
    self.commentTextField.text = @"";
}
//    [self resignFirstResponder];
}

- (void)loadCommentsByPhoto:(Photo *)photo
{
    PFQuery *commentQuery = [Comment query];
    [commentQuery whereKey:@"photo" equalTo:photo];
    [commentQuery orderByDescending:@"createdAt"];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
             [self errorAlertWindow:error.localizedDescription];

         }
         else
         {
             self.commentArray = [objects mutableCopy];
             [self.tableView reloadData];

         }
     }];
}

-(void)sendEmail:(NSData *)data
{
    // From within your active view controller
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send

        [mailCont setSubject:@"Check this pic"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"name@qq.com"]];
        [mailCont setMessageBody:@"It's from Instaparse" isHTML:NO];
        [mailCont addAttachmentData:data mimeType:@"image/jpg" fileName:@"pic.jpg"];
        [mailCont setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];

        [self presentViewController:mailCont animated:YES completion:nil];
    }
    else
    {
        [self errorAlertWindow:@"Please setup an email account in your device"];
    }
}

-(void)reportThePhotoEmail:(NSData *)data
{
    // From within your active view controller
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send

        [mailCont setSubject:@"Violation alert"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"abuse@qq.com"]];
        [mailCont setMessageBody:@"This photo vilates the Instaparse rules" isHTML:NO];
        [mailCont addAttachmentData:data mimeType:@"image/jpg" fileName:@"pic.jpg"];
        [mailCont setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];

        [self presentViewController:mailCont animated:YES completion:nil];
    }
    else
    {
        [self errorAlertWindow:@"Please setup an email account in your device"];
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (error)
    {
        [self errorAlertWindow:error.localizedDescription];
    }
    else
    {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
}

//MARK: twitter use

-(void) sendTwit:(NSData *)data
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Cool pic!"];
        [tweetSheet addImage:[UIImage imageWithData:data]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}



-(void)errorAlertWindow:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ahtung!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"😭 Mkay..." style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
