//
//  LoginViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-1.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "MainMenuViewController.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "PDJsonkit.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *usrField;
@property (nonatomic, strong) UITextField *pwdField;

@end


#define KUserName @"KUserName"

@implementation LoginViewController
@synthesize usrField,pwdField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

-(void)addUIViews
{
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBg"]];
    [self.view addSubview:bgImgView];
    
    UILabel *usrLabel = [[UILabel alloc] initWithFrame:CGRectMake(246, 443, 92, 37)];
    usrLabel.backgroundColor = [UIColor clearColor];
    usrLabel.textColor = [UIColor blackColor];
    usrLabel.font = [UIFont systemFontOfSize:22.0];
    usrLabel.text = @"用户名：";
    [self.view addSubview:usrLabel];
    
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(246, 488, 92, 37)];
    pwdLabel.backgroundColor = [UIColor clearColor];
    pwdLabel.textColor = [UIColor blackColor];
    pwdLabel.font = [UIFont systemFontOfSize:22.0];
    pwdLabel.text = @"密   码：";
    [self.view addSubview:pwdLabel];
    
    self.usrField = [[UITextField alloc]  initWithFrame:CGRectMake(330, 446, 192, 31)];
    usrField.borderStyle = UITextBorderStyleRoundedRect;
    usrField.autocapitalizationType = UITextAutocapitalizationTypeNone;//设置首字母不自动大写
    usrField.autocorrectionType = UITextAutocorrectionTypeNo;//设置不自动更正
    [self.view addSubview:usrField];
    self.pwdField = [[UITextField alloc] initWithFrame:CGRectMake(330, 492, 192, 31)];
    pwdField.borderStyle = UITextBorderStyleRoundedRect;
    pwdField.secureTextEntry = YES;
    [self.view addSubview:pwdField];
    
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnLogin setTitle:@"登    录" forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [btnLogin addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    btnLogin.frame = CGRectMake(246, 557, 276, 38);
    [self.view addSubview:btnLogin];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addUIViews];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *usr = [defaults objectForKey:KUserName];
	if (usr == nil) usr= @"";
	usrField.text = usr;
}

-(void)login:(id)sender
{
    NSString *msg = @"";
    if ([usrField.text isEqualToString:@""] || usrField.text.length == 0)
    {
        msg = @"用户名不能为空";
    }
    else if([pwdField.text isEqualToString:@""] || pwdField.text.length == 0)
    {
        msg = @"密码不能为空";
    }
    if([msg length] > 0)
    {
        [self showAlertMessage:msg];
		return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_INDEX" forKey:@"service"];
    NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithCapacity:5];
    [dicUser setObject:pwdField.text forKey:@"password"];
    [dicUser setObject:usrField.text forKey:@"userId"];
    [[SystemConfigContext sharedInstance] setUser:dicUser];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self tipInfo:@"正在登录中..." tagID:0] ;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Network Handler Methods

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
    {
        NSString *msg = @"登录失败";
        [self showAlertMessage:msg];
        return;
    }
    
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    BOOL bFailed = NO;
    NSArray *jsonAry = [resultJSON objectFromJSONString];
    if (jsonAry && [jsonAry count] > 0)
    {
        NSDictionary *dicInfo = [jsonAry objectAtIndex:0];
        int status = [[dicInfo objectForKey:@"status"] intValue];
        if (status == 1)
        {
            //登录认证成功
            NSArray *aryDatas = [dicInfo objectForKey:@"datas"];
            NSArray *aryUsr = [dicInfo objectForKey:@"users"];
            NSString *usr = usrField.text;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:usr forKey:KUserName];
            if([aryUsr count] > 0)
            {
                NSDictionary *resUsr = [aryUsr lastObject];
                NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithCapacity:5];
                [dicUser setObject:pwdField.text forKey:@"password"];
                [dicUser setObject:usr forKey:@"userId"];
                [dicUser setObject:[resUsr objectForKey:@"NAME"] forKey:@"uname"];
                [dicUser setObject:[resUsr objectForKey:@"DEPARTMENT"] forKey:@"depart"];
                [dicUser setObject:[resUsr objectForKey:@"ORGID"] forKey:@"orgid"];
                [[SystemConfigContext sharedInstance] setUser:dicUser];
            }
            
            NSMutableDictionary *dicBadgeInfo = [NSMutableDictionary dictionaryWithCapacity:5];
            //事先设置个数为0，避免造成返回数据异常的时候Badge个数不一致的问题
            [dicBadgeInfo setObject:@"0" forKey:@"来文"];
            [dicBadgeInfo setObject:@"0" forKey:@"发文"];
            [dicBadgeInfo setObject:@"0" forKey:@"移动邮箱"];
            [dicBadgeInfo setObject:@"0" forKey:@"公告"];
            [dicBadgeInfo setObject:@"0" forKey:@"网络问政"];
            [dicBadgeInfo setObject:@"0" forKey:@"微博发文"];
            [dicBadgeInfo setObject:@"0" forKey:@"任务督办"];
            [dicBadgeInfo setObject:@"0" forKey:@"会议"];
            [dicBadgeInfo setObject:@"0" forKey:@"待办公文"];
            [dicBadgeInfo setObject:@"0" forKey:@"通知公告"];
            if([aryDatas count] > 0)
            {
                for(NSDictionary *dicItem in aryDatas)
                {
                    NSString *lx = [dicItem objectForKey:@"LX"];
                    NSString *num = [NSString stringWithFormat:@"%@",[dicItem objectForKey:@"NUM"]];
                    if([lx isEqualToString:@"LW"])
                    {     
                        [dicBadgeInfo setObject:num forKey:@"来文"];
                    }
                    else if([lx isEqualToString:@"FW"])
                    {
                        [dicBadgeInfo setObject:num forKey:@"发文"];
                    }
                    else if([lx isEqualToString:@"NBYJ"])
                    {
                        [dicBadgeInfo setObject:num forKey:@"移动邮箱"];
                    }
                    else if([lx isEqualToString:@"TZGG"])
                    {
                        [dicBadgeInfo setObject:num forKey:@"公告"];
                    }
                    else if([lx isEqualToString:@"WLWZ"])
                    {
                        [dicBadgeInfo setObject:num forKey:@"网络问政"];
                    }
                    else if([lx isEqualToString:@"WBFW"])
                    {
                        [dicBadgeInfo setObject:num forKey:@"微博发文"];
                    }
                    else if([lx isEqualToString:@"RWDB"])
                    {
                        [dicBadgeInfo setObject:num forKey:@"任务督办"];
                    }
                    else if([lx isEqualToString:@"HY"])
                    {
                        [dicBadgeInfo setObject:num forKey:@"会议"];
                    }
                    else if ([lx isEqualToString:@"HYTZ"])
                    {
                        [dicBadgeInfo setObject:num forKey:@"会议通知"];
                    }
                    else if ([lx isEqualToString:@"ALL"])
                    {
                        [dicBadgeInfo setObject:num forKey:@"待办公文"];
                    }
                }
            }
           /*待办公文 = 来文+发文
            NSString *lw = [dicBadgeInfo objectForKey:@"来文"];
            NSString *fw = [dicBadgeInfo objectForKey:@"发文"];
            NSInteger all = 0;
            if([lw length] > 0)all += [lw integerValue];
            if([fw length] > 0)all += [fw integerValue];
            [dicBadgeInfo setObject:[NSString stringWithFormat:@"%d",all] forKey:@"待办公文"];*/
            //跳转到菜单界面
            MainMenuViewController *menuController= [[MainMenuViewController alloc] init];
            menuController.dicBadgeInfo = dicBadgeInfo;
            [self.navigationController pushViewController:menuController animated:YES];
        }
        else if(status == -1)
        {
            //不在白名单内
            UILabel *udidLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 600, 468, 120)];
            udidLabel.backgroundColor = [UIColor clearColor];
            udidLabel.textColor = [UIColor redColor];
            udidLabel.font = [UIFont systemFontOfSize:22.0];
            udidLabel.numberOfLines = 0;
            udidLabel.text = [NSString stringWithFormat: @"此设备未与所登录的用户绑定。如需绑定，请联系维护人员并提供以下设备号：\n   %@", [[SystemConfigContext sharedInstance] getDeviceID]];
            [self.view addSubview:udidLabel];
            
            return;
        }
        else if(status == 0)
        {
            //登录失败
            NSString *msg = [dicInfo objectForKey:@"description"];
            [self showAlertMessage:msg];
            return;
        }
        else
        {
            bFailed = YES;
        }
    }
    else
    {
        bFailed = YES;
    }
    if (bFailed)
    {
        [self showAlertMessage:@"登录失败"];
        return;
    }
}

-(void)processError:(NSError *)error
{
    [self showAlertMessage:@"请求数据失败,请检查网络."];
    return;
}

-(void)gotoMainMenu
{
    MainMenuViewController *menuController = [[MainMenuViewController alloc] init];
    [self.navigationController pushViewController:menuController animated:YES];
}

@end
