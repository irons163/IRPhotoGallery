//
//  PhotoNoteViewController.h
//  EZMCloud
//
//  Created by Phil on 2018/3/30.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCallback.h"

@protocol PhotoNoteViewControllerDelegate <NSObject>
- (void)shouldApplyImage:(UIImage * _Nullable)image Note:(NSString*_Nullable)newNote Completed:(nullable IRCompletionBlock)completedBlock;
@optional
- (void)willClose;
@end

@interface PhotoNoteViewController : UIViewController

@property (weak, nullable) id<PhotoNoteViewControllerDelegate> delegate;
@property (weak, nullable) UIImage *currentImage;
@property (weak, nullable) NSString *note;

@end
