//
//  WriteEmailViewController.m
//  GuangXiOA
//
//  Created by apple on 13-1-9.
//
//

#import "WriteEmailViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"

/*
 1.在requestData中添加
   if(self.sento == nil)
      self.sento = self.receiverLabel.text;
 2.在requestData中修改NSString *cjrid = [usrInfo objectForKey:@"userid"];为
   NSString *cjrid = [usrInfo objectForKey:@"userId"];
 3.如果是回复邮件的情况下，不显示添加用户的功能
 */

@interface WriteEmailViewController ()

- (void)initDefault;
- (void)initCome;
- (void)addSendButton;

- (void)requestData;
- (IBAction)addButtonClick:(id)sender;
- (void)sendButtonClick:(id)sender;
//- (void)animateUp;
//- (void)animateDown;

@end

@implementation WriteEmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDefault];
    [self addSendButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - self私有

- (void)initDefault
{
    self.animateHeight = 0.0;
    _departmentArray = [[NSMutableArray alloc] init];
    _personArray = [[NSMutableArray alloc] init];
    self.typeTag = 0;
    
    _receiverLabel.text = nil;
    _receiverLabel.layer.borderWidth = 0.5;
    _receiverLabel.layer.cornerRadius = 3;
    _receiverLabel.layer.borderColor = [UIColor grayColor].CGColor;
    
    _titleTextView.text = nil;
    _titleTextView.layer.borderWidth = 0.5;
    _titleTextView.layer.cornerRadius = 3;
    _titleTextView.layer.borderColor = [UIColor grayColor].CGColor;
    
    _contextTextView.text = nil;
    _contextTextView.layer.borderWidth = 0.5;
    _contextTextView.layer.cornerRadius = 3;
    _contextTextView.layer.borderColor = [UIColor grayColor].CGColor;
    
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHideKeyboard:)];
    //[self.view addGestureRecognizer:tap];
    
    [self initCome];
}

- (void)initCome
{
    switch (self.fjlxTag)
    {
        case 1:
        {
            //编写邮件
            self.jslx = @"C";
        }
            break;
        case 2:
        {
            //回复邮件
            _receiverLabel.text = self.sjrString;
            _titleTextView.text = self.btString;
            _contextTextView.text = nil;
            _addButton.hidden = YES;
            self.jslx = @"R";
        }
            break;
        case 3:
        {
            //转发邮件
            _titleTextView.text = self.btString;
            _contextTextView.text = self.nrString;
            self.jslx = @"Z";
        }
            break;
        default:
            break;
    }
}

- (void)requestData
{
    
    if ([_receiverString length] <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请填写联系人"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
        
    };
    
    if ([_titleTextView.text length] <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请填写标题"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
        
    };
    
    if ([_contextTextView.text length] <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请填写内容"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
        
    };
    
    NSDictionary *usrInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    NSString *cnName = [usrInfo objectForKey:@"uname"];
    NSString *usrDepartMent = [usrInfo objectForKey:@"depart"];
    NSString *orgid = [usrInfo objectForKey:@"orgid"];
    NSString *cjrid = [usrInfo objectForKey:@"userId"];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"DOCUMENTTRANSPORT" forKey:@"service"];
    [params setObject:self.jslx forKey:@"jslx"];
    [params setObject:cnName forKey:@"cjr"];
    [params setObject:cjrid forKey:@"cjrid"];
    if(self.sento == nil)
        self.sento = self.receiverLabel.text;
    [params setObject:self.sento forKey:@"sendTo"];
    [params setObject:usrDepartMent forKey:@"cjrbm"];
    [params setObject:orgid forKey:@"orgid"];
    [params setObject:_receiverString forKey:@"users"];
    [params setObject:_contextTextView.text forKey:@"bztext"];
    [params setObject:_titleTextView.text forKey:@"bt"];
    if ([self.fjbh length] > 0)
        [params setObject:self.fjbh forKey:@"fjbh"]; 
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)addSendButton
{
    UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonClick:)];
    self.navigationItem.rightBarButtonItem = aItem;
}

- (IBAction)addButtonClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    //    UIBarButtonItem *btn = (UIBarButtonItem *)sender;
    if (_popVc)
        [_popVc dismissPopoverAnimated:YES];
    
    _yjPopVc = [[EmailPersonViewController alloc] init];
    _yjPopVc.delegate = self;

    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:self.yjPopVc];
    self.popVc = [[UIPopoverController alloc] initWithContentViewController:nv];
    
    [_popVc presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

- (void)sendButtonClick:(id)sender
{
    [self requestData];
}

#pragma mark EmailPersonViewControllerDelegate

- (void)didSelectedCellSendTo:(NSString *)aSento array:(NSArray *)array
{
    NSMutableString *nameString =[[NSMutableString alloc] init];
    NSMutableString *idString =[[NSMutableString alloc] init];

    NSDictionary *dic = nil;
    for (dic in array)
    {
        [nameString appendFormat:@"%@,",[dic objectForKey:@"MC"]];
        [idString appendFormat:@"%@,",[dic objectForKey:@"ID"]];
    }
    if (nameString.length > 0 && idString.length >0)
    {
        self.receiverString = [idString substringToIndex:idString.length-1];
        _receiverLabel.text = [nameString substringToIndex:nameString.length-1];
    }
    self.sento = aSento;
}

#pragma mark NSURLConnHelperDelegate

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    //BOOL bParseError = NO;
    NSArray *array = [resultJSON objectFromJSONString];
    NSString *code = [[array objectAtIndex:0] objectForKey:@"retcode"];
    NSString *message = [[array objectAtIndex:0] objectForKey:@"message"];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:message
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    if ([code isEqualToString:@"0"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}

-(void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"请求数据失败."
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    return;
}

#pragma mark - UITextField Delegate Method

- (void)tapToHideKeyboard:(UITapGestureRecognizer *)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


@end
