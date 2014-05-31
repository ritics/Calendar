//
//  BNMAddNoteViewController.h
//  BNCalView
//
//  Created by Reinis Lācis on 20/04/14.
//  Copyright (c) 2014 Brand Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNMDateNoteItem.h"

@interface BNMAddNoteViewController : UIViewController

//datuma piezīme
@property (strong, nonatomic) BNMDateNoteItem *noteForDate;

// no kalendāra saņemtais datums kuram
// jāievada piezīme
@property (strong, nonatomic) NSDate *dateWithNote;

@property (strong, nonatomic) NSString *dateString;

// A konstrukcija kura nepieciešama navigācijai starp skatiem
//- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonSave;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonCancel;



// vajag uzstādīt virsrakstu  Month DD, YYYY
@property (strong, nonatomic) IBOutlet UITextField *textNote;


@end
