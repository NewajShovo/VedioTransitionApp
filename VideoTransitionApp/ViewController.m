//
//  ViewController.m
//  CustomGallery
//
//  Created by leo on 24/4/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "PhotoCellCustom/photoCellCollectionViewCell.h"
#import "ShowImage/ShowImageVC.h"
#import "ShowVideo/showVideoVC.h"

@interface ViewController ()

@end

@implementation ViewController
bool flag =true;
int cnt=0;
-(BOOL) prefersStatusBarHidden{
    return  NO;
}
- (void)viewDidLoad {
    cnt=0;
    _collectionView.allowsMultipleSelection = true;
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [super viewDidLoad];
    [self loadData];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) loadData
{
    _selectedAssets = [[ NSMutableArray alloc] init];
    _assets = [@[] mutableCopy];
    _images=[@[]mutableCopy];
    
    
    PHFetchResult *result;
    if(flag) result= [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    else result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
    
    NSLog(@"%d",(int)result.count);
    
    for (PHAsset *val in result)
    {
        [_assets addObject:val];
    }
    [self.collectionView reloadData];
}



#pragma mark - collection view data source

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    photoCellCollectionViewCell *cell = (photoCellCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    PHAsset *asset = self.assets[indexPath.row];
    cell.photoImageView.image=nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.asset =asset;
            
        });
        
    });
    
    return cell;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"here here");
    photoCellCollectionViewCell *cell = (photoCellCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    PHAsset *tmpasset = self.assets[indexPath.row];
    UIImage *img= [cell getImageFromAsset:tmpasset];
    [_selectedAssets addObject:tmpasset];
    cell.selectedBackgroundView.tintColor=[UIColor lightGrayColor];
    NSLog(@"%lu",(unsigned long)_selectedAssets.count);
    
    // flag true for showing image and other for video
    if(flag) {
    
        ShowImageVC *vc1 = (ShowImageVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"showImageVC"];
        //    PlayerDisplayVCViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"PlayerDisplayVCViewController"];
        vc1.assets =tmpasset;
       [self. navigationController pushViewController:vc1 animated:YES];
    }
   else if(_selectedAssets.count==2)
   {
    
       
       showVideoVC *vc2 = (showVideoVC *) [self.storyboard instantiateViewControllerWithIdentifier:@"showVideoVC"];
       vc2.PhAssets=[[NSMutableArray alloc]init];
       [vc2.PhAssets addObject:[_selectedAssets objectAtIndex:0]];
       [vc2.PhAssets addObject:[_selectedAssets objectAtIndex:1]];
       [_selectedAssets removeAllObjects];
       [ self.navigationController pushViewController:vc2 animated:YES];
   }
    
}
#pragma  mark - image and video button clicked
- (IBAction)imgBtnClicked:(id)sender {
    
    flag = true;
    [self loadData];
    NSLog(@"IMage");
    
    
}
- (IBAction)videoBtnClicked:(id)sender {
    flag =false;
    [self loadData];
    
    
}

@end
