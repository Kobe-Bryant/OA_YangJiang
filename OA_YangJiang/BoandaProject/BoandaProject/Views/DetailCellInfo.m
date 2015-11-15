//
//  DetailCellInfo.m
//  BeiHaiOA
//
//  Created by 曾静 on 14-1-15.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "DetailCellInfo.h"
#import "NSStringUtil.h"

@implementation DetailCellInfo

@synthesize leftKey, leftTitle, rightKey, rightTitle;

- (id)initCellInfoWithRow:(int)aRow
           andWithRowData:(NSDictionary *)aData
         andWithTitleInfo:(NSString *)aTitle
           andWithKeyInfo:(NSString *)aKey
{
    if(self = [super init])
    {
        self.rowIndex = aRow;
        self.titleInfo = aTitle;
        self.keyInfo = aKey;
        self.rowData = aData;
        
        [self getCellData:self.titleInfo andType:@"title"];
        [self getCellData:self.keyInfo andType:@"key"];
    }
    return self;
}

- (void)getCellData:(NSString *)str andType:(NSString *)type
{
    if(str == nil || str.length <= 0)
    {
        return;
    }
    
    NSRange range = [str rangeOfString:@"#"];
    if(range.location != NSNotFound)
    {
        //一行四列
        self.cellType = DetailCellDoubleType;
        NSString *s1 = [str substringToIndex:range.location];
        if(s1 == nil || s1.length <= 0)
        {
            s1 = @"";
        }
        
        NSString *s2 = [str substringFromIndex:range.location + range.length];
        if(s2 == nil || s2.length <= 0)
        {
            s2 = @"";
        }
        
        if([type isEqualToString:@"key"])
        {
            self.leftKey = s1;
            self.rightKey = s2;
        }
        else
        {
            self.leftTitle = s1;
            self.rightTitle = s2;
        }
        
    }
    else
    {
        //一行两列
        self.cellType = DetailCellSingleType;
        if([type isEqualToString:@"key"])
        {
            self.leftKey = str;
        }
        else
        {
            self.leftTitle = str;
        }
        
    }
    
}

- (CGFloat)getRowHeight
{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
    NSString *itemTitle =[NSString stringWithFormat:@"%@", [self.rowData objectForKey:self.leftKey]];
    CGFloat cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0];
    cellHeight += 20.0;
    if(cellHeight < 60)
    {
        cellHeight = 60.0f;
    }
    return cellHeight;
}

@end
