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
@property (strong, nonatomic) IBOutlet UIImageView *Image;
@property (weak,nonatomic) IBOutlet PlayerView *playerView;
@property (weak,nonatomic) IBOutlet PlayerView *playerView1;
@property (nonatomic) AVPlayer *player;
@property (nonatomic) AVPlayer *player1;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong,nonatomic) AVPlayerItem *playerItem1;
@end

@implementation showVideoVC
{
//    CGAffineTransform newer1,newer;
    NSURL *temporary;
    AVMutableComposition *mainComposition;
    AVAsset *resultAsset1;
    AVAsset *resultAsset2;
    AVAsset *exportedVideo;
    AVVideoComposition *composition1;

}


- (void)viewDidLoad {
//    [self logAllFilters];
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
    
//    dispatch_semaphore_t    semaphore2 = dispatch_semaphore_create(0);
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    composition1 = [AVVideoComposition videoCompositionWithAsset: resultAsset1
//                                                        applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest *request){
//                                                            // Clamp to avoid blurring transparent pixels at the image edges
//                                                            CIImage *source = [request.sourceImage imageByClampingToExtent];
//                                                            [filter setValue:source forKey:kCIInputImageKey];
//
//                                                            [filter setValue:[NSNumber numberWithDouble:10.0] forKey:kCIInputRadiusKey];
//
//                                                            // Crop the blurred output to the bounds of the original image
//                                                            CIImage *output = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];
//
//                                                            // Provide the filter output to the composition
//                                                            [request finishWithImage:output context:nil];
//                                                        }];
    
    [self play];
    
}
-(void) play{
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
//    AVMutableComposition *anotherComposition = [ AVMutableComposition composition];
//
   // AVMutableCompositionTrack *compositionVideoTrack1 = [anotherComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1,30);
    videoComposition.renderScale = 1.0;
//
//    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
//    AVMutableVideoCompositionLayerInstruction *layerInstruction1= [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack1];
//    //    [self applyBlurOnAsset:resultAsset1 Completion:^(BOOL success, NSError *error, NSURL *videoUrl) {
//
//
//
//    AVMutableVideoCompositionLayerInstruction *rampLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack1];
//    AVMutableVideoCompositionLayerInstruction *rampLayerInstruction1 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack1];
//
//
//
//    float time = 0;
 AVAssetTrack *sourceVideoTrack = [[resultAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//    CGSize temp = CGSizeApplyAffineTransform(sourceVideoTrack.naturalSize, sourceVideoTrack.preferredTransform);
//    CGSize size = CGSizeMake(fabs(temp.width), fabs(temp.height));
//    CGAffineTransform transform = resultAsset1.preferredTransform;
//    videoComposition.renderSize = CGSizeMake(_playerView.frame.size.width, _playerView.frame.size.height);
//
//    float s = videoComposition.renderSize.width/size.width;
//    CGAffineTransform new = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(s,s));
//    double val = (size.height*videoComposition.renderSize.width)/size.width;
//    val = (videoComposition.renderSize.height-val)/2;
//     newer = CGAffineTransformConcat(new, CGAffineTransformMakeTranslation(0,val));
//    [layerInstruction setTransform:newer atTime:CMTimeMakeWithSeconds(time, 30)];
//    [layerInstruction1 setTransform:newer atTime:CMTimeMakeWithSeconds(time, 30)];
//
    [compositionVideoTrack insertTimeRange:sourceVideoTrack.timeRange ofTrack:sourceVideoTrack atTime:[composition duration] error:nil];
//    time += CMTimeGetSeconds(sourceVideoTrack.timeRange.duration);
//
//    time=time-3;
//
//
//    AVAssetTrack *sourceVideoTrack1 = [[exportedVideo tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//    CGSize temp1 = CGSizeApplyAffineTransform(sourceVideoTrack1.naturalSize, sourceVideoTrack1.preferredTransform);
//    CGSize size1 = CGSizeMake(fabs(temp1.width), fabs(temp1.height));
//    CGAffineTransform transform1 = exportedVideo.preferredTransform;
//
//    float s1 = videoComposition.renderSize.width/size1.width;
//    CGAffineTransform new1 = CGAffineTransformConcat(transform1, CGAffineTransformMakeScale(s1,s1));
//    double val1 = (size1.height*videoComposition.renderSize.width)/size1.width;
//    val1 = (videoComposition.renderSize.height-val1)/2;
//    newer1 = CGAffineTransformConcat(new1, CGAffineTransformMakeTranslation(0,val1));
//
////    [rampLayerInstruction setTransform:newer1 atTime:CMTimeMakeWithSeconds(time, 30)];
//    //    [rampLayerInstruction1 setTransform:newer1 atTime:CMTimeMakeWithSeconds(time, 30)];
    
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
    //        [rampLayerInstruction setCropRectangleRampFromStartCropRectangle:CGRectMake(0, 0,size1.width,0) toEndCropRectangle:CGRectMake(0, 0, size1.width, size1.height) timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    
    
    //**down swap**//
    //    [rampLayerInstruction setCropRectangleRampFromStartCropRectangle:CGRectMake(0, size1.height,size1.width,0) toEndCropRectangle:CGRectMake(0, 0, size1.width, size1.height) timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    
    //**mid Swap**//
    //[rampLayerInstruction setCropRectangleRampFromStartCropRectangle:CGRectMake(size1.width/2, size1.height/2,0,0) toEndCropRectangle:CGRectMake(0, 0, size1.width, size1.height) timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    
    
    //    [layerInstruction setCropRectangleRampFromStartCropRectangle:CGRectMake(0, 0,0,size.height) toEndCropRectangle:CGRectMake(size.width/2, size.height/2, -size.width/2, 0) timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    //    [layerInstruction setOpacityRampFromStartOpacity:1 toEndOpacity:0 timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    //
    //    [layerInstruction1 setCropRectangleRampFromStartCropRectangle:CGRectMake(size.width, 0,0,size.height) toEndCropRectangle:CGRectMake(size.width/2, size.height/2, size.width/2, 0) timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    //    [layerInstruction1 setOpacityRampFromStartOpacity:1 toEndOpacity:0 timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(time, 30),CMTimeMakeWithSeconds(3,NSEC_PER_SEC))];
    //
 
//    [compositionVideoTrack1 insertTimeRange:sourceVideoTrack1.timeRange ofTrack:sourceVideoTrack1 atTime:CMTimeMakeWithSeconds(time, 30) error:nil];
    

    //[compositionVideoTrack1 insertTimeRange:sourceVideoTrack1.timeRange ofTrack:sourceVideoTrack1 atTime:kCMTimeZero error:nil];

    
    
    ///ramplayer upore kaj korbe , layer instruction niche kaj korbe (the uppermost(first) layer works first)
    
    //instruction.layerInstructions = [NSArray arrayWithObjects:rampLayerInstruction1,rampLayerInstruction,layerInstruction,nil];
//
//    instruction.layerInstructions = [ NSArray arrayWithObjects:layerInstruction,layerInstruction1, nil];
//    instruction.timeRange = CMTimeRangeMake(kCMTimeZero,composition.duration);
//    videoComposition.instructions = [NSArray arrayWithObject:instruction];
//
    
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"position.x";
//    animation.fromValue = @120;
//    animation.toValue = @185;
//    animation.duration = 2;
//    [_playerView.layer addAnimation:animation forKey:@"basic"];
//
    
//    _playerItem = [AVPlayerItem playerItemWithAsset:composition];
    AVMutableVideoComposition *temp = [self CustomVideoComposition:composition];
    temp.renderSize=CGSizeMake(320, 320);
    
    
    
    _playerItem = [AVPlayerItem playerItemWithAsset:composition];
    _playerItem.videoComposition = temp;
    _player = [AVPlayer playerWithPlayerItem:self.playerItem];
    _playerView.player = _player;
    [self.player play];
    // 1 - set up the overlay
    
}
- (AVMutableVideoComposition*)CustomVideoComposition:(AVMutableComposition*)composition{
    
    //
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    CIFilter *filter1 =[CIFilter filterWithName:@"CIGaussianBlur"];
    CIFilter *blend = [ CIFilter filterWithName:@"CISourceOverCompositing"];
    return [AVMutableVideoComposition videoCompositionWithAsset: composition applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest *request){
        
    
        //Background Image
        CIImage *source = request.sourceImage;
        CIImage *backsource=request.sourceImage;
       
        //smaller Image
        //** landscape Mode **//
        
        AVAssetTrack *sourceVideoTrack = [[resultAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        
        CGSize temp = CGSizeApplyAffineTransform(sourceVideoTrack.naturalSize, sourceVideoTrack.preferredTransform);
        CGSize size = CGSizeMake(fabs(temp.width), fabs(temp.height));
        if(size.width>size.height){
        CGAffineTransform transform = resultAsset1.preferredTransform;
        float s = 320/size.width;
        CGAffineTransform new = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(s,s));
        double val = (size.height*320)/size.width;
        val = (320-val)/2;
        CGAffineTransform newer = CGAffineTransformConcat(new, CGAffineTransformMakeTranslation(0,val));
        backsource = [backsource imageByApplyingTransform:newer];
        }
        ///*** Potrait Mode ***///
        else{
            AVAssetTrack *sourceVideoTrack1 = [[resultAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            CGSize temp1 = CGSizeApplyAffineTransform(sourceVideoTrack1.naturalSize, sourceVideoTrack1.preferredTransform);
            CGSize size1 = CGSizeMake(fabs(temp1.width), fabs(temp1.height));
            CGAffineTransform transform1 = resultAsset1.preferredTransform;

            float s1 = 320/size1.height;
            CGAffineTransform new1 = CGAffineTransformConcat(transform1, CGAffineTransformMakeScale(s1,s1));
            double val1 = size1.width*((320)/size1.height);
            val1 = (320-val1)/2;
            CGAffineTransform newer1 = CGAffineTransformConcat(new1, CGAffineTransformMakeTranslation(val1,0));
            backsource = [backsource imageByApplyingTransform:newer1];
        
        }
        
        
        
        
        
        
        
        
        

        [filter1 setValue:source forKey:kCIInputImageKey];
        [filter setValue:backsource forKey:kCIInputImageKey];
        
        
        // Vary filter parameters based on video timing
     
        Float64 seconds = CMTimeGetSeconds(request.compositionTime);
        [filter setValue:@(0.0) forKey:kCIInputRadiusKey];
        [filter1 setValue:@(10.0) forKey:kCIInputRadiusKey];
  
        [blend setValue:filter1.outputImage forKey:kCIInputBackgroundImageKey];
        [blend setValue:filter.outputImage forKey:kCIInputImageKey];
//        [blend setValue:@(0.0) forKey:kCIInputImageKey];
        
        // Provide the filter output to the composition
        [request finishWithImage:blend.outputImage context:nil];
    }];
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
