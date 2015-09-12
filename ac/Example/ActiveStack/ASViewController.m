//
//  ASViewController.m
//  ActiveStack
//
//  Created by Vimbrij on 09/06/2015.
//  Copyright (c) 2015 Vimbrij. All rights reserved.
//

#import "ASViewController.h"

#import <ActiveStack/ActiveStack.h>

@interface ASViewController ()
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@end

@implementation ASViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _welcomeLabel.text = [ActiveStack welcomeMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
