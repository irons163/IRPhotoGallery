//
//  InventoryPhotoViewController.h
//  EnGeniusCloud
//
//  Created by WeiJun on 2019/6/4.
//  Copyright © 2019 EnGenius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGCamera.h"

NS_ASSUME_NONNULL_BEGIN

@interface InventoryPhotoViewController : UIViewController

+ (instancetype)new __attribute__
((unavailable("[+new] is not allowed, use [+newWithDelegate:photo:]")));

- (instancetype) init __attribute__
((unavailable("[-init] is not allowed, use [+newWithDelegate:photo:]")));

+ (instancetype)newWithDelegate:(id<TGCameraDelegate>)delegate photo:(UIImage *)photo;

- (void)setAlbumPhoto:(BOOL)isAlbumPhoto;

@end

NS_ASSUME_NONNULL_END
