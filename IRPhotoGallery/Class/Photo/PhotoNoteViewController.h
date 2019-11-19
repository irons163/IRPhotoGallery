//
//  PhotoNoteViewController.h
//  EZMCloud
//
//  Created by Phil on 2018/3/30.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ImageClass.h"

@protocol PhotoNoteViewControllerDelegate <NSObject>
- (void)shouldApply:(NSString*)newNote;
@optional
- (void)willClose;
@end

@interface PhotoNoteViewController : UIViewController

@property (weak) id<PhotoNoteViewControllerDelegate> delegate;
//@property (nonatomic,weak) ImageClass* currentImage;
@property NSString* note;

@end
