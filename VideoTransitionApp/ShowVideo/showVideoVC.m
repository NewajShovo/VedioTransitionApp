//
//  showVideoVC.m
//  VideoTransitionApp
//
//  Created by leo on 13/5/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import "showVideoVC.h"
#import "PlayerView.h"
#import "myslider.h"
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
    float canvasHeight;
    float canvasWidth;
    float permanentCanvasHeight;
    float permanentCanvasWidth;
    float additionalValue;
}


- (void)viewDidLoad {
//    [self logAllFilters];
    [super viewDidLoad];
    [_mySlider setValue:_mySlider.maximumValue/2];
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
    
    //Canvas Heigt Width set
    
    canvasHeight =_playerView.frame.size.height;
    canvasWidth = _playerView.frame.size.width;
    
    
    [self play];
    
    
    
    
    
}
-(void) play{
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1,30);
    videoComposition.renderScale = 1.0;
    AVAssetTrack *sourceVideoTrack = [[resultAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    [compositionVideoTrack insertTimeRange:sourceVideoTrack.timeRange ofTrack:sourceVideoTrack atTime:[composition duration] error:nil];
    
    permanentCanvasHeight= canvasHeight;
    permanentCanvasWidth = canvasWidth;
    AVMutableVideoComposition *temp = [self CustomVideoComposition:composition];
    temp.renderSize=CGSizeMake(permanentCanvasWidth, permanentCanvasHeight);
    
    
    
    _playerItem = [AVPlayerItem playerItemWithAsset:composition];
    _playerItem.videoComposition = temp;
    _player = [AVPlayer playerWithPlayerItem:self.playerItem];
    _playerView.player = _player;
    [self.player play];
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
        NSLog(@"---%f %f----",canvasWidth,canvasHeight);
        //smaller Image
        //** landscape Mode **//
        
        AVAssetTrack *sourceVideoTrack = [[resultAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        
        CGSize temp = CGSizeApplyAffineTransform(sourceVideoTrack.naturalSize, sourceVideoTrack.preferredTransform);
        CGSize size = CGSizeMake(fabs(temp.width), fabs(temp.height));
        CGAffineTransform transform = resultAsset1.preferredTransform;
        if(size.width>size.height){
            float s = canvasWidth/size.width;
            CGAffineTransform new = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(s,s));
            double changedHeight = (size.height*canvasHeight)/size.width;
            double changedWidth =  (size.width *canvasWidth)/size.width;
            changedWidth=(permanentCanvasWidth-canvasWidth)/2;
            changedHeight = (permanentCanvasHeight-changedHeight)/2;
        
            
            CGAffineTransform newer = CGAffineTransformConcat(new, CGAffineTransformMakeTranslation(changedWidth,changedHeight));
            backsource = [backsource imageByApplyingTransform:newer];
        }
        
        
        ///*** Potrait Mode ***///
        else{
            CGAffineTransform transform1 = resultAsset1.preferredTransform;

            float s1 = canvasHeight/size.height;
            CGAffineTransform new1 = CGAffineTransformConcat(transform1, CGAffineTransformMakeScale(s1,s1));
            double changedWidth = size.width*(canvasWidth/size.height);
            double changedHeight =size.height*(canvasHeight/size.height);
            changedWidth = (permanentCanvasWidth-changedWidth);
            changedHeight=(permanentCanvasHeight-changedHeight);
            
            changedHeight =changedHeight/2;
            changedWidth = changedWidth/2;
            CGAffineTransform newer1 = CGAffineTransformConcat(new1, CGAffineTransformMakeTranslation(changedWidth,changedHeight));
            backsource = [backsource imageByApplyingTransform:newer1];
        
        }
        
        
//        source=[source imageByApplyingTransform:C]
        
        CGAffineTransform tempSource = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(permanentCanvasWidth/source.extent.size.width,permanentCanvasHeight/source.extent.size.height));
        source =[source imageByApplyingTransform:tempSource];
        
        [filter1 setValue:source forKey:kCIInputImageKey];
        [filter setValue:backsource forKey:kCIInputImageKey];
        source =filter1.outputImage;
        
        // Vary filter parameters based on video timing
     
        Float64 seconds = CMTimeGetSeconds(request.compositionTime);
        [filter setValue:@(0.0) forKey:kCIInputRadiusKey];
        [filter1 setValue:@(5.0) forKey:kCIInputRadiusKey];

        [blend setValue:filter1.outputImage forKey:kCIInputBackgroundImageKey];
        [blend setValue:filter.outputImage forKey:kCIInputImageKey];
        
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
- (IBAction)mysliderVlaue:(id)sender {

    UISlider *slider = (UISlider *) sender;
    CGFloat value =slider.value;
    if(floorf(value)>=_mySlider.maximumValue/2){
        
    canvasWidth=permanentCanvasWidth+(((floorf(value)-(_mySlider.maximumValue/2)))*10);
    canvasHeight=permanentCanvasHeight+((( floorf(value)-(_mySlider.maximumValue/2)))*10);
    NSLog(@"----%f  %f----",canvasWidth,canvasHeight);
//    NSLog(@"----%f  %f----",changedHeight,changedWidth);
    
    }
    else{
        canvasWidth=permanentCanvasWidth-(((_mySlider.maximumValue/2)-floorf(value))*10);
        canvasHeight=permanentCanvasHeight-(((_mySlider.maximumValue/2)-floorf(value))*10);
    }

}
//-(void) mysliderValue:(CGFloat)value
//{
//
//   canvasWidth=permanentCanvasWidth-(floorf(value)*3);
//   canvasHeight=permanentCanvasHeight-(floorf(value)*3);
////    additionalValue =floorf(value);
//
//
//    NSLog(@"%f", floorf(value));
//    NSLog(@"%f",value);
//    NSLog(@"YESSS");
//
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
