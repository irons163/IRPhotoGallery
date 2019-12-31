//
//  PhotoManageViewController.h
//  EzmCloud
//
//  Created by Phil on 2018/1/29.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoManageBrowser.h"
#import "PhotoCallback.h"

@protocol CameraViewControllerDelegate <NSObject>

@optional
- (BOOL)shouldOpenCamera;
- (void)willOpenCamera;
- (void)didTakePhoto:(UIImage *)image Note:(NSString *)note;
- (void)doUpdatePhoto:(UIImage *)image Note:(NSString *)note Completed:(nullable IRCompletionBlock)completedBlock;
- (void)doDeletePhoto:(UIImage *)image;

@end

@interface PhotoManageViewController : UIViewController

@property (nonatomic,weak, nullable) id<PhotoManageBrowserDelegate> delegate;
@property (nonatomic,weak, nullable) id<CameraViewControllerDelegate> cameraDelegate;
@property (nonatomic, copy, nullable) ItemSelectedBlock itemSelectedBlock;

- (void)reloadUI;
- (void)showLoading:(BOOL)isShow;

@end
