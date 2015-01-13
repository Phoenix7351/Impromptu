//
//  ViewController.m
//  Impromptu
//
//  Created by Justin Tiffner on 1/12/15.
//  Copyright (c) 2015 Justin Tiffner. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userMessage;
@property (weak, nonatomic) IBOutlet UITableView *messageList;
@property (weak, nonatomic) NSMutableArray *messages;
- (IBAction)textEntered:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textEntered:(id)sender {
    //messages
    [_userMessage resignFirstResponder];
    
}
@end
