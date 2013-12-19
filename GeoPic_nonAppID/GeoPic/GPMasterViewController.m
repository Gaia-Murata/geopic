//
//  GPMasterViewController.m
//  GeoPic
//
//  Created by 村田 宗一朗 on 2013/12/18.
//  Copyright (c) 2013年 ガイア. All rights reserved.
//

#import "GPMasterViewController.h"
#import "GPAppDelegate.h"
#import "GPDetailViewController.h"

@interface GPMasterViewController () {
    NSMutableArray *_objects;
}
@property(nonatomic, strong) NSArray* data;
@end

@implementation GPMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    ///locations/location-id/media/recent
    GPAppDelegate* appDelegate = (GPAppDelegate*)[UIApplication sharedApplication].delegate;
    
    ///locations/location-id/media/recent
    NSString *url = [NSString stringWithFormat:@"/locations/%@/media/recent", _locationId];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:url, @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    NSLog(@"master:%@", _locationId);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d", _data.count);
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = [_data[indexPath.row] objectForKey:@"id"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _data[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

- (IBAction)SearchBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - IGRequestDelegate

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Instagram did fail: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    _data = (NSArray*)[result objectForKey:@"data"];
    NSLog(@"Instagram did load: %@", result);
    if (_data.count > 0) {
        
    } else {
        _objects = (NSMutableArray*)_data;
    }
    
    [self.tableView reloadData];
}

@end
