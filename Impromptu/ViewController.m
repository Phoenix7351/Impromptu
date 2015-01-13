//
//  ViewController.m
//  Impromptu
//
//  Created by Justin Tiffner on 1/12/15.
//  Copyright (c) 2015 Justin Tiffner. All rights reserved.
//

#import "ViewController.h"
#import <CloudKit/CloudKit.h>

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
    
    CKRecord *message = [[CKRecord alloc] initWithRecordType:@"Message"];
    
    CKContainer *container = [CKContainer defaultContainer];
    
    CKDatabase *database = [container publicCloudDatabase];
    
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Message" predicate:[NSPredicate predicateWithFormat:@"TRUEPREDICATE"]];
    
    CKQueryOperation *operation = [[CKQueryOperation alloc] initWithQuery:query];
    operation.recordFetchedBlock = ^(CKRecord *record) {
        NSLog(@"s word");
    };
    
    [database addOperation:operation];
    
    CKRecordZone *rz = [CKRecordZone defaultRecordZone];
    [database performQuery:query inZoneWithID:rz.zoneID completionHandler:^(NSArray *results, NSError *error) {
        NSLog(@"Take a look at who?");
    }];
    
    NSLog(@"Pen is");
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
