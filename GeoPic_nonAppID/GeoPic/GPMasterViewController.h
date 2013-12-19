//
//  GPMasterViewController.h
//  GeoPic
//
//  Created by 村田 宗一朗 on 2013/12/18.
//  Copyright (c) 2013年 ガイア. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPMasterViewController : UITableViewController <IGRequestDelegate>

@property(nonatomic, strong) NSString* locationId;
- (IBAction)SearchBack:(id)sender;

@end
