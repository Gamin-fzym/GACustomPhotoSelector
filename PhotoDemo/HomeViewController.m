//
//  HomeViewController.m
//  PhotoDemo
//
//  Created by Gamin on 2018/10/26.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import "HomeViewController.h"
#import <CoreServices/CoreServices.h>
#import "TOCropViewController.h"
#import "PureCamera.h"
#import "ListViewController.h"
#import "SVProgressHUD.h"
#import "GACustomSelectPIC.h"
#import "GACustomSelectProtocol.h"
#import "GAPublicMethod.h"

@interface HomeViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate, GACustomSelectProtocol>
@property (weak, nonatomic) IBOutlet UIButton *photoBut;
@property (strong, nonatomic) UIImage *displayImg;
@property (strong, nonatomic) UIImagePickerController *ipc;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation HomeViewController

- (void)dealloc {
    _displayImg = nil;
    _ipc = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
}

- (void)entryListVCWith:(UIImage *)image {
    _displayImg = image;
    [_photoBut setBackgroundImage:image forState:UIControlStateNormal];

    ListViewController *lVC = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
    lVC.img = image;
    [self.navigationController pushViewController:lVC animated:YES];
}

- (IBAction)tapPhotoAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectTakePhoto];
    }];
    [alert addAction:cameraAction];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectAlbum];
    }];
    [alert addAction:albumAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)selectTakePhoto {
    // 引用相机
    PureCamera *homec = [[PureCamera alloc] init];
    __weak typeof(self)myself = self;
    homec.fininshcapture = ^(UIImage *image){
        if (image) {
            [myself entryListVCWith:image];
        }
    } ;
    [self presentViewController:homec animated:NO completion:^{}];
}

- (void)selectAlbum {
    if (!self.ipc) {
        self.ipc = [[UIImagePickerController alloc] init];
        self.ipc.delegate = self;
        self.ipc.navigationBar.translucent = NO;
        self.ipc.edgesForExtendedLayout = UIRectEdgeNone;
        //self.ipc.allowsEditing = YES;
    }
    self.ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.ipc animated:YES completion:^{}];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 从info取出此时摄像头的媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // 获取照片的原图
        UIImage *original = [info objectForKey:UIImagePickerControllerOriginalImage];

        // 引用图片裁剪页
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:original aspectRatioStle:TOCropViewControllerAspectRatioOriginal];
        cropController.delegate = self;
        // [self pushViewController:cropController animated:YES];
        [picker presentViewController:cropController animated:YES completion:nil];
    } else {
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - TOCropViewControllerDelegate

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    if (image) {
        //[cropViewController.navigationController popViewControllerAnimated:YES];
        [cropViewController dismissViewControllerAnimated:YES completion:nil];
        [_ipc dismissViewControllerAnimated:NO completion:^{}];
        [self entryListVCWith:image];
    }
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 自定义图片选择器

- (IBAction)customSelectPicture:(id)sender {
    GACustomSelectPIC *custom = [[GACustomSelectPIC alloc] initWithNibName:@"GACustomSelectPIC" bundle:nil];
    custom.delegate = self;
    custom.tempLimitMax = 5;
    [self.navigationController pushViewController:custom animated:YES];
}

#pragma mark - GACustomSelectProtocol

- (void)customSelectAssets:(NSMutableArray *)assets {
    NSArray *subViews = [self.scrollView subviews];
    for (int i = 0 ; i < subViews.count ; i ++) {
        UIView *tempView = [subViews objectAtIndex:i];
        [tempView removeFromSuperview];
    }
    
    float width = self.scrollView.bounds.size.height;
    NSMutableArray *selectImages = [NSMutableArray new];
    for (int i = 0 ; i < assets.count ; i ++) {
        id tempAsset = [assets objectAtIndex:i];
        [self fetchImageWithAsset:tempAsset imageBlock:^(UIImage * _Nonnull image) {
            [selectImages addObject:image];
            //NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            UIImageView *tempIV = [UIImageView new];
            tempIV.frame = CGRectMake(i*width, 0, width, width);
            tempIV.image = image;
            tempIV.contentMode = UIViewContentModeScaleAspectFill;
            [tempIV.layer setMasksToBounds:YES];
            [self.scrollView addSubview:tempIV];
            [self.scrollView setContentSize:CGSizeMake(CGRectGetMaxX(tempIV.frame), width)];
        }];
    }
}
    
@end
