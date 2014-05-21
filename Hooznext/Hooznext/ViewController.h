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

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *teamsArray;
    
    NSArray *timeZonesNames;
    
    NSString *timeZone;
    
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
