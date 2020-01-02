//
//  IRCameraViewController.h
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double IRCameraViewControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char IRCameraViewControllerVersionString[];

#import <IRCameraViewController/IRAssetsLibrary.h>
#import <IRCameraViewController/IRCamera.h>
#import <IRCameraViewController/IRCameraColor.h>
#import <IRCameraViewController/IRCameraNavigationController.h>
#import <IRCameraViewController/IRAssetImageFile.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IRCameraViewControllerDelegate <NSObject>

- (void)didFinishPickingImage:(UIImage*)image;

@end

@interface IRCameraViewController : UIViewController

@property (weak) id<IRCameraDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
