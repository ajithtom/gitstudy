//
//  ViewController.h
//  Hooznext
//
//  Created by Ajith on 18/05/2014.
//  Copyright (c) 2014 Ajith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"

#define CacheDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

#define maxWidth [[UIScreen mainScreen] bounds].size.width
#define maxHeight [[UIScreen mainScreen] bounds].size.height
#define screenScale  [[UIScreen mainScreen] scale]

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *teamsArray;
    
    NSMutableArray *timeZonesDicts;
    
    NSArray *blackList;
    
    NSMutableDictionary *timeZone;
    
    UIPickerView *pickerView;
    
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITableView *countryTbl;
@property (weak, nonatomic) IBOutlet UILabel *rateLbl;
@property (weak, nonatomic) IBOutlet UILabel *comSoonLbl;
@property (weak, nonatomic) IBOutlet UIButton *timeZoneBtn;
- (IBAction)facebookClicked:(id)sender;
- (IBAction)twitterClicked:(id)sender;
- (IBAction)instagramClicked:(id)sender;
- (IBAction)ratingClicked:(id)sender;
- (IBAction)timeZoneClicked:(id)sender;
@end
