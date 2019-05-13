//
//  ViewController.h
//  VideoTransitionApp
//
//  Created by leo on 13/5/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) IBOutlet UICollectionView *collectionView;

@property(nonatomic, strong) NSMutableArray *assets;
@property (nonatomic,strong) NSMutableArray *selectedAssets;
@property(nonatomic, strong) NSArray *photos;
@property (nonatomic,strong) NSArray *images;

@end
