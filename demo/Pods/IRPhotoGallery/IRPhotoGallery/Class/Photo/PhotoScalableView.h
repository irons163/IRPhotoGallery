//
//  PhotoScalableView.h
//  EzmCloud
//
//  Created by Phil on 2018/1/26.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScalableView : UIScrollView

@property UIImageView* imageView;

- (void)resetZoom;

@end
