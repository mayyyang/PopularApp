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

//MARK: life cycle of view
- (void)viewDidLoad
{
    [super viewDidLoad];
}

//MARK: triger UIImagePicker(Camera) by button pressed
- (IBAction)cameraOnButtonPressed:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

//MARK: triger UIImagePicker(PhotoLibrary) by button pressed
- (IBAction)libraryOnButtonPressed:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

//MARK: use currentUser to find current profile and assign to photo.profile
//MARK: UIImagePicker delegate to store photo.imageData and photo.likeCount and display on imageview
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

//MARK: store photo.tag(lowercase) and display on label, also check if tag is taken or not
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
                                 self.photo.tag = [textFieldForTag.text lowercaseString];
                                 PFQuery *query = [Tag query];
                                 [query whereKey:@"tag" equalTo:[textFieldForTag.text lowercaseString]];
                                 [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
                                 {
                                     if (objects.count == 0)
                                     {
                                         self.tag = [Tag object];
                                         self.tag.tag = [textFieldForTag.text lowercaseString];
                                         self.tagLabel.text = [textFieldForTag.text lowercaseString];
                                     }
                                     else
                                     {
                                         self.tagLabel.text = [textFieldForTag.text lowercaseString];
                                     }
                                 }];
                             }];
    [alert addAction:action];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//MARK: store photo.description and display on label
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

//MARK: SAVE current user's photo and tag to parse, then return default user view
- (IBAction)confirmOnButtonPressed:(UIButton *)sender
{
    [self.photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (!error)
        {
            [self.tag saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            {
                if (!error)
                {
                    [self defaultDisplay];
                }
                else
                {
                    [self error:error];
                }
            }];
        }
        else
        {
            [self error:error];
        }
    }];
}


//MARK: set image, tag, and description to default
- (void)defaultDisplay
{
    self.imageView.image = [UIImage imageNamed:@"image"];
    self.tagLabel.text = @"Tagging your photo";
    self.descriptionTextView.text = @"Talk about your photo";
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
