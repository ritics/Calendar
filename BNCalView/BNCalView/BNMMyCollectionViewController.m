//
//  BNMMyCollectionViewController.m
//  BNCalView
//
//  Created by Reinis Lācis on 17/04/14.
//  Copyright (c) 2014 Brand Name. All rights reserved.
//

#import "BNMMyCollectionViewController.h"
#import "BNMAddNoteViewController.h"
#import "BNMWordsTableViewController.h"
#import "BNMDateNoteItem.h"
#import "BNMReusableView.h"
#import "BNMhelperWords.h"
#import "BNMWordCountItem.h"



static NSString * const MyCellIdentifier = @"MyCell";

@interface BNMMyCollectionViewController ()

/**
 *  path where state is persisted
 */
@property (nonatomic, strong) NSURL *savedDataFilePath;
// pašreizējais kalendāra datums
@property (nonatomic, strong) NSDate *currentDate;
// vārdu atkārtošanās saraksts
@property (nonatomic, strong) NSArray *noteWordsSorted;

@end



@implementation BNMMyCollectionViewController


/**
 *  Aizpilda sākuma pamatdatus
 *
 *  @return <#return value description#>
 */
- (void)loadInitialData {
    
    /*
    // šo metodi sauc pie ielādes un arī pēc mēnēša nomaiņas,
    // tādēļ
    // svarīgi nenojaukt
    */
    
    // datumu masīvus inicializācija
    // šajā masīvā ir tikai aktuālā mēneša datumi
    _datesInView = [[NSMutableArray alloc]init];
    _datesInViewDic = [[NSMutableDictionary alloc]init];
    
    
    if (self.datesWithNotesDic == nil) {
        // Piezīmju masīvu saglabā uz diska.
        // To taisa no jauna tikai ja tas ir nil.
        self.datesWithNotesDic = [[NSMutableDictionary alloc]init];
    }
    
    
    if (self.currentDate == nil) {
        self.currentDate = [NSDate date];
    }

    unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
    // Get necessary date components
    NSDateComponents* currDateComponents = [gregorianCalendar components:unitFlags
                                                                fromDate:self.currentDate];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:[currDateComponents year]];
    [components setMonth:[currDateComponents month]];
    [components setDay:1];
    NSDate *startDate = [gregorianCalendar dateFromComponents:components];
    // mēneša pirmais datums būs tekošais datums
    self.currentDate = startDate;
    
    [components setYear:[currDateComponents year]];
    [components setMonth:[currDateComponents month]+1];
    [components setDay:1];
    NSDate *endDate = [gregorianCalendar dateFromComponents:components];
    
    // unsigned int unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comps = [gregorianCalendar components:NSDayCalendarUnit
                                          fromDate:startDate
                                            toDate:endDate
                                           options:0];
    
    
    // noskaidro ar kurā nedēļas dienā ir mēneša sākums
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:startDate];
    NSInteger weekday = [weekdayComponents weekday];
    // weekday 1 = Sunday for Gregorian calendar
    // add blanks at the start of month
    NSInteger blankCount;
    switch (weekday)
    {
        case 1:
            //svētdiena
            blankCount=6;
            break;
        case 2:
            //pirmdiena
            blankCount=0;
            break;
        case 3:
            //otrtdiena
            blankCount=1;
            break;
        case 4:
            //trešdiena
            blankCount=2;
            break;
        case 5:
            //ceturtdiena
            blankCount=3;
            break;
        case 6:
            //piektdiena
            blankCount=4;
            break;
        case 7:
            //sestdiena
            blankCount=5;
            break;

        default:
            blankCount=0;
            break;
    }
    
    
    // ievieto sākumā blank date cells
    for (int i = 0; i < blankCount; i++)
    {
        // papildmasīvs
        [self.datesInView addObject:[[BNMDateNoteItem alloc] init]];
    }

    
    long days = [comps day];
    
    for (int i = 0; i < days; i++)
    {
        
        [components setYear:[currDateComponents year]];
        [components setMonth:[currDateComponents month]];
        [components setDay:i+1];
        NSDate *nextDate = [gregorianCalendar dateFromComponents:components];
        BNMDateNoteItem *nextItem = [[BNMDateNoteItem alloc] initWithDate:nextDate];
        
        
        // ja datums ir piezīmju sarakstā, tad izmanto jau esošo objektu
        if ([self.datesWithNotesDic objectForKey:nextItem.identifier] != nil) {
            nextItem = [self.datesWithNotesDic objectForKey:nextItem.identifier];
        }
        
        
        [self.datesInViewDic setObject:nextItem
                                forKey:nextItem.identifier];
        // papildmasīvs
        [self.datesInView addObject:nextItem];
    }

}




/**
 *  <#Description#>
 *
 *  @param nibNameOrNil   <#nibNameOrNil description#>
 *  @param nibBundleOrNil <#nibBundleOrNil description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



/**
 *  <#Description#>
 *
 *  @param animated <#animated description#>
 */
-(void)viewWillAppear:(BOOL)animated {

    [self.navigationController setToolbarHidden:NO
                                       animated:YES];
}



/**
 *  returns the URL to the application's Documents directory
 *
 *  @return <#return value description#>
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}



/**
 *  aizpilda sākuma datus
 *
 *  @return <#return value description#>
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // ***********************
    // arhīva fails
    self.savedDataFilePath = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SavedData"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self.savedDataFilePath path]]) {
        // Ir atrasts saglabātais saraksts
        self.datesWithNotesDic = [[NSKeyedUnarchiver unarchiveObjectWithFile:[self.savedDataFilePath path]] mutableCopy];
    }
    // ***********************
    
    [self loadInitialData];
    // pieglabā
    [self save];

    // self.collectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self setCellSize:self.interfaceOrientation];
   
}



/**
 *  saglabā arhīvu
 */
- (void)setCellSize:(UIInterfaceOrientation)interfaceOrientation
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    NSLog(@"w: %f h: %f", screenWidth, screenHeight);
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        // Landscape mode
        self.myLayout.itemSize  = CGSizeMake((screenHeight - 8*2) / 7, (screenWidth - (137+7*2)) / 6 );
        
        //self.myLayout.numberOfColumns = 7;
        //self.myLayout.itemSize  = CGSizeMake(60.0f,  35.0f);
        // handle insets for iPhone 4 or 5
        //CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ? 45.0f : 25.0f;
        //self.myLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
        // self.collectionView.la
        
    } else {
        // Portrait mode
        self.myLayout.itemSize  = CGSizeMake((screenWidth - 8*2) / 7, (screenHeight - (137+7*2)) / 6 );
        //self.myLayout.itemSize  = CGSizeMake(40.0f, 40.0f);
        //self.myLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}



/**
 *  saglabā piezīmes failā
 */
- (void)save
{
    // arhīva fails
    self.savedDataFilePath = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SavedData"];
    
    if ([NSKeyedArchiver archiveRootObject:self.datesWithNotesDic
                                    toFile:[self.savedDataFilePath path]]) {
        // ir izdevies saglabāt
        NSLog(@"Piezīmju saraksts ir saglabāts failā %@", self.savedDataFilePath);

    } else {
        NSLog(@"Kļūda, nav izdevies saglabāt piezīmju sarakstu failā %@", self.savedDataFilePath);
    }
}



/**
 *  <#Description#>
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -
#pragma mark UICollectionViewDataSource
/**
 *  <#Description#>
 *
 *  @param collectionView <#collectionView description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}



/**
 *  Cik dienas ir jārāda kalendārā
 *
 *  @param numberOfItemsInSection:NSInteger <#numberOfItemsInSection:NSInteger description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.datesInView.count;
}




#pragma mark - View Rotation
/**
 *  <#Description#>
 *
 *  @param toInterfaceOrientation <#toInterfaceOrientation description#>
 *  @param duration               <#duration description#>
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [self setCellSize:toInterfaceOrientation];
    
    self.collectionView.autoresizesSubviews = true;
}



/**
 *
 *  Aizpilda rūtiņas saturu
 *
 *  @param collectionView <#collectionView description#>
 *  @param indexPath      <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UIColor *colorWithHueDegrees = [UIColor colorWithHue:(hue/360) saturation:saturation brightness:brightness alpha:1.0];
    //UIColor *cellWithNoteColor = [UIColor colorWithRed:198/255.0f green:235/255.0f blue:242/255.0f alpha:1.0f];
    //UIColor *paleYellowColor = [UIColor colorWithHueDegrees:60 saturation:0.2 brightness:1.0];
    UIColor * cellWithNoteColor = [UIColor colorWithRed:164/255.0f green:206/255.0f blue:249/255.0f alpha:1.0f];
    
    BNMMyCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:MyCellIdentifier
                                              forIndexPath:indexPath];
    
    BNMDateNoteItem *cellItem = [self.datesInView objectAtIndex:[indexPath row]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // kalendārā nevajag 01,02,... vajag 1,2,...
    [dateFormatter setDateFormat:@"d"];
    
    cell.labelView.text = [dateFormatter stringFromDate:cellItem.date];
    cell.date = cellItem.date;
    cell.noteForDate = cellItem;
    
    // Ja datumam ir pievienota piezīme, tad datumu iekrāso citā krāsā
    if (cell.noteForDate.note.length > 0) {
        [collectionView selectItemAtIndexPath:indexPath
                                     animated:FALSE
                               scrollPosition:UICollectionViewScrollPositionNone];
        // Select Cell
        cell.selected = TRUE;
        // highlight selection
        // cell.backgroundColor = [UIColor greenColor];
        // cell.backgroundColor = [UIColor lightBlueColor];
        cell.backgroundColor = cellWithNoteColor;
    }
    else {
        // Set cell to non-highlight
        cell.selected = FALSE;
        // Default color
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}



/**
 *
 *  uzstāda virsrakstam tekstu
 *  implementing the supplementary view protocol methods
 *  @param  <# description#>
 *
 *  @return <#return value description#>
 */
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
          viewForSupplementaryElementOfKind:(NSString *)kind
                                atIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        BNMMySupplementaryView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                    withReuseIdentifier:@"MyHeader"
                                                           forIndexPath:indexPath];
        
        // Uzstāda kalendāra virsrakstu mēnesis, gads.
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        //[dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
        [dateFormatter setDateFormat:@"MMM YYYY"];
        NSString *dateString = [dateFormatter stringFromDate:self.currentDate];
        NSLog(@"%@",dateString);
        header.navigationBar.title = dateString;
        return header;
    }
    else if ([kind isEqual:UICollectionElementKindSectionFooter]) {
        // footer kurā novietota Report poga
        BNMReusableView  *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                    withReuseIdentifier:@"MyFooter"
                                                           forIndexPath:indexPath];
        return footer;

    }
    return nil;
}



/**
 *  pieskaršanās pie Rūtiņas
 *
 *  @param  <# description#>
 *
 *  @return <#return value description#>
 */
-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {}



/**
 *  <#Description#>
 *
 *  @param collectionView <#collectionView description#>
 *  @param indexPath      <#indexPath description#>
 */
-(void)collectionView:(UICollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {}



/**
 *  <#Description#>
 *
 *  @param collectionView <#collectionView description#>
 *  @param indexPath      <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)collectionView:(UICollectionView *)collectionView
shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



/**
 *
 *
 *  @param collectionView <#collectionView description#>
 *  @param indexPath      <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}




#pragma mark - Navigation

/**
 *  In a storyboard-based application, you will often want to do a little preparation before navigation
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // Ja nav nospiesta poga Save, tad jaunu
    // ierakstu neveido.
    //if (sender != self.) return;
    //if (self.textNote.text.length > 0) {
    //    self.noteForDate = [[BNMDateNoteItem alloc] init];
    //    self.noteForDate.note = self.textNote.text;
    //    self.noteForDate.date = self.date;
    //}

    [super prepareForSegue:segue sender:sender];
    
    if([segue.identifier isEqualToString:@"segueFromCalToNote"]) {
        /*
        // Ja starp skatiem nav navigation controller pa vidu
        ViewControllerB *controller = (ViewControllerB *)segue.destinationViewController;
        controller.myBooleanValue = YES;
        */
        // Ja pa vidu starp skatiem ir navigation controller,
        // tad cast uz viewcontroller
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        
        BNMAddNoteViewController *viewAddNote = (BNMAddNoteViewController *)navController.topViewController;
        
        if ([sender isKindOfClass:[BNMMyCollectionViewCell class]]) {
            BNMMyCollectionViewCell *cell = (BNMMyCollectionViewCell *)sender;
            // set something on destination with a value from the cell
            //BNMAddNoteViewController *viewAddNote = (BNMAddNoteViewController *)destination;
            // viewAddNote.dateWithNote = cell.date;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            //[dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            viewAddNote.dateString = [dateFormatter stringFromDate:cell.date];
            // viewAddNote.navigationItem.title = @"test";
            viewAddNote.dateWithNote = cell.date;
            
            // Ja datumam ir pievienota piezīme tad to ir jāuzstāda
            // piezīmju skatam
            viewAddNote.noteForDate = cell.noteForDate;
        }
    }
    else if([segue.identifier isEqualToString:@"segueFromCalToWords"]) {
        // pirms pāriet uz vārdu sarakstu ir jāsarēķina vārdu atkārtošanās
        [self countWords];
        
        /*
         // šādi ja nav navigation controller pa vidu
         ViewControllerB *controller = (ViewControllerB *)segue.destinationViewController;
         controller.myBooleanValue = YES;
         */
        // Ja pa vidu starp skatiem ir navigation controller un šajā gadījumā ir,
        // tad cast uz viewcontroller
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        BNMWordsTableViewController *viewWords = (BNMWordsTableViewController *)navController.topViewController;
        viewWords.words = self.noteWordsSorted;
        
    }
    
}



/**
 *  <#Description#>
 *
 *  @param identifier <#identifier description#>
 *  @param sender     <#sender description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"segueFromCalToNote"]) {
        
        if ([sender isKindOfClass:[BNMMyCollectionViewCell class]]) {
            BNMMyCollectionViewCell *cell = (BNMMyCollectionViewCell *)sender;
            
            if (cell.labelView.text.length > 0) {
                // allow segue
                return YES;
            }
        }

        // Cancel the popover segue
        return NO;
    }
    // Allow all other segues
    return YES;
}



/**
 *  
 A konstrukcija staigāšanai no viena skata uz otru
 šeit nonāk tad kad atgriežās no piezīmes ievadīšanas
 *
 *  @param segue <#segue description#>
 */
- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    
    if ([[segue sourceViewController] isKindOfClass:[BNMAddNoteViewController class]]) {
        
        BNMAddNoteViewController *source = (BNMAddNoteViewController *)[segue sourceViewController];
        BNMDateNoteItem *noteForDate = source.noteForDate;
    
        if (noteForDate != nil)
        {
            // Ir jauna datuma piezīme
            // pievieno piezīmi piezīmju sarakstam
            [self.datesWithNotesDic setObject:noteForDate forKey:noteForDate.identifier];
            //
            [self.collectionView reloadData];
            // saglabā piezīmes, jo ir izmainīts piezīmju saraksts
            [self save];
        }
    }
    
    if ([[segue sourceViewController] isKindOfClass:[BNMWordsTableViewController class]]) {
        
        BNMWordsTableViewController *source = (BNMWordsTableViewController *)[segue sourceViewController];
        NSLog(@"%@", source.title);
    }
}




#pragma mark - Buttons


/**
 *  Nākošais mēnesis
 *
 *  @param sender <#sender description#>
 */
- (IBAction)buttonNext_click:(id)sender {
    NSDate *now = self.currentDate;
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:1];
    NSDate *oneMonthFromNow = [calendar dateByAddingComponents:components
                                                        toDate:now
                                                       options:0];
    NSLog(@"%@", oneMonthFromNow);
    
    self.currentDate =oneMonthFromNow;
    // atjauno datus uz ekrāna
    [self loadInitialData];
    
    // some trick found on inet to reload view dta
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView.collectionViewLayout invalidateLayout];
    });
}




/**
 *  Iepriekšējais mēnesis
 *
 *  @param sender <#sender description#>
 */
- (IBAction)buttonPrev_click:(id)sender {
    
    NSDate *now = self.currentDate;
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:-1];
    NSDate *oneMonthFromNow = [calendar dateByAddingComponents:components
                                                        toDate:now
                                                       options:0];
    NSLog(@"%@", oneMonthFromNow);
    
    self.currentDate =oneMonthFromNow;
    // atjauno datus uz ekrāna
    [self loadInitialData];
    
    // some trick found on inet to reload view dta
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView.collectionViewLayout invalidateLayout];
    });
}



/**
 *  <#Description#>
 *
 *  @param sender <#sender description#>
 */
- (IBAction)buttonCount_click:(id)sender {
    [self countWords];
}




# pragma mark - helpers



/**
 *  Saskaita vārdus piezīmēs
 */
-(void) countWords {
    
    if (self.datesWithNotesDic == nil) {return;}
    
    self.noteWordsSorted = [BNMhelperWords countWords:self.datesWithNotesDic];
    
    BNMWordCountItem *item;
    for(item in self.noteWordsSorted) {
        NSLog(@"%@ - %d", item.word, (int)item.count);
    }
}


@end
