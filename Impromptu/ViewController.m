//
//  ViewController.m
//  Impromptu
//
//  Created by Justin Tiffner on 1/12/15.
//  Copyright (c) 2015 Justin Tiffner. All rights reserved.
//

#import "ViewController.h"
#import <CloudKit/CloudKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CKDatabase *ckDatabase;

@property (weak, nonatomic) IBOutlet UITextField *userMessage;
@property (weak, nonatomic) IBOutlet UITableView *messageList;
@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UILabel *confirmationMessage;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)textEntered:(id)sender;

@end

@implementation ViewController

NSString * const kMessageRecordType = @"Message";
NSString * const kMessageRecordTextBodyAttribute = @"TextBody";
NSString * const kMessageRecordLocationAttribute = @"Location";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    CKRecord *message = [[CKRecord alloc] initWithRecordType:@"Message"];
//    
//    CKContainer *container = [CKContainer defaultContainer];
//    
//    CKDatabase *database = [container publicCloudDatabase];
//    
//    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Message" predicate:[NSPredicate predicateWithFormat:@"TRUEPREDICATE"]];
//    
//    CKQueryOperation *operation = [[CKQueryOperation alloc] initWithQuery:query];
//    operation.recordFetchedBlock = ^(CKRecord *record) {
//        NSLog(@"s word");
//    };
//    
//    [database addOperation:operation];
//    
//    CKRecordZone *rz = [CKRecordZone defaultRecordZone];
//    [database performQuery:query inZoneWithID:rz.zoneID completionHandler:^(NSArray *results, NSError *error) {
//        NSLog(@"Take a look at who?");
//    }];
//    
//    NSLog(@"Pen is");
    
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Message" predicate:[NSPredicate predicateWithFormat:@"TRUEPREDICATE"]];
    CKRecordZone *rz = [CKRecordZone defaultRecordZone];
    [self.ckDatabase performQuery:query inZoneWithID:rz.zoneID completionHandler:^(NSArray *results, NSError *error) {
        self.messages = [NSMutableArray arrayWithArray:results];
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.messageList reloadData];
        });
    }];
    
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [self.locationManager startUpdatingLocation];
        }
    }    
}

- (IBAction)textEntered:(id)sender {
    //messages
    NSString *messageString = self.userMessage.text;
    
    CKRecord *newMessageRecord = [[CKRecord alloc] initWithRecordType:kMessageRecordType];
    
    newMessageRecord[kMessageRecordTextBodyAttribute] = messageString;
    
    //Use real location!
    //CLLocation *location = [[CLLocation alloc] initWithLatitude:32.00 longitude:-132.456];
    
    newMessageRecord[kMessageRecordLocationAttribute] = self.locationManager.location;
    
    [self.ckDatabase saveRecord:newMessageRecord completionHandler:^(CKRecord *record, NSError *error) {
        if (error == nil) {
            NSLog(@"Message Saved to cloud");
            
                //set and display confirmation message on main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                self.confirmationMessage.text = @"Message Entered";
                [UIView animateWithDuration:1.0 delay:0.0 options:(UIViewAnimationOptionCurveLinear) animations:^(){self.backgroundView.alpha = 1.0; } completion:^(BOOL finished) {
                    [UIView animateWithDuration:1.0 delay:1.0 options:0 animations:^(){ self.backgroundView.alpha = 0.0;} completion:^(BOOL finished) {
                        
                    }];
                    
                }];
                
            });
            
            
        }
    }];
   
    self.userMessage.text = @"";
    
    [_userMessage resignFirstResponder];
    
}

#pragma mark Table Source Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    
    CKRecord *message = [self.messages objectAtIndex:indexPath.row];
    
    cell.textLabel.text = message[kMessageRecordTextBodyAttribute];
    
    return cell;
}

#pragma mark Lazy loaders

- (CKDatabase *)ckDatabase {
    if (_ckDatabase == nil) {
        _ckDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    }
    return _ckDatabase;
}

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.distanceFilter = kCLDistanceFilterNone; 
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

@end
