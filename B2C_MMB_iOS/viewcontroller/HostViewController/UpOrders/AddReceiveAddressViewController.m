//
//  AddReceiveAddressViewController.m
//  B2C_MMB_iOS
//
//  Created by App01 on 14-9-24.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import "AddReceiveAddressViewController.h"
#import "DCFCustomExtra.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"

@interface AddReceiveAddressViewController ()

@end

@implementation AddReceiveAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor redColor]];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"新增收货地址"];
    self.navigationItem.titleView = top;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    if(!documentDirectory)
    {
        //        NSLog(@"Not Found!");
        return;
    }
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDB.db"];
    
    self.db = [[FMDatabase alloc] initWithPath:dbPath];
    [self.db setLogsErrors:YES];
    [self.db setTraceExecution:YES];
    [self.db setCrashOnErrors:YES];
    [self.db setShouldCacheStatements:YES];
    
    [self.db open];
    [self openDatabase];

    
    // Do any additional setup after loading the view.
}

- (void) openDatabase
{
    if(![self.db open])
    {
        return;
    }
    [self.db beginTransaction];
    
    //用户集合
    if(![self.db tableExists:@"UserIdCollection"])
    {
        [self.db executeQuery:@"CREATE TABLE UserIdCollection (Name text,UserId text)"];
    }
    
    //主页用户查询商品集合
    if(![self.db tableExists:@"HostCabelCollection"])
    {
        [self.db executeQuery:@"CREATE TABLE HostCabelCollection (SearchCabelName text,UserId text)"];
    }
    [self.db commit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
