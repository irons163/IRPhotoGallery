//
//  PhotoEditViewController.m
//  IRPhotoGallery
//
//  Created by Phil on 2019/12/24.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "PhotoEditViewController.h"

@interface PhotoEditViewController ()<UITextViewDelegate>
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

@property (weak) id<PhotoEditViewControllerDelegate> delegate;
@property (strong, nonatomic) UIImage *photo;

@end

@implementation PhotoEditViewController

+ (instancetype)newWithDelegate:(id<PhotoEditViewControllerDelegate>)delegate photo:(UIImage *)photo
{
    PhotoEditViewController *viewController = [PhotoEditViewController newController];
    
    if (viewController) {
        viewController.delegate = delegate;
        viewController.photo = photo;
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
    placeHolder = @"Add some note to this photo";
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
        CGPoint scrollPoint = CGPointMake(0.0, self.noteTextView.frame.origin.y + self.noteTextView.frame.size.height - kbSize.height);
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
- (void)dismiss {
    [self dismissKeyboard];
    if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeButtonClick:(id)sender {
    [self dismiss];
    [_delegate didCancel];
}

- (IBAction)saveButtonClick:(id)sender {
    NSString* note = [self.noteTextView.text isEqualToString:placeHolder] ? @"" : self.noteTextView.text;
    [_delegate didTakePhoto:_photo Note:note];
    [self dismiss];
}

@end
