//
//  showVideoVC.h
//  VideoTransitionApp
//
//  Created by leo on 13/5/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface showVideoVC : UIViewController
@property (nonatomic) PHAsset *asset1;
@property (nonatomic) PHAsset *asset2;
@property (nonatomic,strong) NSMutableArray *PhAssets;
@end

NS_ASSUME_NONNULL_END
