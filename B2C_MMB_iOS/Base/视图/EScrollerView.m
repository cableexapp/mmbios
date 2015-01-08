//
//  EScrollerView.m
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import "EScrollerView.h"
#import "UIImageView+WebCache.h"

@implementation EScrollerView
@synthesize delegate;

- (void)dealloc {
	[scrollView release];
    [noteTitle release];
	delegate=nil;
    if (pageControl) {
        [pageControl release];
    }
    if (imageArray) {
        [imageArray release];
        imageArray=nil;
    }
    if (titleArray) {
        [titleArray release];
        titleArray=nil;
    }
    [super dealloc];
}

-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr WithTag:(int)tag
{
    
	if ((self=[super initWithFrame:rect]))
    {
        self.userInteractionEnabled=YES;
        titleArray=[titArr retain];
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:imgArr];
        [tempArray insertObject:[imgArr objectAtIndex:([imgArr count]-1)] atIndex:0];
        [tempArray addObject:[imgArr objectAtIndex:0]];
		imageArray=[[NSArray arrayWithArray:tempArray] retain];
		viewSize=rect;
        NSUInteger pageCount=[imageArray count];
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        for (int i=0; i<pageCount; i++)
        {
            NSString *imgURL=[imageArray objectAtIndex:i];
            UIImageView *imgView=[[[UIImageView alloc] init] autorelease];
            if ([imgURL hasPrefix:@"http://"])
            {
                //网络图片 请使用ego异步图片库
                [imgView setImageWithURL:[NSURL URLWithString:imgURL]placeholderImage:[UIImage imageNamed:@"cabel.png"]];
            }
            else
            {
                
                UIImage *img=[UIImage imageNamed:[imageArray objectAtIndex:i]];
                [imgView setImage:img];
            }
            
//            [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
            myTag = tag;
            if(myTag == 0)
            {
                [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
            }
            if(myTag == 1)
            {
                [imgView setFrame:CGRectMake(85+(150+170)*i, 10,150, 140)];
                
            }
            imgView.tag=i;
            UITapGestureRecognizer *Tap =[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)] autorelease];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
            [scrollView addSubview:imgView];
        }
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        [self addSubview:scrollView];

        
        
        //说明文字层
        UIView *noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-33,self.bounds.size.width,33)];
//        [noteView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];
        [noteView setBackgroundColor:[UIColor clearColor]];
        
        float pageControlWidth=(pageCount-2)*10.0f+40.f;
        float pagecontrolHeight=20.0f;
        if(myTag == 0)
        {
            pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(self.frame.size.width-pageControlWidth-10,18, pageControlWidth, pagecontrolHeight)];
//            pageControl.hidden = YES;
        }
        else
        {
            pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth)/2,21, pageControlWidth, pagecontrolHeight)];
        }
        
        pageControl.currentPage=0;
        pageControl.numberOfPages=(pageCount-2);
        pageControl.pageIndicatorTintColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:19/255.0 green:90/255.0 blue:168/255.0 alpha:1.0];
        [noteView addSubview:pageControl];
        
        noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 6, self.frame.size.width-pageControlWidth-15, 20)];
        [noteTitle setText:[titleArray objectAtIndex:0]];
        [noteTitle setBackgroundColor:[UIColor clearColor]];
        [noteTitle setFont:[UIFont systemFontOfSize:13]];
        [noteView addSubview:noteTitle];
        
        [self addSubview:noteView];
        [noteView release];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopNotice:) name:@"stopNsTimer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startNotice:) name:@"startNsTimer" object:nil];

	}
	return self;
}

- (void) stopNotice:(NSNotification *) noti
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void) startNotice:(NSNotification *) noti
{
    if(!timer)
    {
        [self loadTimer];
    }
}
- (void) loadTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    [timer fire];
    
    num = 0;
}

- (void) timer:(NSTimer *) sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    int currentPage = page;
    
    if(num == 0)
    {
        
    }
    else
    {
        if (currentPage ==0) {
            
            [scrollView setContentOffset:CGPointMake(([imageArray count]-2)*viewSize.size.width, 0)];
        }
        if (currentPage ==([imageArray count]-1)) {
            
            [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0) animated:YES];
        }
        if(currentPage == 1)
        {
            [scrollView setContentOffset:CGPointMake(viewSize.size.width*2, 0) animated:YES];
        }
        if(currentPage == 2)
        {
            [scrollView setContentOffset:CGPointMake(viewSize.size.width*3, 0) animated:YES];
        }
        if(currentPage == 3)
        {
            [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0) animated:YES];
        }
    }
    num++;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    
    pageControl.currentPage=(page-1);
    int titleIndex=page-1;
    if (titleIndex==[titleArray count]) {
        titleIndex=0;
    }
    if (titleIndex<0) {
        titleIndex=[titleArray count]-1;
    }
    [noteTitle setText:[titleArray objectAtIndex:titleIndex]];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{

    if(!timer)
    {
        [self loadTimer];
    }
    if (currentPageIndex==0) {
      
        [_scrollView setContentOffset:CGPointMake(([imageArray count]-2)*viewSize.size.width, 0)];
    }
    if (currentPageIndex==([imageArray count]-1)) {
       
        [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        
    }

}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if(timer)
    {
//        [timer setFireDate:[NSDate distantFuture]];
        [timer invalidate];
        timer = nil;
    }
}
- (void)imagePressed:(UITapGestureRecognizer *)sender
{

    if ([delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
        [delegate EScrollerViewDidClicked:sender.view.tag];
    }
}

@end
