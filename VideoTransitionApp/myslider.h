//
//  myslider.h
//  VideoTransitionApp
//
//  Created by leo on 21/5/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol mysliderViewDelegate <NSObject>

-(void) mysliderUpdateInfo;

-(void) mysliderValue:(CGFloat)value;


@end

@interface myslider : UIView

//delegate
@property (nonatomic,strong) IBOutlet id <mysliderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
