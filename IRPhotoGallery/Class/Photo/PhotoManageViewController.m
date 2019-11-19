//
//  PhotoManageViewController.m
//  EzmCloud
//
//  Created by Phil on 2018/1/29.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import "PhotoManageViewController.h"
//#import "TGCameraViewController.h"
#import "PhotoManageCollectionViewCell.h"
#import "PhotoManageBrowser.h"
#import "PhotoNoteViewController.h"
#import "TGCameraViewController.h"
#import "InventoryPhotoViewController.h"
//#import "DataDefine.h"

@interface PhotoManageViewController () <TGCameraDelegate, PhotoManageBrowserDelegate, PhotoNoteViewControllerDelegate>{
    NSMutableArray *photoURLArray, *photoNameArray;
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
    
    [self.photoManageBrowser setStyle:Deletable];
    [self.photoManageBrowser setDirection:ScrollDirectionVertical];
    __weak PhotoManageViewController* wSelf = self;
    [self.photoManageBrowser setDeleteClickBlock:^(NSInteger index) {
        [wSelf deleteImageWithImageIndex:index];
    }];
    [self.photoManageBrowser setEditClickBlock:^(NSInteger index) {
        [wSelf editImageName];
    }];
    photoURLArray = [NSMutableArray array];
    photoNameArray = [NSMutableArray array];
//    if(!_currentDevice.imagsArray){
//        [self reloadInfo];
//    }else{
        [self reloadUI];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
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

- (void)deleteImageWithImageIndex:(NSInteger)index{
    [self showLoading:YES];
    //TODO: Delete
    [self reloadInfo];
}

- (void)editImageName {
    PhotoNoteViewController* noteViewController = [[PhotoNoteViewController alloc] init];
//    noteViewController.currentImage = image;
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
        [self->photoURLArray removeAllObjects];
        [self->photoNameArray removeAllObjects];
//        for(ImageClass* photo in self.currentDevice.imagsArray){
//            [self->photoURLArray addObject:photo.downloadURL];
//            [self->photoNameArray addObject:photo.imageDescription];
//        }
        if(self->photoURLArray.count >= 3)
            self.addNewPhotoButton.enabled = NO;
        else
            self.addNewPhotoButton.enabled = YES;
//        [self.photoManageBrowser bindArray:self->photoURLArray];
//        [self.photoManageBrowser bindNameArray:self->photoNameArray];
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
    // set custom tint color
    [TGCameraColor setTintColor: [UIColor whiteColor]];
    
    // save image to album
    //[TGCamera setOption:kTGCameraOptionSaveImageToAlbum value:@YES];
    
    // use the original image aspect instead of square
    //[TGCamera setOption:kTGCameraOptionUseOriginalAspect value:@YES];
    
    // hide switch camera button
    //[TGCamera setOption:kTGCameraOptionHiddenToggleButton value:@YES];
    
    // hide album button
    //[TGCamera setOption:kTGCameraOptionHiddenAlbumButton value:@YES;
    
    // hide filter button
    [TGCamera setOption:kTGCameraOptionHiddenFilterButton value:@YES];
    
    TGCameraNavigationController *cameraViewController = [TGCameraNavigationController newWithCameraDelegate:self];
    [self presentViewController:cameraViewController animated:YES completion:nil];
}

#pragma mark - TGCameraDelegate required

- (void)cameraDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidTakePhoto:(UIImage *)image Note:(NSString *)note
{
//    [self presentPhotoEditPageWithImage:image];
    [self dismiss];
}

- (void)cameraDidSelectAlbumPhoto:(UIImage *)image Note:(NSString *)note
{
//    [self presentPhotoEditPageWithImage:image];
    [self dismiss];
}

- (void)dismiss {
    if(self.navigationController)
//        [self.navigationController popViewControllerAnimated:YES];
//        [(UINavigationController *)self.navigationController.topViewController.presentedViewController popViewControllerAnimated:YES];
        [(UINavigationController *)self.navigationController.topViewController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
    [self reloadInfo];
}

- (void)presentPhotoEditPageWithImage:(UIImage *)image {
//    if(self.navigationController)
//        [self.navigationController popViewControllerAnimated:YES];
//    else
//        [self dismissViewControllerAnimated:YES completion:nil];
//    [self reloadInfo];
    InventoryPhotoViewController *viewController = [InventoryPhotoViewController newWithDelegate:self photo:image];
    [viewController setAlbumPhoto:YES];
    if(self.navigationController)
        [self.navigationController pushViewController:viewController animated:NO];
    else
        [self presentViewController:viewController animated:NO completion:nil];
}

#pragma mark - TGCameraDelegate optional

- (void)cameraWillTakePhoto
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)cameraDidSavePhotoWithError:(NSError *)error
{
    NSLog(@"%s error: %@", __PRETTY_FUNCTION__, error);
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

-(void)didApply {
    [self reloadInfo];
}

@end
