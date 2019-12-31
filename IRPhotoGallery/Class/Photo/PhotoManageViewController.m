//
//  PhotoManageViewController.m
//  EzmCloud
//
//  Created by Phil on 2018/1/29.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import "PhotoManageViewController.h"
#import "PhotoManageCollectionViewCell.h"
#import "PhotoManageBrowser.h"
#import "PhotoNoteViewController.h"
#import <IRCameraViewController/IRCameraViewController.h>
#import "PhotoEditViewController.h"
#import "PhotoGalleryViewController.h"

@interface PhotoManageViewController () <IRCameraDelegate, PhotoManageBrowserDelegate, PhotoNoteViewControllerDelegate, PhotoEditViewControllerDelegate>{
    __weak IBOutlet UIActivityIndicatorView *loadingIcon;
}

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *addNewPhotoButton;
@property (strong, nonatomic) IBOutlet PhotoManageBrowser *photoManageBrowser;

- (IBAction)cancelButtonClick:(id)sender;
- (IBAction)addNewPhotoButtonClick:(id)sender;
@end

@implementation PhotoManageViewController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoManageBrowser.delegate = self;
    [self.photoManageBrowser setStyle:Deletable];
    [self.photoManageBrowser setDirection:ScrollDirectionVertical];
    __weak PhotoManageViewController* wSelf = self;
    [self.photoManageBrowser setDeleteClickBlock:^(NSInteger index) {
        id object = [wSelf imageOrPathStringOfPhotoWithIndex:index];
        [wSelf deleteImageWithImage:[object isKindOfClass:[UIImage class]] ? object : nil];
    }];
    [self.photoManageBrowser setEditClickBlock:^(NSInteger index) {
        NSString *title = [wSelf titleOfPhotoWithIndex:index];
        id object = [wSelf imageOrPathStringOfPhotoWithIndex:index];
        [wSelf editImageNameWithImage:[object isKindOfClass:[UIImage class]] ? object : nil Note:title];
    }];
    self.itemSelectedBlock = self.itemSelectedBlock;
    [self reloadUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)setItemSelectedBlock:(ItemSelectedBlock)itemSelectedBlock {
    _itemSelectedBlock = itemSelectedBlock;
    __weak PhotoManageViewController* wSelf = self;
    [self.photoManageBrowser setItemSelectedBlock:^(NSIndexPath *indexPath) {
        if (wSelf.itemSelectedBlock) {
            wSelf.itemSelectedBlock(indexPath);
        } else {
            PhotoGalleryViewController* photoGalleryViewController = [[PhotoGalleryViewController alloc] initWithNibName:@"PhotoGalleryViewController" bundle:[NSBundle bundleForClass:wSelf.class]];
            photoGalleryViewController.delegate = wSelf;
            photoGalleryViewController.imageIndex = indexPath.row;
            [wSelf presentViewController:photoGalleryViewController animated:YES completion:nil];
        }
    }];
}

- (void)showLoading:(BOOL)isShow {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isShow) {
            [self->loadingIcon startAnimating];
            self->_addNewPhotoButton.hidden = YES;
            self.view.userInteractionEnabled = NO;
        }else{
            [self->loadingIcon stopAnimating];
            self->_addNewPhotoButton.hidden = NO;
            self.view.userInteractionEnabled = YES;
        }
    });
}

- (void)deleteImageWithImage:(UIImage *)image {
    if (_cameraDelegate && [_cameraDelegate respondsToSelector:@selector(doDeletePhoto:)]) {
        [_cameraDelegate doDeletePhoto:image];
    }
}

- (void)editImageNameWithImage:(UIImage *)image Note:(NSString *)note {
    PhotoNoteViewController* noteViewController = [[PhotoNoteViewController alloc] initWithNibName:@"PhotoNoteViewController" bundle:[NSBundle bundleForClass:self.class]];
    noteViewController.currentImage = image;
    noteViewController.note = note;
    noteViewController.delegate = self;
    [self presentViewController:noteViewController animated:YES completion:nil];
}

- (void)updateImageName:(NSString*)imageName WithImageID:(NSString*)imageID{
//    [[AlertManager sharedInstance] showLoadingViewWithTarget:noteViewController];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{ // TODO: update image name
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadInfo];
        });
    });
}

- (void)uploadImage:(UIImage*)image Description:(NSString*)description {
    [self showLoading:YES];
    //TODO: Save image and note.
}

- (void)reloadUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.photoManageBrowser reloadData];
    });
}

- (void)reloadInfo {
    [self showLoading:YES];
    [self reloadUI];
    [self showLoading:NO];
}

- (IBAction)cancelButtonClick:(id)sender {
    if (self.presentingViewController && self.presentingViewController.presentedViewController != self.navigationController){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)addNewPhotoButtonClick:(id)sender {
    BOOL shouldOpenCamera = YES;
    if (_cameraDelegate && [_cameraDelegate respondsToSelector:@selector(shouldOpenCamera)]) {
        shouldOpenCamera = [_cameraDelegate shouldOpenCamera];
    }
    
    if(!shouldOpenCamera)
        return;
    
    // set custom tint color
//    [IRCameraColor setTintColor: [UIColor whiteColor]];
    
    // save image to album
    //[IRCamera setOption:kIRCameraOptionSaveImageToAlbum value:@YES];
    
    // use the original image aspect instead of square
    //[IRCamera setOption:kIRCameraOptionUseOriginalAspect value:@YES];
    
    // hide switch camera button
    //[IRCamera setOption:kIRCameraOptionHiddenToggleButton value:@YES];
    
    // hide album button
    //[IRCamera setOption:kIRCameraOptionHiddenAlbumButton value:@YES;
    
    // hide filter button
//    [IRCamera setOption:kIRCameraOptionHiddenFilterButton value:@YES];
    
    if (_cameraDelegate && [_cameraDelegate respondsToSelector:@selector(willOpenCamera)]) {
        [_cameraDelegate willOpenCamera];
    }
    
    IRCameraNavigationController *cameraViewController = [IRCameraNavigationController newWithCameraDelegate:self];
    [self presentViewController:cameraViewController animated:YES completion:nil];
}

#pragma mark - IRCameraDelegate required

- (void)cameraDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealWithImage:(UIImage * _Nonnull)image {
//    self.imageView.image = image;
    [self dismiss];
}

- (void)cameraDidTakePhoto:(UIImage *)image
{
    [self dismiss];
    [self presentPhotoEditPageWithImage:image];
    [self reloadInfo];
}

- (void)cameraDidSelectAlbumPhoto:(UIImage *)image
{
    [self dismiss];
    [self presentPhotoEditPageWithImage:image];
    [self reloadInfo];
}

- (void)dismiss {
    if(self.navigationController)
        [(UINavigationController *)self.navigationController dismissViewControllerAnimated:YES completion:nil];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentPhotoEditPageWithImage:(UIImage *)image {
//    if(self.navigationController)
//        [self.navigationController popViewControllerAnimated:YES];
//    else
//        [self dismissViewControllerAnimated:YES completion:nil];
//    [self reloadInfo];
    PhotoEditViewController *viewController = [PhotoEditViewController newWithDelegate:self photo:image];
    
    if(self.navigationController)
        [self.navigationController pushViewController:viewController animated:NO];
    else
        [self presentViewController:viewController animated:NO completion:nil];
}

#pragma mark - IRCameraDelegate optional

- (void)cameraWillTakePhoto
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)cameraDidSavePhotoWithError:(NSError *)error
{
    NSLog(@"%s error: %@", __PRETTY_FUNCTION__, error);
}

#pragma mark - PhotoEditViewControllerDelegate
- (void)didCancel {
    NSLog(@"Did camcel.");
}

- (void)didTakePhoto:(UIImage *)image Note:(NSString *)note {
    NSLog(@"Did take.");
    if (_cameraDelegate && [_cameraDelegate respondsToSelector:@selector(didTakePhoto:Note:)]) {
        [_cameraDelegate didTakePhoto:image Note:note];
    }
}

#pragma mark - PhotoManageBrowserDelegate
- (NSUInteger)numberOfPhotos {
    NSUInteger number = [self.delegate numberOfPhotos];
    return number;
}

- (NSString*)titleOfPhotoWithIndex:(NSInteger)index {
    return [self.delegate titleOfPhotoWithIndex:index];
}

- (id)imageOrPathStringOfPhotoWithIndex:(NSInteger)index {
    return [self.delegate imageOrPathStringOfPhotoWithIndex:index];
}

#pragma mark - PhotoNoteViewControllerDelegate

-(void)shouldApplyImage:(UIImage *)image Note:(NSString *)newNote Completed:(nullable IRCompletionBlock)completedBlock {
    if (_cameraDelegate && [_cameraDelegate respondsToSelector:@selector(doUpdatePhoto:Note:Completed:)]) {
        [_cameraDelegate doUpdatePhoto:image Note:newNote Completed:completedBlock];
    }
}

@end
