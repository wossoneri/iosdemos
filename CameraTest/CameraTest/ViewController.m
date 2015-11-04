//
//  ViewController.m
//  CameraTest
//
//  Created by 杜博文 on 15/11/4.
//  Copyright © 2015年 wossoneri. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIButton *btn;
    UIImageView *iv;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Start Camera" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    
    iv = [[UIImageView alloc] init];
    
    [self.view addSubview:iv];
    [self.view addSubview:btn];
    
    
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(btn.mas_top);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    
    
}



- (void)onBtnClicked:(id)sender {
//    UIButton *btn = (UIButton *)sender;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.delegate = self;
        cameraPicker.allowsEditing = YES;
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        cameraPicker.showsCameraControls = YES;
        cameraPicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        cameraPicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        
        [self presentViewController:cameraPicker animated:YES completion:nil];
        
        
    }
    
}


#pragma mark - delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        iv.image = image;
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        iv.image = image;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [self presentViewController:cameraPicker animated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
