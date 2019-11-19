//
//  PhotoManageCollectionViewCell.m
//  EzmCloud
//
//  Created by Phil on 2018/1/29.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import "PhotoManageCollectionViewCell.h"

@interface PhotoManageCollectionViewCell()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonConstraintW;
@end

@implementation PhotoManageCollectionViewCell{
    CGFloat buttonWidth;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    buttonWidth = self.buttonConstraintW.constant;
}

- (void)changeCellStyle:(PhotoManageCollectionViewCellStyle)style{
    switch (style) {
        case HasButton:
            self.buttonConstraintW.constant = buttonWidth;
            break;
        case NoButton:
            self.buttonConstraintW.constant = 0;
            break;
    }
}

- (IBAction)deleteButtonClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickDeleteButtonInItemIndex:)]) {
        [_delegate didClickDeleteButtonInItemIndex:self.tag];
    }
}

- (IBAction)editButtonClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickEditButtonInItemIndex:)]) {
        [_delegate didClickEditButtonInItemIndex:self.tag];
    }
}

-(UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes * attr = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
//    CGFloat originalLabelHeight = self.nameLabel.frame.size.height;
//    [self.nameLabel sizeToFit];
//    CGFloat heightIncreased = self.nameLabel.frame.size.height - originalLabelHeight;
    CGRect frame = layoutAttributes.frame;
//    frame.size.height += heightIncreased; //Key here
    attr.frame = frame;
    return attr;
}

@end
