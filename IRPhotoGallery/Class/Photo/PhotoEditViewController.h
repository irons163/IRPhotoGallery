//
//  PhotoEditViewController.h
//  IRPhotoGallery
//
//  Created by Phil on 2019/12/24.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PhotoEditViewControllerDelegate <NSObject>

- (void)didCancel;
- (void)didTakePhoto:(UIImage *)image Note:(NSString *)note;

@end

@interface PhotoEditViewController : UIViewController

+ (instancetype)new __attribute__
((unavailable("[+new] is not allowed, use [+newWithDelegate:photo:]")));

- (instancetype) init __attribute__
((unavailable("[-init] is not allowed, use [+newWithDelegate:photo:]")));

+ (instancetype)newWithDelegate:(id<PhotoEditViewControllerDelegate>)delegate photo:(UIImage *)photo;

@end

NS_ASSUME_NONNULL_END
