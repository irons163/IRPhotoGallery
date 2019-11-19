//
//  PhotoGalleryViewController.m
//  EzmCloud
//
//  Created by Phil on 2018/1/26.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import "PhotoGalleryCollectionViewCell.h"
#import "PhotoManageBrowser.h"

@interface PhotoGalleryViewController ()<UICollectionViewDelegateFlowLayout, PhotoManageBrowserDelegate>

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet PhotoManageBrowser *photoManageBrowser;
- (IBAction)cancelButtonClick:(id)sender;

@end

@implementation PhotoGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoManageBrowser.delegate = self;
    [self.photoManageBrowser setStyle:Scalable];
    [self.photoManageBrowser setDirection:ScrollDirectionHorizontal];
    
    __weak PhotoGalleryViewController* wSelf = self;
    [self.photoManageBrowser setCurrentPageChangedBlock:^(NSInteger currentPage) {
        [wSelf.pageControl setCurrentPage:currentPage];
        [wSelf updateDotBorder];
    }];
//    NSMutableArray* photoURLArray = [NSMutableArray array];
//    NSMutableArray* photoNameArray = [NSMutableArray array];
//    for(ImageClass* image in _photoArray){
//        [photoURLArray addObject:image.downloadURL];
//        [photoNameArray addObject:image.description];
//    }
//    [self.photoManageBrowser bindArray:photoURLArray];
//    [self.photoManageBrowser bindNameArray:photoNameArray];
//    [self.photoManageBrowser reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.photoManageBrowser gotoImageIndex:self.imageIndex];
    });
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self updateDotBorder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDotBorder{
//    for (int i = 0; i < self.pageControl.numberOfPages; i++) {
//        UIView* dot = [self.pageControl.subviews objectAtIndex:i];
//        if (i == self.pageControl.currentPage) {
//            dot.layer.borderColor = [UIColor clearColor].CGColor;
//            dot.layer.borderWidth = 1;
//            [dot.layer setNeedsLayout];
//            [dot.layer layoutIfNeeded];
//        } else {
//            dot.layer.borderColor = [UIColor grayColor].CGColor;
//            dot.layer.borderWidth = 1;
//            [dot.layer setNeedsLayout];
//            [dot.layer layoutIfNeeded];
//        }
//    }
}

- (IBAction)cancelButtonClick:(id)sender {
    if (self.presentingViewController && self.presentingViewController.presentedViewController != self.navigationController){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - PhotoManageBrowserDelegate
- (NSUInteger)numberOfPhotos {
    NSUInteger number = [self.delegate numberOfPhotos];
    [self.pageControl setNumberOfPages:number];
    return number;
}

- (NSString*)titleOfPhotoWithIndex:(NSInteger)index {
    return [self.delegate titleOfPhotoWithIndex:index];
}

- (id)imageOrPathStringOfPhotoWithIndex:(NSInteger)index {
    return [self.delegate imageOrPathStringOfPhotoWithIndex:index];
}

@end
