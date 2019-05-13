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
    
    
    
    
    
    
    
    AVMutableComposition *mainComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *compositionVideoTrack = [mainComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    

    CMTime insertTime=kCMTimeZero;
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, resultAsset1.duration) ofTrack:[[resultAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:insertTime error:nil];
//    insertTime=CMTimeMakeWithSeconds(CMTimeGetSeconds(insertTime) + 10, NSEC_PER_SEC);
    insertTime = CMTimeAdd(insertTime, resultAsset2.duration);
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, resultAsset2.duration) ofTrack:[[resultAsset2 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:insertTime error:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mainComposition presetName:AVAssetExportPresetHighestQuality];
    
    NSURL *outputVideoURL=dataFilePath(@"tmpPost.mp4"); //url of exportedVideo
    
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
                    
                    NSURL *finalUrl=dataFilePath(@"trimmedVideo.mp4");
                    
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
                                         NSString *message = @"Video Cut Done";
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
                
                break;
                
        }
        
    }];
    
    
    
    
    
//    [mutableComposition ad]
    
    _playerItem = [AVPlayerItem playerItemWithAsset:resultAsset1];
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
