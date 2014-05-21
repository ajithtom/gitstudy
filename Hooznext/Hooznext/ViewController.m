//
//  ViewController.m
//  Hooznext
//
//  Created by Ajith on 18/05/2014.
//  Copyright (c) 2014 Ajith. All rights reserved.
//

#import "ViewController.h"

#import "MGInstagram.h"

#import <Social/Social.h>

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    self.rateLbl.font=[UIFont fontWithName:@"BlaxSlabXXL" size:22];
    self.comSoonLbl.font=[UIFont fontWithName:@"BlaxSlabXXL" size:22];
    self.timeZoneBtn.titleLabel.font=[UIFont fontWithName:@"BlaxSlabXXL" size:22];
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"teamsList" ofType:@"plist"];
    
    teamsArray=[[NSMutableArray alloc]initWithContentsOfFile:path];
    
    timeZonesNames = [NSTimeZone knownTimeZoneNames] ;
    
    
    NSTimeZone *tZone = [NSTimeZone localTimeZone];
    timeZone=[tZone name];
    NSInteger currentGMTOffset = [tZone secondsFromGMT];
    
    NSString *operator;
    
    if(currentGMTOffset>=0)
        operator=@"+";
    else
    {
        operator=@"-";
        currentGMTOffset=-1*currentGMTOffset;
    }
    
    int hours = floor(currentGMTOffset/(60*60));
    int minutes = round(floor((currentGMTOffset - hours * 60 * 60)/60));
    
    [self.timeZoneBtn setTitle:[NSString stringWithFormat:@"%@ GMT %@ %02d:%02d",timeZone,operator,hours,minutes] forState:UIControlStateNormal];
    
    self.timeZoneBtn.titleLabel.minimumScaleFactor=0.2f;
    self.timeZoneBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    
    
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget : self action : @selector (handleSingleTap:)];
    singleTap.numberOfTapsRequired=1;
    singleTap.delegate=self;
    
    [self.view addGestureRecognizer:singleTap];
    
    //NSLog(@"time zone : %@",timeZonesNames);
    
    
    
    //NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    
//    NSTimeZone *currentTimeZone =[NSTimeZone timeZoneWithName:@"Asia/Kolkata"];
//    
//    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:[NSDate date]];
//    
//    NSLog(@"OOOOO : %ld",(long)currentGMTOffset);
    
    
    [self.countryTbl reloadData];
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (IBAction)facebookClicked:(id)sender {
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result) {
        switch (result)
        {
            case SLComposeViewControllerResultCancelled:
                //NSLog(@"Twitter Result: canceled");
                break;
            case SLComposeViewControllerResultDone:
                //NSLog(@"Twitter Result: sent");
                break;
            default:
                //NSLog(@"Twitter Result: default");
                break;
        }
        
        [self dismissViewControllerAnimated:YES completion:^{}];
    };

    [tweetSheet setInitialText:@"Great fun to learn iOS programming at appcoda.com!"];
    [tweetSheet addImage:[UIImage imageNamed:@"toshare"]];
    [self presentViewController:tweetSheet animated:YES completion:nil];
}

- (IBAction)twitterClicked:(id)sender {
    
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
    SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
        switch (result)
        {
            case SLComposeViewControllerResultCancelled:
                //NSLog(@"Twitter Result: canceled");
                break;
            case SLComposeViewControllerResultDone:
                //NSLog(@"Twitter Result: sent");
                break;
            default:
                //NSLog(@"Twitter Result: default");
                break;
        }
        
        [self dismissViewControllerAnimated:YES completion:^{}];
    };
    [tweetSheet setInitialText:@"Great fun to learn iOS programming at appcoda.com!"];
    [tweetSheet addImage:[UIImage imageNamed:@"toshare"]];
    [self presentViewController:tweetSheet animated:YES completion:nil];
}

- (IBAction)instagramClicked:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"toshare"];
    if ([MGInstagram isAppInstalled])
        [MGInstagram postImage:image withCaption:@"Manifest your every desire using “MindCloud”, that masterminds the world’s dreams in the palm of your hand!!" inView:self.view];
    else
        [self.notInstalledAlert show];
}

- (UIAlertView*) notInstalledAlert
{
    return [[UIAlertView alloc] initWithTitle:@"Instagram Not Installed!" message:@"Instagram must be installed on the device in order to post images" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
}

- (IBAction)ratingClicked:(id)sender {
}

- (IBAction)timeZoneClicked:(id)sender {
    if(!pickerView)
    {
        CGRect pickerFrame = CGRectMake(0, self.timeZoneBtn.frame.origin.y+self.timeZoneBtn.frame.size.height, 0, 0);
        pickerView = [[UIPickerView alloc]initWithFrame:pickerFrame];
        pickerView.showsSelectionIndicator = YES;
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.backgroundColor=[UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:0.5f];
        
        
        NSUInteger currentIndex = [timeZonesNames indexOfObject:timeZone];
        
        [pickerView selectRow:currentIndex inComponent:0 animated:NO];
        
        [self.view addSubview:pickerView];
        
        
        
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.countryTbl]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        
        if(pickerView)
            return YES;
        else
            return NO;
    }
    
    return YES;
}

- (void) handleSingleTap : (UIGestureRecognizer*) sender
{
    if(pickerView)
    {
        [pickerView removeFromSuperview];
        pickerView=nil;

    }
}



#pragma mark - PickerView data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerViewcu numberOfRowsInComponent:(NSInteger)component

{
    //NSLog(@"returned count : %d",shpList.count);
    return timeZonesNames.count;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        //[tView setFont:[UIFont fontWithName:@"BlaxSlabXXL" size:22]];
        [tView setFont:[UIFont systemFontOfSize:18]];
        [tView setTextAlignment:NSTextAlignmentCenter];
        tView.numberOfLines=1;
        tView.textColor=[UIColor whiteColor];
        tView.minimumScaleFactor=0.2f;
        tView.adjustsFontSizeToFitWidth=YES;
    }
    // Fill the label text here
    NSTimeZone *currentTimeZone =[NSTimeZone timeZoneWithName:[timeZonesNames objectAtIndex:row]];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMT];
    
    NSString *operator;
    
    if(currentGMTOffset>=0)
        operator=@"+";
    else
    {
        operator=@"-";
        currentGMTOffset=-1*currentGMTOffset;
    }
    
    int hours = floor(currentGMTOffset/(60*60));
    int minutes = round(floor((currentGMTOffset - hours * 60 * 60)/60));
    
    
    
    NSString *title = [NSString stringWithFormat:@"%@ GMT %@ %02d:%02d",[timeZonesNames objectAtIndex:row],operator,hours,minutes];
    tView.text=title;
    
    return tView;
}


- (void) pickerView:(UIPickerView *)pickerViewcu didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    timeZone=[timeZonesNames objectAtIndex:row];
    
    NSTimeZone *currentTimeZone =[NSTimeZone timeZoneWithName:timeZone];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMT];
    
    NSString *operator;
    
    if(currentGMTOffset>=0)
        operator=@"+";
    else
    {
        operator=@"-";
        currentGMTOffset=-1*currentGMTOffset;
    }
    int hours = floor(currentGMTOffset/(60*60));
    int minutes = round(floor((currentGMTOffset - hours * 60 * 60)/60));
    
    
    
    [self.timeZoneBtn setTitle:[NSString stringWithFormat:@"%@ GMT %@ %02d:%02d",timeZone,operator,hours,minutes] forState:UIControlStateNormal];
    
    [pickerView removeFromSuperview];
    pickerView=nil;

    
    
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return teamsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.selectionStyle=UITableViewCellEditingStyleNone;
        UIImageView *selImgView=[[UIImageView alloc]init];
        selImgView.image=[UIImage imageNamed:@"selectedCell"];
        cell.selectedBackgroundView=selImgView;
        UIView *bkView=[[UIView alloc]init];
        bkView.backgroundColor=[UIColor clearColor];
        cell.backgroundView=bkView;
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.font=[UIFont fontWithName:@"BlaxSlabXXL" size:25];
        cell.textLabel.textColor=[UIColor whiteColor];
    }
    
    NSDictionary *tDict=[teamsArray objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text=[tDict objectForKey:@"name"];
    
    
    
   
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    [self.countryTbl scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    //http://hooznext.karakasstaging.be//wallpaper/android/1/small/Asia-Kolkata
    
    
    NSDictionary *tDict=[teamsArray objectAtIndex:indexPath.row];
    
    NSString *tZoneEdited=[timeZone stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://hooznext.karakasstaging.be//wallpaper/android/%@/small/%@",[tDict objectForKey:@"tid"],tZoneEdited];
    
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText=@"Please wait..";
    
    [self downloadImageWithURL:[NSURL URLWithString:urlStr] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {

            
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            
            
            [HUD hide:YES];
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Your image is ready" message:@"Please go to settings and set the image as lock screen wallpaper\nSettings -> Wallpapers & Brightness" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alert show];
           
            // cache the image for use later (when scrolling up)
            //venue.image = image;
        }
    }];
    
    
}



- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image=[[UIImage alloc] initWithData:data];
                                   
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}


@end
