//
//  PhotoManageBrowser.h
//  EzmCloud
//
//  Created by Phil on 2018/1/30.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CustomCollectionView.h"

typedef NS_ENUM(NSUInteger, PhotoManageBrowserStyle){
    Normal,
    Deletable,
    Scalable
};

typedef NS_ENUM(NSUInteger, PhotoManageBrowserScrollDirection){
    ScrollDirectionVertical,
    ScrollDirectionHorizontal
};

typedef void(^CurrentPageChangedBlock)(NSInteger currentPage);
typedef void(^ItemSelectedBlock)(NSIndexPath* indexPath);
typedef void(^DeleteClickBlock)(NSInteger index);
typedef void(^EditClickBlock)(NSInteger index);

@protocol PhotoManageBrowserDelegate <NSObject>
- (NSUInteger)numberOfPhotos;
- (NSString*)titleOfPhotoWithIndex:(NSInteger)index;
- (id)imageOrPathStringOfPhotoWithIndex:(NSInteger)index;
@end

@interface PhotoManageBrowser : UIView

@property (nonatomic, weak) id<PhotoManageBrowserDelegate> delegate;
@property (nonatomic) PhotoManageBrowserStyle style;
@property (nonatomic) PhotoManageBrowserScrollDirection direction;
@property (nonatomic, copy) CurrentPageChangedBlock currentPageChangedBlock;
@property (nonatomic, copy) ItemSelectedBlock itemSelectedBlock;
@property (nonatomic, copy) DeleteClickBlock deleteClickBlock;
@property (nonatomic, copy) EditClickBlock editClickBlock;

- (void)gotoImageIndex:(NSInteger)imageIndex;
- (void)reloadData;
- (void)reloadDataWithCompletion:(void (^)(void))completionBlock;

@end
