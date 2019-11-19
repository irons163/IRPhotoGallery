                                                                                                                                                                                                                                                                                                                                                                                                                        //
//  PhotoManageBrowser.m
//  EzmCloud
//
//  Created by Phil on 2018/1/30.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import "PhotoManageBrowser.h"
#import "PhotoManageCollectionViewCell.h"
#import "PhotoGalleryCollectionViewCell.h"
#import "CustomCollectionView.h"
#import "UIImageView+WebCache.h"

@interface PhotoManageBrowser()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PhotoManageCollectionViewCellDelegate>

@property (strong, nonatomic, readwrite) IBOutlet CustomCollectionView *photomanageCollectionView;
@end

@implementation PhotoManageBrowser{
    NSArray *_photoURLArray, *_photoNameArray;
    NSLayoutConstraint * heightConstraint;
    NSInteger currentPageIndex;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

-(void)setup{
//    NSString *nibName = NSStringFromClass([self class]);
//    NSArray *views = [[NSBundle mainBundle] loadNibNamed:nibName
//                                  owner:self
//                                options:nil];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *nibName = NSStringFromClass([self class]);
    NSArray *views = [bundle loadNibNamed:nibName owner:self options:nil];
    UIView *viewFromNib = [views firstObject];
    viewFromNib.translatesAutoresizingMaskIntoConstraints = false;
    
    [self addSubview:viewFromNib];
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:viewFromNib attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:viewFromNib attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:viewFromNib attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint * bottomConstraint = [NSLayoutConstraint constraintWithItem:viewFromNib attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint * centerXConstraint = [NSLayoutConstraint constraintWithItem:viewFromNib attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint * centerYConstraint = [NSLayoutConstraint constraintWithItem:viewFromNib attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    heightConstraint = [NSLayoutConstraint constraintWithItem:viewFromNib attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    
    topConstraint.active = YES;
    bottomConstraint.active = YES;
    leadingConstraint.active = YES;
    trailingConstraint.active = YES;
    centerXConstraint.active = YES;
    centerYConstraint.active = YES;
    heightConstraint.active = YES;
    
    [[[SDImageCache sharedImageCache] config] setShouldDecompressImages:NO];
    [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    
    [self initPhotoCollectionView];
}

-(BOOL)isBindedWithArray:(NSArray*)array{
    return _photoURLArray == array;
}

-(void)bindArray:(NSArray*)array{
    _photoURLArray = array;
}

-(void)bindNameArray:(NSArray*)nameArray{
    _photoNameArray = nameArray;
}

-(void)gotoImageIndex:(NSInteger)imageIndex{
    [self reloadDataWithCompletion:^{
        [self.photomanageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:imageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        if(self.photomanageCollectionView.isPagingEnabled){
            [self setCurrentPageIndex:imageIndex];
        }
    }];
}

-(void)setStyle:(PhotoManageBrowserStyle)style{
    _style = style;
    
    switch (self.style) {
        case Normal:{
            [((UICollectionViewFlowLayout *)self.photomanageCollectionView.collectionViewLayout) setMinimumLineSpacing:0];
            self.photomanageCollectionView.pagingEnabled = NO;
            break;
        }
        case Deletable:{
            [((UICollectionViewFlowLayout *)self.photomanageCollectionView.collectionViewLayout) setMinimumLineSpacing:15];
            self.photomanageCollectionView.pagingEnabled = NO;
            break;
        }
        case Scalable:{
            [((UICollectionViewFlowLayout *)self.photomanageCollectionView.collectionViewLayout) setMinimumLineSpacing:0];
            self.photomanageCollectionView.pagingEnabled = YES;
            break;
        }
    }
}

-(void)setDirection:(PhotoManageBrowserScrollDirection)direction{
    _direction = direction;
    switch (self.direction) {
        case ScrollDirectionVertical:
            [((UICollectionViewFlowLayout *)self.photomanageCollectionView.collectionViewLayout) setScrollDirection:UICollectionViewScrollDirectionVertical];
            break;
        case ScrollDirectionHorizontal:
            [((UICollectionViewFlowLayout *)self.photomanageCollectionView.collectionViewLayout) setScrollDirection:UICollectionViewScrollDirectionHorizontal];
            break;
    }
}

-(void)reloadData{
    [self.photomanageCollectionView reloadDataWithCompletion:nil];
}

-(void)reloadDataWithCompletion:(void (^)(void))completionBlock{
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        NSLog(@"reload completed");
        heightConstraint.constant = ((UICollectionViewFlowLayout *)self.photomanageCollectionView.collectionViewLayout).itemSize.height;
        completionBlock();
    }];
    NSLog(@"reloading");
    [self.photomanageCollectionView reloadData];
    [CATransaction commit];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat itemWidth,itemHeight;
    switch (self.direction) {
        case ScrollDirectionVertical:
            if(self.photomanageCollectionView.isPagingEnabled){
                itemWidth = self.photomanageCollectionView.bounds.size.width;
                itemHeight = self.photomanageCollectionView.bounds.size.height;
            }else{
                itemWidth = self.photomanageCollectionView.bounds.size.width - 10;
                itemHeight = itemWidth/2 + 20;
            }
            
            break;
            
        case ScrollDirectionHorizontal:
            if(self.photomanageCollectionView.isPagingEnabled){
                itemWidth = self.photomanageCollectionView.bounds.size.width;
                itemHeight = self.photomanageCollectionView.bounds.size.height;
            }else{
                itemWidth = self.photomanageCollectionView.bounds.size.width/3*2;
                itemHeight = itemWidth/16*11;
            }
            break;
    }

    ((UICollectionViewFlowLayout *)self.photomanageCollectionView.collectionViewLayout).itemSize = CGSizeMake(itemWidth, itemHeight);
//    ((UICollectionViewFlowLayout *)self.photomanageCollectionView.collectionViewLayout).estimatedItemSize = CGSizeMake(itemWidth > self.photomanageCollectionView.frame.size.width ? self.photomanageCollectionView.frame.size.width : itemWidth, itemHeight > self.photomanageCollectionView.frame.size.height ? self.photomanageCollectionView.frame.size.height : itemHeight);
    [self.photomanageCollectionView.collectionViewLayout invalidateLayout];
    [self.photomanageCollectionView layoutIfNeeded];
    [self.photomanageCollectionView reloadData];
}

-(void)initPhotoCollectionView{
    [self.photomanageCollectionView registerNib:[UINib nibWithNibName:@"PhotoManageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoManageCollectionViewCell"];
    [self.photomanageCollectionView registerNib:[UINib nibWithNibName:@"PhotoGalleryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoGalleryCollectionViewCell"];
    self.photomanageCollectionView.backgroundColor = [UIColor whiteColor];
    self.photomanageCollectionView.showsHorizontalScrollIndicator = NO;
    ((UICollectionViewFlowLayout *)self.photomanageCollectionView.collectionViewLayout).minimumInteritemSpacing = CGFLOAT_MAX;
    [self.photomanageCollectionView setAllowsMultipleSelection:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photoURLArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.style) {
        case Normal:{
            PhotoManageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PhotoManageCollectionViewCell class]) forIndexPath:indexPath];
            
            NSString *filePathURLString = [_photoURLArray objectAtIndex:indexPath.row];
            UIImage* placeholderImage = [UIImage imageNamed:@"img_photo.jpg"];
            
            @autoreleasepool {
                [cell.loadingView startAnimating];
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:filePathURLString] placeholderImage:placeholderImage options:SDWebImageProgressiveDownload | SDWebImageRetryFailed | SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL* imageURL) {
                    
                    if (image != NULL) {
                        NSLog(@"Load image success.");
                        [cell.loadingView stopAnimating];
                    }
                }];
            }
            
            cell.nameLabel.text = [_photoNameArray objectAtIndex:indexPath.row];
            [cell changeCellStyle:NoButton];
            cell.tag = indexPath.row;
            return cell;
        }
        case Deletable:{
            PhotoManageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PhotoManageCollectionViewCell class]) forIndexPath:indexPath];
            
            NSString *filePathURLString = [_photoURLArray objectAtIndex:indexPath.row];
            UIImage* placeholderImage = [UIImage imageNamed:@"img_photo.jpg"];
            
            @autoreleasepool {
                [cell.loadingView startAnimating];
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:filePathURLString] placeholderImage:placeholderImage options:SDWebImageProgressiveDownload | SDWebImageRetryFailed | SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL* imageURL) {
                    
                    if (image != NULL) {
                        NSLog(@"Load image success.");
                        [cell.loadingView stopAnimating];
                    }
                }];
            }
            
            cell.delegate = self;
            cell.nameLabel.text = [_photoNameArray objectAtIndex:indexPath.row];
            [cell.nameLabel setNumberOfLines:0];
            [cell changeCellStyle:HasButton];
            cell.tag = indexPath.row;
            return cell;
        }
        case Scalable:{
            PhotoGalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PhotoGalleryCollectionViewCell class]) forIndexPath:indexPath];
            
            NSString *filePathURLString = [_photoURLArray objectAtIndex:indexPath.row];
            UIImage* placeholderImage = [UIImage imageNamed:@"img_photo.jpg"];
            
            @autoreleasepool {
                [cell.loadingView startAnimating];
                [cell.photoView.imageView sd_setImageWithURL:[NSURL URLWithString:filePathURLString] placeholderImage:placeholderImage options:SDWebImageProgressiveDownload | SDWebImageRetryFailed | SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL* imageURL) {
                    
                    if (image != NULL) {
                        NSLog(@"Load image success.");
                        [cell.loadingView stopAnimating];
                    }
                }];
            }
            
            cell.tag = indexPath.row;
            return cell;
        }
    }
    
    return [[UICollectionViewCell alloc] init];
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionView *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    switch (self.style) {
        case Scalable:
        {
            PhotoGalleryCollectionViewCell *photoGalleryCollectionViewCell = (PhotoGalleryCollectionViewCell*)cell;
            [photoGalleryCollectionViewCell.photoView resetZoom];
            break;
        }
        default:
            break;
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self checkPageChangedByScrollView:scrollView];
}

-(void)checkPageChangedByScrollView:(UIScrollView *)scrollView{
    if(self.photomanageCollectionView.isPagingEnabled){
        NSInteger newPageIndex = (int)scrollView.contentOffset.x / (int)scrollView.frame.size.width;
        [self setCurrentPageIndex:newPageIndex];
    }
}

-(void)setCurrentPageIndex:(NSInteger)newPageIndex{
    if (currentPageIndex != newPageIndex){
        currentPageIndex = newPageIndex;
        if(self.currentPageChangedBlock)
            self.currentPageChangedBlock(currentPageIndex);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.itemSelectedBlock)
        self.itemSelectedBlock(indexPath);
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

-(void)didClickDeleteButtonInItemIndex:(NSInteger)itemIndex{
    if(self.deleteClickBlock)
        self.deleteClickBlock(itemIndex);
}

-(void)didClickEditButtonInItemIndex:(NSInteger)itemIndex{
    if(self.editClickBlock)
        self.editClickBlock(itemIndex);
}

@end
