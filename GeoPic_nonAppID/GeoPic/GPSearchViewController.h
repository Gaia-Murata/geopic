//
//  GPSearchViewController.h
//  GeoPic
//
//  Created by 村田 宗一朗 on 2013/12/18.
//  Copyright (c) 2013年 ガイア. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GPSearchViewController : UIViewController  <IGSessionDelegate, IGRequestDelegate, CLLocationManagerDelegate>
{
    CLLocationManager* locationManager;
}

@property (weak, nonatomic) IBOutlet UIButton *search;


@end
