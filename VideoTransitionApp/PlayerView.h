//
//  PlayerView.h
//  VideoTransitionApp
//
//  Created by leo on 13/5/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN
@class AVPlayer;
@interface PlayerView : UIView
@property (nonatomic,strong) AVPlayer *player;

@end

NS_ASSUME_NONNULL_END
