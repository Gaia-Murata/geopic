//
//  GPSearchViewController.m
//  GeoPic
//
//  Created by 村田 宗一朗 on 2013/12/18.
//  Copyright (c) 2013年 ガイア. All rights reserved.
//

#import "GPSearchViewController.h"
#import "GPMasterViewController.h"
#import "GPAppDelegate.h"

@interface GPSearchViewController ()

-(void)geoLocationGetStart:(id)sender;
@property(nonatomic, strong) NSArray* data;
@property(nonatomic, strong) NSString* locationId;
@end

@implementation GPSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _locationId = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.search addTarget:self action:@selector(geoLocationGetStart:)
          forControlEvents:UIControlEventTouchUpInside];
	// Do any additional setup after loading the view.
    GPAppDelegate* appDelegate = (GPAppDelegate*)[UIApplication sharedApplication].delegate;
    
    // here i can set accessToken received on previous login
    //アクセストークン取得
    appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    appDelegate.instagram.sessionDelegate = self;
    

    _search.enabled = [appDelegate.instagram isSessionValid];
    
    
    
    //認証
    if ([appDelegate.instagram isSessionValid]) {
        
    } else {
        [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
    }

}

-(void)geoLocationGetStart:(id)sender
{
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
        NSLog(@"Start updating location.");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - IGSessionDelegate
-(void)igDidLogin {
    NSLog(@"Instagram did login");
    // here i can store accessToken
    GPAppDelegate* appDelegate = (GPAppDelegate*)[UIApplication sharedApplication].delegate;
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.instagram.accessToken forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    _search.enabled = [appDelegate.instagram isSessionValid];
}

-(void)igDidNotLogin:(BOOL)cancelled {
    NSLog(@"Instagram did not login");
    NSString* message = nil;
    if (cancelled) {
        message = @"Access cancelled!";
    } else {
        message = @"Access denied!";
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)igDidLogout {
    NSLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated {
    NSLog(@"Instagram session was invalidated");
}

#pragma mark - Core Location

- (void)logLocation:(CLLocation*)location
{
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSString *lat = [NSString stringWithFormat:@"%.5f", coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%.5f", coordinate.longitude];
    GPAppDelegate* appDelegate = (GPAppDelegate*)[UIApplication sharedApplication].delegate;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"/locations/search", @"method", lat, @"lat", lng, @"lng", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
}

//位置情報取得成功
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [self logLocation:newLocation];
}


//位置情報取得失敗
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - IGRequestDelegate
//APIリクエスト失敗
- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Instagram did fail: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

//APIリクエスト成功
- (void)request:(IGRequest *)request didLoad:(id)result {
    self.data = (NSArray*)[result objectForKey:@"data"];
    if (self.data.count > 0) {
        [locationManager stopUpdatingLocation];
        _locationId = [[self.data objectAtIndex:0] objectForKey:@"id"];
        
        //モーダル
        if (_locationId != nil) {
            //ストーリーボードを取得
            UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //取得したストーリーボードからList画面をインスタンス化（StoryBoardIDでインスタンス化する画面を指定している）
            UINavigationController *navigation = [myStoryboard instantiateViewControllerWithIdentifier:@"GPNavigation"];
            GPMasterViewController *master = navigation.viewControllers[0];
            master.locationId = _locationId;
            //モーダルでナビゲーションを表示
            [self presentViewController:navigation animated:YES completion:nil];
        }
        
    } else {
        //error
    }
    
}


@end
