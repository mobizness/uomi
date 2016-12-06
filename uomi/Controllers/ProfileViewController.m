//
//  ProfileViewController.m
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "ProfileViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ProfileViewController ()<UIScrollViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    NSMutableArray *arrColors;
}
@end
@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    arrColors = [commonUtils getColorArray];
    [self initializeScreen];
    
    appController.strUserId = [commonUtils getUserDefault:@"user_id"];
    NSString *str = appController.strUserId;
    appController.dicUserInfo = [commonUtils getUserDefaultDicByKey:@"user_info"];
    
    
//    NSString *user_id = [appController.dicUserInfo objectForKey:@"user_id"];
//    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
//    [userInfo setObject:user_id forKey:@"user_id"];
//    
//    [commonUtils showActivityIndicator:self.view];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (appController.isLoading) return;
//        appController.isLoading = YES;
//        
//        [self requestUserInfo:userInfo];
//    });
}


- (void)viewDidAppear:(BOOL)animated {
    [self showDetail];
    
}

- (void)initializeScreen {
//    _imgAvatar.layer.cornerRadius = _imgAvatar.frame.size.width / 2;
    
//    _imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
//    _imgAvatar.layer.borderWidth = 0.5;
//    _imgAvatar.clipsToBounds = YES;
//    
    _imgAvatar.layer.shadowColor = [UIColor blackColor].CGColor;
    _imgAvatar.layer.shadowOffset = CGSizeZero;
    _imgAvatar.layer.shadowRadius = 1.0;
    _imgAvatar.layer.shadowOpacity = 0.2;
    _imgAvatar.layer.masksToBounds = NO;
    
    [commonUtils setCircleBorderImage:_imgAvatar withBorderWidth:0.5 withBorderColor:[UIColor clearColor]];
    
    CGRect rect = _scrollView.frame;
    rect.origin.y = 0;
    _scrollView.frame = rect;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _viewLogout.frame.origin.y + _viewLogout.frame.size.height);
}

- (IBAction)OnSettings:(id)sender {
    
}

- (IBAction)OnEditImage:(id)sender {
    UIAlertController *optionMenu = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Use Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self openCameraAction];
    }];
    
    UIAlertAction* gallertAction = [UIAlertAction actionWithTitle:@"Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self openGalleryAction];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
    
    
    [optionMenu addAction:cameraAction];
    [optionMenu addAction:gallertAction];
    [optionMenu addAction:cancelAction];
    
    
    [self presentViewController:optionMenu animated:YES completion:nil];
}

- (IBAction)OnLogout:(id)sender {
    [commonUtils setUserDefault:@"is_logined" withFormat:@"0"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)openCameraAction
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    pickerController.allowsEditing = YES;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}
- (void)openGalleryAction
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    pickerController.allowsEditing = YES;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        
        UIImage *resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!resultImage) {
            resultImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        if (resultImage) {
            self.imgAvatar.image = resultImage;
                
            NSString *user_id = [appController.dicUserInfo objectForKey:@"user_id"];
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:user_id forKey:@"user_id"];
            [userInfo setObject:[commonUtils encodeToBase64String:resultImage byCompressionRatio:0.3] forKey:@"image"];
            
            [commonUtils showActivityIndicator:self.view];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (appController.isLoading) return;
                appController.isLoading = YES;
                
                [self requestUpdateImage:userInfo];
            });
        }
        
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)showDetail {
    _lblPaid.text = [NSString stringWithFormat:@"$%.2f", [[appController.dicUserInfo objectForKey:@"paid"] floatValue]];
    _lblReceived.text = [NSString stringWithFormat:@"$%.2f", [[appController.dicUserInfo objectForKey:@"received"] floatValue]];
    _lblUserName.text = [appController.dicUserInfo objectForKey:@"user_name"];
    _lblShortName.text = [commonUtils getShortName:[appController.dicUserInfo objectForKey:@"user_name"]];
    
    _imgAvatar.backgroundColor = [arrColors objectAtIndex: [[appController.dicUserInfo objectForKey:@"user_id"] intValue] % arrColors.count];
    _lblShortName.hidden = NO;
    
    if ([[appController.dicUserInfo objectForKey:@"user_image"] isEqualToString:@""] || [[appController.dicUserInfo objectForKey:@"user_image"] isEqualToString:@"0"]) {
    }
    else {
        [commonUtils setImageViewAFNetworking:_imgAvatar withImageUrl:[appController.dicUserInfo objectForKey:@"user_image"] withPlaceholderImage:[UIImage imageNamed:@"blank"]];
        _lblShortName.hidden = YES;
        _imgAvatar.backgroundColor = [UIColor clearColor];
    }
    
}

#pragma mark - Request API
- (void) requestUserInfo:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_GET_USERINFO withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.dicUserInfo = [result objectForKey:@"user_info"];
            [commonUtils setUserDefaultDic:@"user_info" withDic:appController.dicUserInfo];
            
            [self showDetail];
            
        } else {
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

- (void) requestUpdateImage:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_UPDATE_IMAGE withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.dicUserInfo = [result objectForKey:@"user_info"];
            [commonUtils setUserDefaultDic:@"user_info" withDic:appController.dicUserInfo];
            
            [self showDetail];
            
        } else {
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}
@end
