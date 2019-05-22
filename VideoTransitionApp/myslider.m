//
//  myslider.m
//  VideoTransitionApp
//
//  Created by leo on 21/5/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import "myslider.h"
#import "ShowVideo/showVideoVC.h"

@implementation myslider



- (IBAction)sliderMovement:(id)sender {
   UISlider *slider = (UISlider*)sender;
    [self.delegate mysliderValue:slider.value];
    
}









/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)dasa:(id)sender {
}
@end
