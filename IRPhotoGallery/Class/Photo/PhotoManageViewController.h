//
//  PhotoManageViewController.h
//  EzmCloud
//
//  Created by Phil on 2018/1/29.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoManageBrowser.h"

@protocol PhotoManageViewControllerDelegate <NSObject>


@end

@interface PhotoManageViewController : UIViewController
@property (nonatomic,weak) id<PhotoManageBrowserDelegate> delegate;
@end
