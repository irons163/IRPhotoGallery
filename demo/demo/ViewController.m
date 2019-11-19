//
//  ViewController.m
//  demo
//
//  Created by Phil on 2019/7/31.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "ViewController.h"
#import "PhotoManageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)demoButtonClick:(id)sender {
//    NSURL *bundleURL = [[NSBundle bundleForClass:[PhotoManageViewController class]] URLForResource:@"IRPhotoGallery" withExtension:@"bundle"];
//    NSBundle *bundle = bundle = [NSBundle bundleWithURL:bundleURL];
    NSBundle *bundle = [NSBundle bundleForClass:[PhotoManageViewController class]];
    PhotoManageViewController* photoManageViewController = [[PhotoManageViewController alloc] initWithNibName:@"PhotoManageViewController" bundle:bundle];
//    photoManageViewController.currentDevice = device;
    [self.navigationController pushViewController:photoManageViewController animated:YES];
}

@end
