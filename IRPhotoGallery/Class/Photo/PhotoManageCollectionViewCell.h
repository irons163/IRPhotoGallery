//
//  PhotoManageCollectionViewCell.h
//  EzmCloud
//
//  Created by Phil on 2018/1/29.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PhotoManageCollectionViewCellStyle){
    HasButton,
    NoButton
};

@protocol PhotoManageCollectionViewCellDelegate <NSObject>
- (void)didClickDeleteButtonInItemIndex:(NSInteger)itemIndex;
- (void)didClickEditButtonInItemIndex:(NSInteger)itemIndex;
@end

@interface PhotoManageCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) id<PhotoManageCollectionViewCellDelegate>delegate;

- (void)changeCellStyle:(PhotoManageCollectionViewCellStyle)style;
- (IBAction)deleteButtonClick:(id)sender;
- (IBAction)editButtonClick:(id)sender;
@end
