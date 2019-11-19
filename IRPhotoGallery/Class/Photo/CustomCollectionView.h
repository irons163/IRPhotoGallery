//
//  CustomCollectionView.h
//  EnShare
//
//  Created by Phil on 2016/12/15.
//  Copyright © 2016年 Senao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionView : UICollectionView

- (void)reloadDataWithCompletion:(void (^)(void))completionBlock;

@end
