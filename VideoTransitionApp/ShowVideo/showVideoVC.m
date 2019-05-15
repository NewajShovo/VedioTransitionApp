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
    NSURL *temp;
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
    
//   dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//
//     dispatch_semaphore_t    semaphore1 = dispatch_semaphore_create(0);
//
//
//    [[PHImageManager defaultManager] requestAVAssetForVideo:self.asset2 options:option resultHandler:^(AVAsset * avasset, AVAudioMix * audioMix, NSDictionary * info) {
//        resultAsset2 = avasset;
//        dispatch_semaphore_signal(semaphore1);
//    }];
//   dispatch_semaphore_wait(semaphore1, DISPATCH_TIME_FOREVER);
    
    
    NSLog(@"HELLO");
    
    
    
    //getting a maincomposition where we will keep the asset.
    mainComposition = [[AVMutableComposition alloc] init];
    //Finding out video track
    AVMutableCompositionTrack *compositionVideoTrack = [mainComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime insertTime=kCMTimeZero;
    
    //Assigning assets to the video track
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, resultAsset1.duration) ofTrack:[[resultAsset1 tracksWithMediaType:AVMediaTypeVideo] lastObject] atTime:insertTime error:nil];
//    insertTime =resultAsset1.duration;
//    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, resultAsset2.duration) ofTrack:[[resultAsset2 tracksWithMediaType:AVMediaTypeVideo] lastObject] atTime:insertTime error:nil];
//
   
//    videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    CGSize videoSize = [compositionVideoTrack naturalSize];
    NSLog(@"videoSize--- %f %f",videoSize.width,videoSize.height);
    
    //Creating a video composition
    AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
    
    
    
    videoComp.renderSize = CGSizeMake(_playerView.frame.size.width, _playerView.frame.size.height);
    videoComp.frameDuration = CMTimeMake(1, 30);
    
    NSLog(@"%f %f",videoComp.renderSize.width,videoComp.renderSize.height);
    
    CGSize original = CGSizeApplyAffineTransform(compositionVideoTrack.naturalSize, compositionVideoTrack.preferredTransform);
    
    NSLog(@"%f %f",original.width,original.height);
    CGAffineTransform originalTrans = compositionVideoTrack.preferredTransform;

//    CGFloat scaleX = (size.width / originalSize.width)*2;
//   CGFloat scaleY = size.height /originalSize.height;
    
    originalTrans = CGAffineTransformScale(originalTrans,videoComp.renderSize.width/original.width ,videoComp.renderSize.width/original.width);
    
    //Y axis nicher dike nambe
    
    double val = (original.height*videoComp.renderSize.width)/original.width;
    val = (videoComp.renderSize.height-val)/2;
    
    
    
    originalTrans =CGAffineTransformConcat(originalTrans,CGAffineTransformMakeTranslation(0,val));
    
//    _playerView.transform=originalSize;
    
    
    //Creating vidoecomposition instruction
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, mainComposition.duration);
    
    //creating videocomposition layer instruction
    AVMutableVideoCompositionLayerInstruction *ainstruction = [ AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    [ainstruction setOpacityRampFromStartOpacity:0 toEndOpacity:1 timeRange:CMTimeRangeMake(insertTime, CMTimeMakeWithSeconds(10,1))];
    [ainstruction setCropRectangleRampFromStartCropRectangle:CGRectZero toEndCropRectangle:CGRectMake(0,0,videoSize.width, videoSize.height) timeRange:CMTimeRangeMake(insertTime, CMTimeMakeWithSeconds(3,1))];
     [ainstruction setCropRectangleRampFromStartCropRectangle:CGRectZero toEndCropRectangle:CGRectMake(0,0,videoSize.width, videoSize.height) timeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(3,1))];
   
    
//      CGAffineTransform origTrans = compositionVideoTrack.preferredTransform;
      [ainstruction setTransform:originalTrans atTime:kCMTimeZero];
    
    
    
    
    //assigning layer instructions to the instruction
    instruction.layerInstructions = [ NSArray arrayWithObject:ainstruction ];
    
    
    //finally videocomposition instruction is added to video composition
    videoComp.instructions = [ NSArray arrayWithObject:instruction];
    
    
   
    
    
    
    
    
    
    
    
   
    
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mainComposition presetName:AVAssetExportPresetHighestQuality];
    
    NSURL *outputVideoURL=dataFilePath(@"tmpPost1.mp4"); //url of exportedVideo
    
    //that videocomposition is added to exported video composition
    
    exportSession.videoComposition = videoComp;
    exportSession.outputURL = outputVideoURL;
    
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    
    
    /**
     
     creating the time range i.e. make startTime and endTime.
     
     startTime should be the first frame time at which your exportedVideo should start.
     
     endTime is the time of last frame at which your exportedVideo should stop. OR it should be the duration of the         excpected exportedVideo length
     
     **/
    
    
//    exportSession.timeRange = mainComposition.timeRange;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
        
        switch (exportSession.status)
        
        {
                
            case
            AVAssetExportSessionStatusCompleted:
                
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSURL *finalUrl=dataFilePath(@"trimmedVideo1.mp4");
                    
                    NSData *urlData = [NSData dataWithContentsOfURL:outputVideoURL];
                    
                    NSError *writeError;
                    
                    //write exportedVideo to path/trimmedVideo.mp4
                    
                    [urlData writeToURL:finalUrl options:NSAtomicWrite error:&writeError];
                    
                    if (!writeError) {
                        
                        //update Original URL
                        
                        // originalURL=finalUrl;
                        
                        NSLog(@"saving");
                        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                        dispatch_async(q, ^{
                            
                            NSData *videoData = [NSData dataWithContentsOfURL:finalUrl];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                // Write it to cache directory
                                NSString *videoPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"file.mov"];
                                [videoData writeToFile:videoPath atomically:YES];
                                temp = [[NSURL alloc] initFileURLWithPath:videoPath ];
                                // After that use this path to save it to PhotoLibrary
                                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                                [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath] completionBlock:^(NSURL *assetURL, NSError *error)
                                 {
                                     if (error)
                                     {
                                         NSLog(@"Error");
                                     }
                                     else
                                     {
                                         NSString *message = @"Video addition done";
                                         UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                         message:message
                                                                                        delegate:nil
                                                                               cancelButtonTitle:nil
                                                                               otherButtonTitles:nil, nil];
                                         [toast show];
                                         
                                         int duration = 1; // duration in seconds
                                         
                                         
                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                             [toast dismissWithClickedButtonIndex:0 animated:YES];
                                         });
                                         
                                         NSLog(@"Success");
                                     
                                         
                                         
                                         
                                         
                                         
                                         
                                         
                                         
                                         [self play];
                                     
                                     }
                                     
                                 }];
                            });
                        });
                        
                        //update video Properties
                        
                        // [self updateParameters];
                        
                    }
                    
                    NSLog(@"Cut Done %ld %@", (long)exportSession.status, exportSession.error);
                    
                });
                
                
            }
                
                break;
                
            case AVAssetExportSessionStatusFailed:
                
                NSLog(@"Cut failed with error ===>>> %@",exportSession.error);
                
                break;
                
            case AVAssetExportSessionStatusCancelled:
                
                NSLog(@"Canceled:%@",exportSession.error);
                
                break;
                
            default:
                NSLog(@"HEllo");
                break;
                
        }
        
    }];
    
    
    
    
    
//    [mutableComposition ad]
    

    
}
#pragma mark - VideoPlay
-(void) play
{
    NSLog(@"playing");
    _playerItem = [AVPlayerItem playerItemWithURL:temp];
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
