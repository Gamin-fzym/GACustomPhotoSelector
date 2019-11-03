//
//  ListViewController.m
//  PhotoDemo
//
//  Created by Gamin on 2018/10/26.
//  Copyright © 2018年 com.yyzb. All rights reserved.
//

#import "ListViewController.h"
#import <Photos/Photos.h>
#import "SVProgressHUD.h"

@interface ListViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *playIV;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"列表";
    _playIV.image = _img;
}

- (IBAction)savePictureAction:(id)sender {
    /**
    获取用户授权状态
    typedef NS_ENUM(NSInteger, PHAuthorizationStatus) {
        PHAuthorizationStatusNotDetermined = 0, // 不确定
        PHAuthorizationStatusRestricted,        // 家长控制,拒绝
        PHAuthorizationStatusDenied,            // 拒绝
        PHAuthorizationStatusAuthorized         // 授权
    } PHOTOS_AVAILABLE_IOS_TVOS_OSX(8_0, 10_0, 10_13);
    */
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        // 如果状态是不确定的话,block中的内容会等到授权完成再调用
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self savePhoto];
            }
        }];
    } else if (status == PHAuthorizationStatusAuthorized) {
        [self savePhoto];
    } else {
        // 提示用户去打开授权
        [SVProgressHUD showInfoWithStatus:@"进入设置界面->找到当前应用->打开允许访问相册开关"];
    }
}

#pragma mark - 该方法获取在图库中是否已经创建该App的相册
// 该方法的作用,获取系统中所有的相册进行遍历,若是已有该相册则返回该相册,若是没有该相册则返回nil,参数为需要创建的相册名称
- (PHAssetCollection *)fetchAssetColletion:(NSString *)albumTitle {
    // 获取所有的相册
    PHFetchResult *result = [PHAssetCollection           fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历相册数组
    for (PHAssetCollection *assetCollection in result) {
        if ([assetCollection.localizedTitle isEqualToString:albumTitle]) {
            return assetCollection;
        }
    }
    return nil;
}

#pragma mark - 保存图片的方法

- (void)savePhoto {
    // 修改系统相册用PHPhotoLibrary单例,调用performChanges,否则苹果会报错,并提醒你使用
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 调用判断是否已有该名称相册
        PHAssetCollection *assetCollection = [self fetchAssetColletion:@"测试相册"];
        // 创建一个操作图库的对象
        PHAssetCollectionChangeRequest *assetCollectionChangeRequest;
        if (assetCollection) {
            // 已有相册则获取该相册
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        } else {
            // 没有该相册则创建自定义相册
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"测试相册"];
        }
        // 保存你需要保存的图片到自定义相册
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:self.playIV.image];
        // 这个block是异步执行的,使用占位图片先为图片分配一个内存,等到有图片的时候,再对内存进行赋值
        PHObjectPlaceholder *placeholder = [assetChangeRequest placeholderForCreatedAsset];
        [assetCollectionChangeRequest addAssets:@[placeholder]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        // 弹出一个提示是否保存成功
        if (error) {
             [SVProgressHUD showErrorWithStatus:@"保存失败"];
        } else {
             [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }
    }];
}

@end
