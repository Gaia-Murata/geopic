//
//  GPDetailViewController.m
//  GeoPic
//
//  Created by 村田 宗一朗 on 2013/12/18.
//  Copyright (c) 2013年 ガイア. All rights reserved.
//

#import "GPDetailViewController.h"

@interface GPDetailViewController ()
- (void)configureView;
@end

@implementation GPDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        NSLog(@"Instagram did load: %@", [[[_detailItem objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"]);
        NSData *dt = [NSData dataWithContentsOfURL:
                      [NSURL URLWithString:
                       [[[_detailItem objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"]]];
        _imageView.image = [[UIImage alloc] initWithData:dt];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
