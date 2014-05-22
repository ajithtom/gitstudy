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
    
    teamsArray=[[NSMutableArray alloc]init];
    
    NSMutableArray *unsortedList=[[NSMutableArray alloc]initWithContentsOfFile:path];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name"  ascending:YES selector:@selector(caseInsensitiveCompare:)];
    teamsArray=(NSMutableArray *)[unsortedList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    
    
    timeZonesDicts=[[NSMutableArray alloc]init];
    //timeZonesNames = [NSTimeZone knownTimeZoneNames] ;
    
//    NSTimeZone *currentTimeZone =[NSTimeZone timeZoneWithName:[timeZonesNames objectAtIndex:row]];
//    
//    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMT];
//    
//    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
//    
//    NSInteger gmtOffset = [utcTimeZone secondsFromGMT];
//    
//    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    NSArray *availTimeZones = [NSTimeZone knownTimeZoneNames];
    
    NSMutableArray *unsortTimeZones=[[NSMutableArray alloc]init];
    
    
    blackList=[[NSArray alloc]initWithObjects:@"GMT", nil];
    
    for(NSString *eachTimename in availTimeZones)
    {
        if(![blackList containsObject:eachTimename])
        {
            NSTimeZone *currentTimeZone =[NSTimeZone timeZoneWithName:eachTimename];
            
            NSInteger currentGMTOffset = [currentTimeZone secondsFromGMT];
            
            NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
            
            NSInteger gmtOffset = [utcTimeZone secondsFromGMT];
            
            int gmtInterval = currentGMTOffset - gmtOffset;
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithObjects:[NSArray arrayWithObjects:eachTimename,[NSNumber numberWithInt:gmtInterval], nil] forKeys:[NSArray arrayWithObjects:@"tname",@"offset", nil]];
            
            [unsortTimeZones addObject:dict];
        }
        else
        {
            NSLog(@"Skipped one : %@",eachTimename);
            continue;
        }
    }
    
    
    NSSortDescriptor *descriptor2 = [[NSSortDescriptor alloc] initWithKey:@"offset"  ascending:YES];
    timeZonesDicts=(NSMutableArray *)[unsortTimeZones sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor2,nil]];
    
    NSTimeZone *tZone = [NSTimeZone localTimeZone];
    NSString *timeZoneName=[tZone name];
    NSInteger currentGMTOffset = [tZone secondsFromGMT];
    
    
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger gmtOffset = [utcTimeZone secondsFromGMT];
    
    int gmtInterval = currentGMTOffset - gmtOffset;
    
    timeZone=[[NSMutableDictionary alloc]initWithObjects:[NSArray arrayWithObjects:timeZoneName,[NSNumber numberWithInt:gmtInterval], nil] forKeys:[NSArray arrayWithObjects:@"tname",@"offset", nil]];
    
    
    
    NSString *operator;
    
    if(gmtInterval>=0)
        operator=@"+";
    else
    {
        operator=@"-";
        gmtInterval=-1*gmtInterval;
    }
    
    int hours = floor(gmtInterval/(60*60));
    int minutes = round(floor((gmtInterval - hours * 60 * 60)/60));
    
    
    
   [self.timeZoneBtn setTitle:[NSString stringWithFormat:@"%@ %02d:%02d %@",operator,hours,minutes,[timeZone objectForKey:@"tname"]] forState:UIControlStateNormal];
    
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
    
    NSString *localPath=[CacheDirectory stringByAppendingPathComponent:@"screenImage.png"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:localPath])
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController * fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            //[fbSheetOBJ setInitialText:@"Post from my iOS application"];
            //[fbSheetOBJ addURL:[NSURL URLWithString:@"http://www.weblineindia.com"]];
            [fbSheetOBJ addImage:[UIImage imageWithContentsOfFile:localPath]];
            
            [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
        }
    }
    else
    {
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"No Image found to share" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
    
    
}

- (IBAction)twitterClicked:(id)sender {
    
    NSString *localPath=[CacheDirectory stringByAppendingPathComponent:@"screenImage.png"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:localPath])
    {
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
        //[tweetSheet setInitialText:@"Great fun to learn iOS programming at appcoda.com!"];
        [tweetSheet addImage:[UIImage imageWithContentsOfFile:localPath]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"No Image found to share" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
   
}

- (IBAction)instagramClicked:(id)sender {
    NSString *localPath=[CacheDirectory stringByAppendingPathComponent:@"screenImage.png"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:localPath])
    {
        UIImage *image = [UIImage imageWithContentsOfFile:localPath];
        
        NSLog(@"Image : %@",image);
        if ([MGInstagram isAppInstalled])
            [MGInstagram postImage:image withCaption:@"" inView:self.view];
        else
            [self.notInstalledAlert show];
    }
    else
    {
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"No Image found to share" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
    
    
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
        
        
        NSUInteger currentIndex = [timeZonesDicts indexOfObject:timeZone];
        
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
    return timeZonesDicts.count;
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
//    NSTimeZone *currentTimeZone =[NSTimeZone timeZoneWithName:[timeZonesNames objectAtIndex:row]];
//    
//    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMT];
//    
//    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
//    
//    NSInteger gmtOffset = [utcTimeZone secondsFromGMT];
//    
//    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    
    NSDictionary *dict = [timeZonesDicts objectAtIndex:row];
    
    int gmtInterval = [[dict objectForKey:@"offset"] intValue];
    
    NSString *operator;
    
    if(gmtInterval>=0)
        operator=@"+";
    else
    {
        operator=@"-";
        gmtInterval=-1*gmtInterval;
    }
    
    int hours = floor(gmtInterval/(60*60));
    int minutes = round(floor((gmtInterval - hours * 60 * 60)/60));
    
    
    
    NSString *title = [NSString stringWithFormat:@"%@ %02d:%02d %@",operator,hours,minutes,[dict objectForKey:@"tname"]];
    tView.text=title;
    
    return tView;
}


- (void) pickerView:(UIPickerView *)pickerViewcu didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    timeZone=[timeZonesDicts objectAtIndex:row];
    
    int gmtInterval = [[timeZone objectForKey:@"offset"] intValue];
    
    NSString *operator;
    
    if(gmtInterval>=0)
        operator=@"+";
    else
    {
        operator=@"-";
        gmtInterval=-1*gmtInterval;
    }
    
    int hours = floor(gmtInterval/(60*60));
    int minutes = round(floor((gmtInterval - hours * 60 * 60)/60));
    
    
    
    [self.timeZoneBtn setTitle:[NSString stringWithFormat:@"%@ %02d:%02d %@",operator,hours,minutes,[timeZone objectForKey:@"tname"]] forState:UIControlStateNormal];
    
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
    
    NSString *tZoneEdited=[[timeZone objectForKey:@"tname"] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    
    int wid = (int)maxWidth*screenScale;
    int ht = (int)maxHeight*screenScale;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://hooznext.karakasstaging.be//wallpaper/android/%@/%d_%d/%@",[tDict objectForKey:@"tid"],wid,ht,tZoneEdited];
    
    NSLog(@"URL : %@",urlStr);
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText=@"Please wait..";
    
    [self downloadImageWithURL:[NSURL URLWithString:urlStr] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {

        
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            
            [self saveImage:image withFileName:@"screenImage.png" ofType:@"png"];
            
            [HUD hide:YES];
            
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Your image is ready" message:@"Please go to settings and set the image as lock screen wallpaper\nSettings -> Wallpapers & Brightness" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            
//            [alert show];
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Your image is ready" message:@"Image saved to gallery, please set the image as lock screen wallpaper" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
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

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension {
    
    NSLog(@"save image to : %@, extension : %@",imageName,extension) ;
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[CacheDirectory stringByAppendingPathComponent:imageName]  options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[CacheDirectory stringByAppendingPathComponent:imageName] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
    
}


@end
