//
//  QQSectionHeaderView.h
//  TQQTableView
//
//  Created by Futao on 11-6-22.
//  Copyright 2011 ftkey.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol QQSectionHeaderViewDelegate;

@interface QQSectionHeaderView : UIView

@property (nonatomic, strong) UIButton *disclosureButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) BOOL opened;
@property (nonatomic, strong) id <QQSectionHeaderViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber opened:(BOOL)isOpened delegate:(id<QQSectionHeaderViewDelegate>)delegate;

-(id)initWithFrame:(CGRect)frame title:(NSString*)title subTitle:(NSString*)aSubTitle section:(NSInteger)sectionNumber opened:(BOOL)isOpened delegate:(id)aDelegate;

@end

@protocol QQSectionHeaderViewDelegate <NSObject> 

@optional
-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
@end
