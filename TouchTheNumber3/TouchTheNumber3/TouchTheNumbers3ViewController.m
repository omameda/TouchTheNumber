//
//  TouchTheNumbers3ViewController.m
//  TouchTheNumber3
//
//  Created by seo hideki on 2013/08/18.
//  Copyright (c) 2013年 seo hideki. All rights reserved.
//

#import "TouchTheNumbers3ViewController.h"

@interface TouchTheNumbers3ViewController ()

@end

@implementation TouchTheNumbers3ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
}
- (IBAction)startButton:(id)sender {
    [self performSegueWithIdentifier:@"play"
                              sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}
@end
