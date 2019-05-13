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

@property (nonatomic) NSString *outputPath1;
//@property (nonatomic) IBOutlet UILabel *Label;
@property (nonatomic) id observer;
@property (nonatomic) PHAsset *asset1;
@property (nonatomic) PHAsset *asset2;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIView *frameView;
@property (weak, nonatomic) IBOutlet UIView *Scrollview;
@property (weak, nonatomic) IBOutlet UIView *start;
@property (weak, nonatomic) IBOutlet UIView *end;
//@property (nonatomic,readonly) BOOL prefersStatusBarHidden;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) IBOutlet UIImageView *splitImage;

@property (weak, nonatomic) IBOutlet UIView *startArrow;
@property (weak, nonatomic) IBOutlet UIView *endArrow;

@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;

@property (weak, nonatomic) IBOutlet UIImageView *movingView;

@property (strong, nonatomic) IBOutlet UIImageView *startImage;

@property (strong, nonatomic) IBOutlet UIImageView *endImage;
@property (strong, nonatomic) IBOutlet UIView *splitView;
@end

NS_ASSUME_NONNULL_END
