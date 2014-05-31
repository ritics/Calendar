//
//  BNMWordsTableViewController.h
//  BNCalView
//
//  Created by Reinis Lācis on 24/04/14.
//  Copyright (c) 2014 Brand Name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNMWordsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *words;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonDone;

@end
