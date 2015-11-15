//
//  TaskActionControl.m
//  BoandaProject
//
//  Created by 曾静 on 14-2-14.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "TaskActionControl.h"
#import "TaskActionEntity.h"

@implementation TaskActionControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andMenuInfo:(TaskActionEntity *)menuInfo
{
    if([super initWithFrame:frame])
    {
        self.actionItem = menuInfo;
        [self makeView];
    }
    return self;
}

- (void)makeView
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 72, 72)];
    btn.backgroundColor = [UIColor clearColor];
    
    NSString *imgName = self.actionItem.actionIcon;
    if(imgName.length <= 0 || imgName == nil)
    {
        imgName = @"icon_默认.png";
    }
    UIImage *btnImage = [UIImage imageNamed:imgName];
    if(!btnImage)
    {
        btnImage = [UIImage imageNamed:@"icon_默认.png"];
    }
    
    [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UILabel *btnLabel = [[UILabel alloc] initWithFrame: CGRectMake(0 ,77, 82, 30)];
    btnLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    btnLabel.numberOfLines = 2;
    btnLabel.text = self.actionItem.actionTitle;
    btnLabel.textAlignment = UITextAlignmentCenter;
    btnLabel.backgroundColor = [UIColor clearColor];
    btnLabel.contentMode = UIViewContentModeTop;
    [self addSubview:btnLabel];
}

- (void)btnPressed:(id)sender
{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
