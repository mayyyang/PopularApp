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
    self.photo = [Photo object];
                                        self.tag = [Tag object];
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
    NSData *imageData = UIImageJPEGRepresentation(pickerImage, 0.1);

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

                                    self.tag.tag = textFieldForTag.text;

                                    PFRelation *relation = [self.tag relationForKey:@"photos"];
                                    [relation addObject:self.photo];

                                    [self.tag saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        if (!error)
                                        {
                                            self.tagLabel.text = textFieldForTag.text;
                                            PFRelation *relation = [self.photo relationForKey:@"tags"];
                                            [relation addObject:self.tag];

                                            [self.photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                if (!error)
                                                {

                                                }
                                                else
                                                {
                                                    NSLog(@"%@", error.localizedDescription);
                                                }
                                            }];

                                        }
                                        else
                                        {
                                            NSLog(@"%@", error.localizedDescription);
                                        }
                                    }];
//

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
    
                                            }
                                            else
                                            {
                                                NSLog(@"%@", error.localizedDescription);
                                            }
                                        }];
                                        [self.tag saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                            if (!error)
                                            {

                                            }
                                            else
                                            {
                                                NSLog(@"%@", error.localizedDescription);
                                            }
                                        }];

}

- (IBAction)descriptionOnButtonPressed:(UIButton *)sender
{

}

@end
