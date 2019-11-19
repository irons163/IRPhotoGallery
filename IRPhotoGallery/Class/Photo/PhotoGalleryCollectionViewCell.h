//
//  PhotoGalleryCollectionViewCell.h
//  EzmCloud
//
//  Created by Phil on 2018/1/29.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoScalableView.h"

@interface PhotoGalleryCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet PhotoScalableView *photoView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

@end
