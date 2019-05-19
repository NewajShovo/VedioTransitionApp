//
//  showVideoVC.m
//  VideoTransitionApp
//
//  Created by leo on 13/5/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import "showVideoVC.h"
#import "PlayerView.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface showVideoVC ()
@property (weak,nonatomic) IBOutlet PlayerView *playerView;
@property (nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@end

@implementation showVideoVC
{
    NSURL *temporary;
    AVMutableComposition *mainComposition;
    AVAsset *resultAsset1;
    AVAsset *resultAsset2;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_semaphore_t    semaphore = dispatch_semaphore_create(0);
    
    PHVideoRequestOptions *option = [PHVideoRequestOptions new];
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:self.asset1 options:option resultHandler:^(AVAsset * avasset, AVAudioMix * audioMix, NSDictionary * info) {
        resultAsset1 = avasset;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    
    dispatch_semaphore_t    semaphore1 = dispatch_semaphore_create(0);
    
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:self.asset2 options:option resultHandler:^(AVAsset * avasset, AVAudioMix * audioMix, NSDictionary * info) {
        resultAsset2 = avasset;
        dispatch_semaphore_signal(semaphore1);
    }];
    dispatch_semaphore_wait(semaphore1, DISPATCH_TIME_FOREVER);
    
    
    NSLog(@"HELLO");
    
    // New code for merging two video's with different orientation;
    
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compositionVideoTrack1 = [ composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1,30);
    videoComposition.renderScale = 1.0;
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    
    AVMutableVideoCompositionLayerInstruction *rampLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack1];
    AVMutableVideoCompositionLayerInstruction *rampLayerInstruction1 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack1];
    
    
    
    float time = 0;
    AVAssetTrack *sourceVideoTrack = [[resultAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize temp = CGSizeApplyAffineTransform(sourceVideoTrack.naturalSize, sourceVideoTrack.preferredTransform);
    CGSize size = CGSizeMake(fabs(temp.width), fabs(temp.height));
    CGAffineTransform transform = resultAsset1.preferredTransform;
    videoComposition.renderSize = CGSizeMake(_playerView.frame.size.width, _playerView.frame.size.height);
    
    float s = videoComposition.renderSize.width/size.width;
    CGAffineTransform new = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(s,s));
    double val = (size.height*videoComposition.renderSize.width)/size.width;
    val = (videoComposition.renderSize.height-val)/2;
    CGAffineTransform newer = CGAffineTransformConcat(new, CGAffineTransformMakeTranslation(0,val));
    [layerInstruction setTransform:newer atTime:CMTimeMakeWithSeconds(time, 30)];
    
    [compositionVideoTrack insertTimeRange:sourceVideoTrack.timeRange ofTrack:sourceVideoTrack atTime:[composition duration] error:nil];
    time += CMTimeGetSeconds(sourceVideoTrack.timeRange.duration);
    
    time=time-3;
    
    
    AVAssetTrack *sourceVideoTrack1 = [[resultAsset2 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize temp1 = CGSizeApplyAffineTransform(sourceVideoTrack1.naturalSize, sourceVideoTrack1.preferredTransform);
    CGSize size1 = CGSizeMake(fabs(temp1.width), fabs(temp1.height));
    CGAffineTransform transform1 = resultAsset2.preferredTransform;
    
    float s1 = videoComposition.renderSize.width/size1.width;
    CGAffineTransform new1 = CGAffineTransformConcat(transform1, CGAffineTransformMakeScale(s1,s1));
    double val1 = (size1.height*videoComposition.renderSize.width)/size1.width;
    val1 = (videoComposition.renderSize.height-val1)/2;
    CGAffineTransform newer1 = CGAffineTransformConcat(new1, CGAffineTransformMakeTranslation(0,val1));
    
    [rampLayerInstruction setTransform:newer1 atTime:CMTimeMakeWithSeconds(time, 30)];
    [rampLayerInstruction1 setTransform:newer1 atTime:CMTimeMakeWithSeconds(time, 30)];
    
    //***Top corner left**//
    //    [rampLayerInstruction setCropRectangleRampFromStartCropRectangle:CGRectZero toEndCropRectangle:CGRectMake(0, 0, size1.width, size1.height) timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    
    //**top corner right**//
    //   [rampLayerInstruction setCropRectangleRampFromStartCropRectangle:CGRectMake(size1.width, 0, 0, 0) toEndCropRectangle:CGRectMake(0, 0, size1.width, size1.height) timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    
    
    //**bottom Corner left**//
    //    [rampLayerInstruction setCropRectangleRampFromStartCropRectangle:CGRectMake(0, size1.height, 0, 0) toEndCropRectangle:CGRectMake(0, 0, size1.width, size1.height) timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    
    
    //**bottom corner right**//
    //    [rampLayerInstruction setCropRectangleRampFromStartCropRectangle:CGRectMake(size1.width, size1.height, 0, 0) toEndCropRectangle:CGRectMake(0, 0, size1.width, size1.height) timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    
    //**left swap**//
    // [rampLayerInstruction setCropRectangleRampFromStartCropRectangle:CGRectMake(0, 0,0,size1.height) toEndCropRectangle:CGRectMake(0, 0, size1.width, size1.height) timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    
    //**right swap**//
    //    [rampLayerInstruction setCropRectangleRampFromStartCropRectangle:CGRectMake(size1.width, 0,0,size1.height) toEndCropRectangle:CGRectMake(0, 0, size1.width, size1.height) timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    //**up swap**//
        [rampLayerInstruction1 setCropRectangleRampFromStartCropRectangle:CGRectMake(0, 0,size1.width,0) toEndCropRectangle:CGRectMake(0, 0, size1.width, size1.height) timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
       [rampLayerInstruction1 setOpacityRampFromStartOpacity:0 toEndOpacity:1 timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    
    //**down swap**//
    [rampLayerInstruction setCropRectangleRampFromStartCropRectangle:CGRectMake(0, size1.height,size1.width,0) toEndCropRectangle:CGRectMake(0, 0, size1.width, size1.height) timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    [rampLayerInstruction setOpacityRampFromStartOpacity:1 toEndOpacity:0 timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    //**mid Swap**//
    //[rampLayerInstruction setCropRectangleRampFromStartCropRectangle:CGRectMake(size1.width/2, size1.height/2,0,0) toEndCropRectangle:CGRectMake(0, 0, size1.width, size1.height) timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    
    
    [compositionVideoTrack1 insertTimeRange:sourceVideoTrack1.timeRange ofTrack:sourceVideoTrack1 atTime:CMTimeMakeWithSeconds(time, 30) error:nil];
    
    
    
    
    
    ///ramplayer upore kaj korbe , layer instruction niche kaj korbe
    
    instruction.layerInstructions = [NSArray arrayWithObjects:rampLayerInstruction1,rampLayerInstruction,layerInstruction,nil];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero,composition.duration);
    videoComposition.instructions = [NSArray arrayWithObject:instruction];
    
    
    
    _playerItem = [AVPlayerItem playerItemWithAsset:composition];
    _playerItem.videoComposition = videoComposition;
    _player = [AVPlayer playerWithPlayerItem:self.playerItem];
    _playerView.player = _player;
    [self.player play];
    
    
    
    
    
    
}


#pragma mark - dataFilepathCreation
NSURL * dataFilePath(NSString *path){
    //creating a path for file and checking if it already exist if exist then delete it
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), path];
    
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //check if file exist at outputPath
    success = [fileManager fileExistsAtPath:outputPath];
    
    if (success) {
        //delete if file exist at outputPath
        success=[fileManager removeItemAtPath:outputPath error:nil];
    }
    
    return [NSURL fileURLWithPath:outputPath];
    
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
