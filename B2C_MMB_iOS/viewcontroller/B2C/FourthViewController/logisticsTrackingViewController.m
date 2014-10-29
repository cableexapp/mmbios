#import "logisticsTrackingViewController.h"
#import "LogisticsTrackingTableViewController.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"

@interface logisticsTrackingViewController ()

@end

@implementation logisticsTrackingViewController

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
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"物流详情"];
    self.navigationItem.titleView = top;
    
    LogisticsTrackingTableViewController *logisticsTrackingTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"logisticsTrackingTableViewController"];
    logisticsTrackingTableViewController.view.frame = self.tableBackView.bounds;
    [self addChildViewController:logisticsTrackingTableViewController];
    [self.tableBackView addSubview:logisticsTrackingTableViewController.view];
    
    _wv = [[UIWebView alloc] initWithFrame:CGRectZero];
    [_wv setDelegate:self];
    
    //    http://m.kuaidi100.com/index_all.html?type="+com+"&postid="+nu
    
    NSString *str = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",self.mylogisticsNum,self.mylogisticsId];
    [_wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
}


- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start");
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error = %@",error.description);
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *pushString = [NSString stringWithFormat:@"id=%@&com=%@&nu=%@&show=%@&muti=%@&order=%@",@"ac0b8f2dcfe149fc",self.mylogisticsNum,self.mylogisticsId,@"0",@"1",@"desc"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@",@"http://api.kuaidi100.com/api?"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLLogisticsTrackingTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(URLTag == URLLogisticsTrackingTag)
    {
        NSLog(@"%@",dicRespon);
    }
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
