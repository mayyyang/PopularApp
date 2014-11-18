//
//  EditProfileViewController.m
//  Popular App
//
//  Created by Andrew Liu on 11/17/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation EditProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //TODO: naviitem.title = userid
}

- (IBAction)pickerImageOnButtonPressed:(UIButton *)sender
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
        self.imageView.image = pickerImage;
        NSData *profileImageData = UIImagePNGRepresentation(pickerImage);
//        self.lostCharacter.photo = profileImageData;
        [picker dismissViewControllerAnimated:YES completion:nil];
    }

- (IBAction)confirmEditingOnButtonPressed:(UIButton *)sender
{
    //TODO: confirm changing
}

@end
