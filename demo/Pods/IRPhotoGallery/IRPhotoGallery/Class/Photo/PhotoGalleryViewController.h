//
//  PhotoGalleryViewController.h
//  EzmCloud
//
//  Created by Phil on 2018/1/26.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ImageClass.h"
#import "PhotoManageBrowser.h"

@interface PhotoGalleryViewController : UIViewController

//@property (nonatomic,weak) NSArray<ImageClass*> *photoArray;
@property (nonatomic,weak) id<PhotoManageBrowserDelegate> delegate;
@property NSInteger imageIndex;

@end
