//
//  OnlineFileFolderViewController.m
//  BoandaProject
//
//  Created by 曾静 on 14-3-14.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "OnlineFileFolderViewController.h"
#import "FolderMenuItem.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "OnlineFileListViewController.h"

@interface OnlineFileFolderViewController ()

@property (nonatomic, strong) UIScrollView *menuScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *folderAry;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL pageControlIsChangingPage;

@end

@implementation OnlineFileFolderViewController

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
    
    self.title = @"在线资料";
    
    self.isLoading = NO;
    
    [self addCustomView];
    
    [self requestData];
}

- (void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_MeetingList" forKey:@"service"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)processWebData:(NSData *)webData
{
    self.isLoading = NO;
    if(webData.length <= 0)
    {
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSArray *jsonResultAry = [resultJSON objectFromJSONString];
    if(jsonResultAry && jsonResultAry.count > 0)
    {
        NSDictionary *dict = [jsonResultAry objectAtIndex:0];
        NSArray *tmpAry = [dict objectForKey:@"result"];
        if(tmpAry && tmpAry.count > 0)
        {
            NSMutableArray *tmpFolderAry = [[NSMutableArray alloc] init];
            for (NSDictionary *tmpDict in tmpAry)
            {
                FolderMenuItem *item = [[FolderMenuItem alloc] init];
                item.WDMC = [tmpDict objectForKey:@"WDMC"];
                item.WDBH = [tmpDict objectForKey:@"WDBH"];
                [tmpFolderAry addObject:item];
            }
            self.folderAry = tmpFolderAry;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadMenuView:self.folderAry];
    });
}

- (void)processError:(NSError *)error
{
    self.isLoading = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCustomView
{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    bgView.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:bgView];
    
    self.menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(14, 102, 740, 756)];
    self.menuScrollView.delegate = self;
    self.menuScrollView.backgroundColor = [UIColor clearColor];
    [self.menuScrollView setCanCancelContentTouches:NO];
	self.menuScrollView.showsHorizontalScrollIndicator = NO;
    self.menuScrollView.showsVerticalScrollIndicator = NO;
    self.menuScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	self.menuScrollView.clipsToBounds = YES;
	self.menuScrollView.scrollEnabled = YES;
	self.menuScrollView.pagingEnabled = YES;
    [self.view addSubview:self.menuScrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(284, 900, 200, 36)];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
}

//根据菜单的数据加载菜单界面
- (void)loadMenuView:(NSArray *)itemArr
{
    int w = 240.0, h = 180.0;//菜单按钮的宽和高
    int n = 3;//每行的个数
    int spanX = 5;//x方向间隔宽度
    int spanY = 5;//y方向间隔宽度
    int count = [itemArr count];
    
    int pageSize = 12;
    int pageCount = (count%pageSize == 0) ? (count/pageSize) : (count/pageSize)+1;//页数
    
    for (int i = 0; i < pageCount; i++)
    {
        int leftCount = count - pageSize*i;//剩下的页数
        if(leftCount < pageSize)
        {
            pageSize = leftCount;
        }
        for(int j = 0; j < pageSize; j++)
        {
            //设置菜单的图标
            FolderMenuItem *item = [itemArr objectAtIndex:i*12+j];
            UIButton *but  = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect rect = CGRectMake(spanX+(spanX+w)*(j%n)+(740*i), spanY+(spanY+h)*(j/n), w, h);
            but.frame = rect;
            [but addTarget:self action:@selector(menuItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            but.tag = 100 + (i*12+j);
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%i",j+1]];
            [but setBackgroundImage:img forState:UIControlStateNormal];
            [self.menuScrollView addSubview:but];
            
            //设置菜单的标题文字
            UILabel *butTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 140.0, 230.0, 30.0)];
            butTitleLab.textColor = [UIColor whiteColor];
            butTitleLab.backgroundColor = [UIColor clearColor];
            butTitleLab.font = [UIFont boldSystemFontOfSize:24.0];
            butTitleLab.text = item.WDMC;
            butTitleLab.textAlignment = UITextAlignmentRight;
            [but addSubview:butTitleLab];
        }
    }
    self.pageControl.numberOfPages = pageCount;
    self.menuScrollView.contentSize = CGSizeMake(740*pageCount, 756);
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (self.pageControlIsChangingPage)
    {
        return;
    }
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    self.pageControlIsChangingPage = NO;
}

#pragma mark - Event Handler Methods

//切换页
- (void)changePage:(id)sender
{
    CGRect frame = self.menuScrollView.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    [self.menuScrollView scrollRectToVisible:frame animated:YES];
    self.pageControlIsChangingPage = YES;
}

//菜单按钮点击事件
- (void)menuItemClicked:(UIButton *)sender
{
    int tag = sender.tag - 100;
    if(tag >= self.folderAry.count)
    {
        return;
    }
    FolderMenuItem *item = [self.folderAry objectAtIndex:tag];
    OnlineFileListViewController *list = [[OnlineFileListViewController alloc] init];
    list.wdbh = item.WDBH;
    list.folderName = item.WDMC;
    [self.navigationController pushViewController:list animated:YES];
}

@end
