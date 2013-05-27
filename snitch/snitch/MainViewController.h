//
//  MainViewController.h
//  snitch
//
//  Created by Keith Elliott on 5/4/13.
//  Copyright (c) 2013 gittielabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SnitchCell.h"

@interface MainViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, StatusDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
