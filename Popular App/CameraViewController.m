//
//  CameraViewController.m
//  Popular App
//
//  Created by May Yang on 11/17/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "CameraViewController.h"
#import "Photo.h"
#import "Tag.h"
#import "Profile.h"
#import "User.h"

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property Photo *photo;
@property Tag *tag;

@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)cameraOnButtonPressed:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)libraryOnButtonPressed:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickerImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(pickerImage, 0.2);
    self.photo = [Photo object];
    self.photo.imageData = imageData;

    User *user = [User currentUser];
    Profile *profile = user[@"profile"];

    self.photo.profile = profile;

    self.imageView.image = pickerImage;

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tagOnButtonPressed:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add a tag"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Tag";
     }];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Add"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action)
                             {
                                 UITextField *textFieldForTag = alert.textFields.firstObject;

                                 self.photo.tag = textFieldForTag.text;

                                 PFQuery *query = [Tag query];
                                 [query whereKey:@"tag" equalTo:[textFieldForTag.text lowercaseString]];

                                 [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                     if (objects.count == 0)
                                     {
                                         self.tag = [Tag object];
                                         self.tag.tag = [textFieldForTag.text lowercaseString];

                                         NSMutableArray *photoArray = [@[]mutableCopy];
                                         [photoArray addObject:self.photo.imageData];
                                         self.tag.photosOfTag = photoArray;
                                     }
                                     else
                                     {
                                         self.tag = [Tag object];
                                         self.tag = objects.firstObject;
                                         self.tag.tag = [textFieldForTag.text lowercaseString];

                                         NSMutableArray *photoArray = [NSMutableArray arrayWithArray:self.tag.photosOfTag];
                                         [photoArray addObject:self.photo.imageData];
                                         self.tag.photosOfTag = photoArray;

                                     }
                                     self.tagLabel.text = textFieldForTag.text;
                                 }];

                             }];

    [alert addAction:action];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)descriptionOnButtonPressed:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add a description"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Description";
     }];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Add"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action)
                             {
                                 UITextField *textFieldForDescription = alert.textFields.firstObject;

                                 self.photo.description = textFieldForDescription.text;

                                 self.descriptionTextView.text = textFieldForDescription.text;

                             }];

    [alert addAction:action];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)confirmOnButtonPressed:(UIButton *)sender
{

    [self.photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {


            [self.tag saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error)
                {
                    [self defaultDisplay];

                }
                else
                {
                    [self Error:error];
                }
            }];
        }
        else
        {
            [self Error:error];
        }
    }];


}

- (void)defaultDisplay
{
    self.imageView.image = [UIImage imageNamed:@"image"];
    self.tagLabel.text = @"Tagging your photo";
    self.descriptionTextView.text = @"Talk about your photo";
}

- (void)Error:(NSError *)error
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
