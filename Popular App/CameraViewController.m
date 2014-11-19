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

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

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
    NSData *imageData = UIImagePNGRepresentation(pickerImage);
    Photo *photo = [Photo object];
    photo.imageData = imageData;
    PFUser *user = [PFUser currentUser];
    photo.profile = user.

//    PFQuery *query = [Photo query];
//    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            photo.profile = objects.firstObject;
            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error)
                {
                    self.imageView.image = pickerImage;
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
                                    Tag *tag = [Tag object];
                                    tag.tag = textFieldForTag.text;
//                                    [tag.photos addObject:<#(id)#>
                                }];
    
    [alert addAction:action];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)locationOnButtonPressed:(UIButton *)sender
{

}

- (IBAction)descriptionOnButtonPressed:(UIButton *)sender
{

}

@end
