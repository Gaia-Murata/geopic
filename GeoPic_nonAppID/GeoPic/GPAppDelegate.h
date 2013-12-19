//
//  GPAppDelegate.h
//  GeoPic
//
//  Created by 村田 宗一朗 on 2013/12/18.
//  Copyright (c) 2013年 ガイア. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Instagram.h"

@interface GPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) Instagram *instagram;

@end
