//
//  ShowImageVC.m
//  VideoTransitionApp
//
//  Created by leo on 13/5/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import "ShowImageVC.h"

@interface ShowImageVC ()

@end

@implementation ShowImageVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.synchronous = true;
    requestOptions.networkAccessAllowed = YES;
    PHImageManager *manager = [PHImageManager defaultManager];
    //    _asset = asset;
    [manager requestImageForAsset:_assets
     //                           targetSize:CGSizeMake(screenBounds.size.width*screenScale*.5,screenBounds.size.height*screenScale*.5)
                       targetSize:PHImageManagerMaximumSize
                      contentMode:PHImageContentModeDefault
                          options:requestOptions
                    resultHandler:^void(UIImage *image, NSDictionary *info) {
                        self.img=image;
                    }];
    
    
    
    
    
    
    self.ImageView.image =self.img;
    // Do any additional setup after loading the view from its nib.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
