//
//  PhotoNoteViewController.m
//  EZMCloud
//
//  Created by Phil on 2018/3/30.
//  Copyright © 2018年 EnGenius. All rights reserved.
//

#import "PhotoNoteViewController.h"
//#import "AWSNetworkManager.h"

@interface PhotoNoteViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingicon;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@end

@implementation PhotoNoteViewController{
    NSString* editingText;
    UIEdgeInsets currentContentInsets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noteTextView.text = self.note;
    currentContentInsets = UIEdgeInsetsZero;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.noteTextView.contentInset = currentContentInsets;
    self.noteTextView.scrollIndicatorInsets = currentContentInsets;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KeyboardNotifications
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    currentContentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.noteTextView.contentInset = currentContentInsets;
    self.noteTextView.scrollIndicatorInsets = currentContentInsets;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    currentContentInsets = UIEdgeInsetsZero;
    self.noteTextView.contentInset = currentContentInsets;
    self.noteTextView.scrollIndicatorInsets = currentContentInsets;
}

#pragma mark - IBAction
- (IBAction)clickBackButton:(id)sender {
//    [self.currentImage cleanEditData];
    if([self.delegate respondsToSelector:@selector(willClose)])
        [self.delegate willClose];
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)applyButtonClick:(id)sender {
    [self.noteTextView resignFirstResponder];
    [self.loadingicon startAnimating];
    self.view.userInteractionEnabled = NO;
    [self.delegate shouldApply:editingText];
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if(![self checkRuleForTextField:textView shouldChangeCharactersInRange:range replacementString:text])
        return NO;
    
    NSString *substring = [NSString stringWithString:textView.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:text];
    
    [self checkSaveableByEditingText:substring];
    
    return YES;
}

- (BOOL)checkRuleForTextField:(UITextView *)textView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length + range.location > textView.text.length) {
        return NO;
    }
    
    return YES;
}

-(void)checkSaveableByEditingText:(NSString*)text{
    editingText = text;
    [self checkSaveable];
}


-(void)checkSaveable{
    BOOL isChanged = [self checkSavealbe];
    self.applyButton.enabled = isChanged;
    if(self.applyButton.enabled){
        self.applyButton.alpha = 1.0f;
    }else{
        self.applyButton.alpha = 0.3f;
    }
}

-(BOOL)checkSavealbe{
    BOOL isChanged = false;
    
    if(![self.note isEqualToString:editingText]){
        isChanged = true;
    }
    
    return isChanged;
}

@end

