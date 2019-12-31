#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CustomCollectionView.h"
#import "PhotoCallback.h"
#import "PhotoEditViewController.h"
#import "PhotoGalleryCollectionViewCell.h"
#import "PhotoGalleryViewController.h"
#import "PhotoManageBrowser.h"
#import "PhotoManageCollectionViewCell.h"
#import "PhotoManageViewController.h"
#import "PhotoNoteViewController.h"
#import "PhotoScalableView.h"
#import "IRPhotoGallery.h"

FOUNDATION_EXPORT double IRPhotoGalleryVersionNumber;
FOUNDATION_EXPORT const unsigned char IRPhotoGalleryVersionString[];

