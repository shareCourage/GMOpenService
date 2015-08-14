//
//  PHOfflineHeaderView.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/14.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define HeaderViewLabelFontSize 15

#import "PHOfflineHeaderView.h"
#import "PHSettingGroup.h"
@interface PHOfflineHeaderView ()

@property(nonatomic, weak)UIButton *nameView;

@end


@implementation PHOfflineHeaderView

+ (instancetype)offlineHeaderViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"header";
    PHOfflineHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[PHOfflineHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addSubviewInContentView];
    }
    return self;
}
- (void)addSubviewInContentView
{
    // 1.添加按钮
    UIButton *nameView = [UIButton buttonWithType:UIButtonTypeCustom];
    nameView.titleLabel.font = [UIFont boldSystemFontOfSize:HeaderViewLabelFontSize];
    // 背景图片
    [nameView setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg"] forState:UIControlStateNormal];
    [nameView setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg_highlighted"] forState:UIControlStateHighlighted];
    // 设置按钮内部的左边箭头图片
    [nameView setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
    [nameView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 设置按钮的内容左对齐
    nameView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 设置按钮的内边距
    //        nameView.imageEdgeInsets
    nameView.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    nameView.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [nameView addTarget:self action:@selector(nameViewClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置按钮内部的imageView的内容模式为居中
    nameView.imageView.contentMode = UIViewContentModeCenter;
    // 超出边框的内容不需要裁剪
    nameView.imageView.clipsToBounds = NO;
    
    [self.contentView addSubview:nameView];
    self.nameView = nameView;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.nameView.frame = self.bounds;
}
- (void)setGroup:(PHSettingGroup *)group
{
    _group = group;
    [self.nameView setTitle:group.header forState:UIControlStateNormal];
}
/**
 *  监听组名按钮的点击
 */
- (void)nameViewClick
{
    self.group.opened = !self.group.isOpened;
    if ([self.delegate respondsToSelector:@selector(OfflineHeaderViewDidClickedNameView:)]) {
        [self.delegate OfflineHeaderViewDidClickedNameView:self];
    }
}
/**
 *  当一个控件被添加到父控件中就会调用
 */
- (void)didMoveToSuperview
{
    if (self.group.opened) {
        self.nameView.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    } else {
        self.nameView.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}
@end






