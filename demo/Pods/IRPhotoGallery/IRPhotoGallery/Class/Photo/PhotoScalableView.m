//
//  PhotoScalableView.m
//  EzmCloud
//
//  Created by Phil on 2018/1/26.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import "PhotoScalableView.h"

@interface PhotoScalableView()<UIScrollViewDelegate>

@end

@implementation PhotoScalableView{
    BOOL isZoomed;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setup];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setup];
    }
    
    return self;
}

-(void)setup{
    self.delegate = self;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.translatesAutoresizingMaskIntoConstraints = false;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:self.imageView];
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint * bottomConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint * centerXConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint * centerYConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    topConstraint.active = YES;
    bottomConstraint.active = YES;
    leadingConstraint.active = YES;
    trailingConstraint.active = YES;
    centerXConstraint.active = YES;
    centerYConstraint.active = YES;
    
    self.minimumZoomScale = 1.0;
    self.maximumZoomScale = 3.0;
//    self.scrollEnabled = NO;
    
//    [self.imageView setNeedsLayout];
//    [self.imageView layoutIfNeeded];
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
}

- (void)resetZoom
{
    isZoomed = NO;
    [self setZoomScale:self.minimumZoomScale animated:NO];
    [self zoomToRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height ) animated:NO];
    self.contentSize = CGSizeMake(self.frame.size.width * self.zoomScale, self.frame.size.height * self.zoomScale );
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    if (touch.tapCount == 2) {
        
        if( isZoomed )
        {
            isZoomed = NO;
            [self setZoomScale:self.minimumZoomScale animated:YES];
        }
        else {
            
            isZoomed = YES;
            
            // define a rect to zoom to.
            CGPoint touchCenter = [touch locationInView:self];
            CGSize zoomRectSize = CGSizeMake(self.frame.size.width / self.maximumZoomScale, self.frame.size.height / self.maximumZoomScale );
            CGRect zoomRect = CGRectMake( touchCenter.x - zoomRectSize.width * .5, touchCenter.y - zoomRectSize.height * .5, zoomRectSize.width, zoomRectSize.height );
            
            // correct too far left
            if( zoomRect.origin.x < 0 )
                zoomRect = CGRectMake(0, zoomRect.origin.y, zoomRect.size.width, zoomRect.size.height );
            
            // correct too far up
            if( zoomRect.origin.y < 0 )
                zoomRect = CGRectMake(zoomRect.origin.x, 0, zoomRect.size.width, zoomRect.size.height );
            
            // correct too far right
            if( zoomRect.origin.x + zoomRect.size.width > self.frame.size.width )
                zoomRect = CGRectMake(self.frame.size.width - zoomRect.size.width, zoomRect.origin.y, zoomRect.size.width, zoomRect.size.height );
            
            // correct too far down
            if( zoomRect.origin.y + zoomRect.size.height > self.frame.size.height )
                zoomRect = CGRectMake( zoomRect.origin.x, self.frame.size.height - zoomRect.size.height, zoomRect.size.width, zoomRect.size.height );
            
            // zoom to it.
            [self zoomToRect:zoomRect animated:YES];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if( self.zoomScale == self.minimumZoomScale ) isZoomed = NO;
    else isZoomed = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
