//
//  ViewController.h
//  AfterSquare
//
//  Created by Cheshire on 04.08.15.
//  Copyright (c) 2015 Cheshire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *placeTableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

