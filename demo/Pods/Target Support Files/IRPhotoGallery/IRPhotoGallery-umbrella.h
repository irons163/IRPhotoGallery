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
#import "InventoryPhotoViewController.h"
#import "PhotoGalleryCollectionViewCell.h"
#import "PhotoGalleryViewController.h"
#import "PhotoManageBrowser.h"
#import "PhotoManageCollectionViewCell.h"
#import "PhotoManageViewController.h"
#import "PhotoNoteViewController.h"
#import "PhotoScalableView.h"
#import "IRPhotoGallery.h"
#import "UIImage+CameraFilters.h"
#import "TGCameraAuthorizationViewController.h"
#import "TGCameraNavigationController.h"
#import "TGCameraViewController.h"
#import "TGPhotoViewController.h"
#import "TGAlbum.h"
#import "TGAssetsLibrary.h"
#import "TGCamera.h"
#import "TGCameraColor.h"
#import "TGCameraFlash.h"
#import "TGCameraFocus.h"
#import "TGCameraFunctions.h"
#import "TGCameraGrid.h"
#import "TGCameraShot.h"
#import "TGCameraToggle.h"
#import "TGAssetImageFile.h"
#import "TGCameraFilterView.h"
#import "TGCameraFocusView.h"
#import "TGCameraGridView.h"
#import "TGCameraSlideDownView.h"
#import "TGCameraSlideUpView.h"
#import "TGCameraSlideView.h"
#import "TGTintedButton.h"
#import "TGTintedLabel.h"

FOUNDATION_EXPORT double IRPhotoGalleryVersionNumber;
FOUNDATION_EXPORT const unsigned char IRPhotoGalleryVersionString[];

