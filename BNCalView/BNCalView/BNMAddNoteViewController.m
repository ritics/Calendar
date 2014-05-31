//
//  BNMAddNoteViewController.m
//  BNCalView
//
//  Created by Reinis Lācis on 20/04/14.
//  Copyright (c) 2014 Brand Name. All rights reserved.
//

#import "BNMAddNoteViewController.h"

@interface BNMAddNoteViewController ()


@end



@implementation BNMAddNoteViewController





/**
 *  Šī ir kaut kāda A konstrukcija kura atagādina konstruktoru
 *
 *  @param nibNameOrNil   <#nibNameOrNil description#>
 *  @param nibBundleOrNil <#nibBundleOrNil description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


/**
 *  Te viss vienkārši var sakārtot to ko grib parādīt
 *
 *  @return <#return value description#>
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy"];

    // no kalendāra skata ir jābūt uzstādītam dienas datumam par kuru
    // tiek veikta piezīme
    self.navigationItem.title = [formatter stringFromDate:self.dateWithNote];
    
    // ja ir uzstādīta datuma piezīme tad to parāda
    // uz ekrāna
    if (self.noteForDate != nil) {
        self.textNote.text = self.noteForDate.note;
    }
 
}


/**
 * 
 *
 *  @return <#return value description#>
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation


/**
 *  Navigācija!!!!
 In a storyboard-based application, 
 you will often want to do a little preparation before navigation
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Ja nav nospiesta poga Save, tad jaunu
    // piezīmi neveido.
    if (sender != self.buttonSave) return;
    
    if (self.noteForDate != nil) {
        self.noteForDate.note = self.textNote.text;
        
    } else {
        if (self.textNote.text.length > 0) {
            self.noteForDate = [[BNMDateNoteItem alloc]
                            initWithNote:self.textNote.text
                                    date:self.dateWithNote];
        }
    }
}


@end
