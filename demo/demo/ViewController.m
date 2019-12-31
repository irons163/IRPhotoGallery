//
//  ViewController.m
//  demo
//
//  Created by Phil on 2019/7/31.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "ViewController.h"
#import "Photo+CoreDataClass.h"
#import "AppDelegate.h"
#import <IRPhotoGallery/IRPhotoGallery.h>
//#import <CoreData/CoreData.h>


@interface ViewController ()<PhotoManageBrowserDelegate, CameraViewControllerDelegate>

@end

@implementation ViewController {
    NSManagedObjectContext *context;
    NSArray<Photo *> *photos;
    NSArray<UIImage *> *images;
    PhotoManageViewController* photoManageViewController;
    PhotoManageBrowser *photoManageBrowser;
}

- (void)reloadPhotos {
    photos = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"Photo"] error:nil];
    NSMutableArray<UIImage *> *photoImages = [NSMutableArray array];
    for (Photo *photo in photos) {
        UIImage *image = [UIImage imageWithData:photo.photo];
        [photoImages addObject:image];
    }
    images = [NSArray arrayWithArray:photoImages];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    [self reloadPhotos];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (photoManageBrowser)
        [photoManageBrowser reloadData];
}

- (IBAction)demoButtonClick:(id)sender {
//    NSURL *bundleURL = [[NSBundle bundleForClass:[PhotoManageViewController class]] URLForResource:@"IRPhotoGallery" withExtension:@"bundle"];
//    NSBundle *bundle = bundle = [NSBundle bundleWithURL:bundleURL];
    NSBundle *bundle = [NSBundle bundleForClass:[PhotoManageViewController class]];
    photoManageViewController = [[PhotoManageViewController alloc] initWithNibName:@"PhotoManageViewController" bundle:bundle];
    photoManageViewController.delegate = self;
    photoManageViewController.cameraDelegate = self;
//    photoManageViewController.currentDevice = device;
    [IRCameraColor setTintColor: [UIColor whiteColor]];
    
    [self.navigationController pushViewController:photoManageViewController animated:YES];
}

- (IBAction)demo2ButtonClick:(id)sender {
    if (!photoManageBrowser) {
        photoManageBrowser = [[PhotoManageBrowser alloc] init];
        [photoManageBrowser setStyle:Normal];
        [photoManageBrowser setDirection:ScrollDirectionHorizontal];
        __weak ViewController* wSelf = self;
        [photoManageBrowser setItemSelectedBlock:^(NSIndexPath *indexPath) {
            NSBundle *bundle = [NSBundle bundleForClass:[PhotoGalleryViewController class]];
            PhotoGalleryViewController* photoGalleryViewController = [[PhotoGalleryViewController alloc] initWithNibName:@"PhotoGalleryViewController" bundle:bundle];
            photoGalleryViewController.delegate = wSelf;
            photoGalleryViewController.imageIndex = indexPath.row;
            [wSelf presentViewController:photoGalleryViewController animated:YES completion:nil];
        }];
        photoManageBrowser.delegate = self;
        [self.view addSubview:photoManageBrowser];
        
        [photoManageBrowser.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:1.0].active = YES;
        [photoManageBrowser.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.3].active = YES;
        [photoManageBrowser.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
        photoManageBrowser.translatesAutoresizingMaskIntoConstraints = NO;
    } else {
        [photoManageBrowser reloadData];
    }
}

#pragma mark - PhotoManageBrowserDelegate
- (NSUInteger)numberOfPhotos {
    return photos.count;
}

- (NSString *)titleOfPhotoWithIndex:(NSInteger)index {
    return [photos objectAtIndex:index].note;
}

- (id)imageOrPathStringOfPhotoWithIndex:(NSInteger)index {
    
    return [images objectAtIndex:index];
}

#pragma mark - CameraViewControllerDelegate
- (void)didTakePhoto:(UIImage *)image Note:(NSString *)note {
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
    photo.photo = UIImagePNGRepresentation(image);
    photo.note = note;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    [self reloadPhotos];
    [photoManageViewController reloadUI];
}

- (void)doUpdatePhoto:(UIImage *)image Note:(NSString *)note Completed:(nullable IRCompletionBlock)completedBlock {
    [photoManageViewController showLoading:YES];
    NSInteger index = [images indexOfObject:image];
    Photo *photo = [photos objectAtIndex:index];
    photo.photo = UIImagePNGRepresentation(image);
    photo.note = note;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    if (completedBlock) {
        completedBlock(YES);
    }
    [photoManageViewController reloadUI];
    [photoManageViewController showLoading:NO];
}

- (void)doDeletePhoto:(UIImage *)image {
    NSInteger index = [images indexOfObject:image];
    Photo *photo = [photos objectAtIndex:index];
    [context deleteObject:photo];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    [self reloadPhotos];
    [photoManageViewController reloadUI];
}

@end
