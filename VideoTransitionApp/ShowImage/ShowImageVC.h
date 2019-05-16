//
//  ShowImageVC.h
//  VideoTransitionApp
//
//  Created by leo on 13/5/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface ShowImageVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UIImage *img;
@property (weak, nonatomic) IBOutlet PHAsset *assets;
@end

NS_ASSUME_NONNULL_END
