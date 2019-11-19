//
//  InventoryPhotoViewController.m
//  EnGeniusCloud
//
//  Created by WeiJun on 2019/6/4.
//  Copyright © 2019 EnGenius. All rights reserved.
//

#import "InventoryPhotoViewController.h"
#import "TGAssetsLibrary.h"

@interface InventoryPhotoViewController ()<UITextViewDelegate>
{
    NSString* placeHolder;
    UIColor* placeHolderColor;
    UIEdgeInsets defaultContentInsets;
    UITapGestureRecognizer *tap;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@property (weak) id<TGCameraDelegate> delegate;
@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) NSCache *cachePhoto;
@property (nonatomic) BOOL albumPhoto;

@end

@implementation InventoryPhotoViewController

+ (instancetype)newWithDelegate:(id<TGCameraDelegate>)delegate photo:(UIImage *)photo
{
    InventoryPhotoViewController *viewController = [InventoryPhotoViewController newController];
    
    if (viewController) {
        viewController.delegate = delegate;
        viewController.photo = photo;
        viewController.cachePhoto = [[NSCache alloc] init];
    }
    
    return viewController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    _photoView.clipsToBounds = YES;
    _photoView.image = _photo;
    _noteTextView.contentInset = UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f);
    placeHolder = @"Add some note to this AP";
    placeHolderColor = [UIColor colorWithRed:169.0/255.0 green:169.0/255.0 blue:169.0/255.0 alpha:0.8];
    _noteTextView.text = placeHolder;
    _noteTextView.textColor = placeHolderColor;
    _noteTextView.layer.borderColor = placeHolderColor.CGColor;
    _noteTextView.layer.borderWidth = 1.0;
    _noteTextView.layer.cornerRadius = 9.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - KeyboardNotifications
- (void)registerForKeyboardNotifications
{
    defaultContentInsets = UIEdgeInsetsZero;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    if (tap == nil) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:tap];
    }
}

-(void)dismissKeyboard
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.noteTextView resignFirstResponder];
    });
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (@available(iOS 11.0, *)) {
        kbSize.height = kbSize.height - self.tabBarController.tabBar.frame.size.height;
    }else{
        defaultContentInsets = self.mainScrollView.contentInset;
    }
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.mainScrollView.contentInset = contentInsets;
    self.mainScrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.noteTextView.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.noteTextView.frame.origin.y-kbSize.height);
        [self.mainScrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.mainScrollView.contentInset = defaultContentInsets;
    self.mainScrollView.scrollIndicatorInsets = defaultContentInsets;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = placeHolder;
        textView.textColor = placeHolderColor;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:placeHolder]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}

#pragma mark - Private methods
+ (instancetype)newController
{
    return [[self alloc] initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle bundleForClass:self.class]];
}

#pragma mark - IBAction
- (IBAction)closeButtonClick:(id)sender {
    [self dismissKeyboard];
    if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonClick:(id)sender {
    [self dismissKeyboard];
    
    NSString* note = [self.noteTextView.text isEqualToString:placeHolder] ? @"" : self.noteTextView.text;
    
    if ( [_delegate respondsToSelector:@selector(cameraWillTakePhoto)]) {
        [_delegate cameraWillTakePhoto];
    }
    
    if ([_delegate respondsToSelector:@selector(cameraDidTakePhoto:Note:)]) {
        _photo = _photoView.image;
        
        if (_albumPhoto) {
            [_delegate cameraDidSelectAlbumPhoto:_photo Note:note];
        } else {
            [_delegate cameraDidTakePhoto:_photo Note:note];
        }
        
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        TGAssetsLibrary *library = [TGAssetsLibrary defaultAssetsLibrary];
        
        void (^saveJPGImageAtDocumentDirectory)(UIImage *) = ^(UIImage *photo) {
            [library saveJPGImageAtDocumentDirectory:self.photo resultBlock:^(NSURL *assetURL) {
                if ([self.delegate respondsToSelector:@selector(cameraDidSavePhotoAtPath:)]) {
                    [self.delegate cameraDidSavePhotoAtPath:assetURL];
                }
            } failureBlock:^(NSError *error) {
                if ([self.delegate respondsToSelector:@selector(cameraDidSavePhotoWithError:)]) {
                    [self.delegate cameraDidSavePhotoWithError:error];
                }
            }];
        };
        
        if ([[TGCamera getOption:kTGCameraOptionSaveImageToAlbum] boolValue] && status != ALAuthorizationStatusDenied) {
            [library saveImage:_photo resultBlock:^(NSURL *assetURL) {
                if ([self.delegate respondsToSelector:@selector(cameraDidSavePhotoAtPath:)]) {
                    [self.delegate cameraDidSavePhotoAtPath:assetURL];
                }
            } failureBlock:^(NSError *error) {
                saveJPGImageAtDocumentDirectory(self.photo);
            }];
        } else {
            if ([_delegate respondsToSelector:@selector(cameraDidSavePhotoAtPath:)]) {
                saveJPGImageAtDocumentDirectory(_photo);
            }
        }
    }
}



@end
