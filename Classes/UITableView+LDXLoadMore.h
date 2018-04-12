//
//  UITableView+LDXLoadMore.h
//  LDXTableviewRefresh
//
//  Created by 刘东旭 on 2018/4/11.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDXLoadMoreViewProtocol.h"
#import "LDXLoadMoreController.h"

@interface UITableView (LDXLoadMore)

/**
 上拉加载更多加到tableViewFooter上还是tableView上
 */
- (void)setLoadMoreMode:(LDXLoadMoreMode)loadMoreMode;

/**
 安装上拉加载更多的组件
 
 @param block 上拉加载更多的block
 */
- (void)ldx_installLoadMoreBlock:(void(^)(void))block;

/**
 移除上拉加载更多组件
 */
- (void)ldx_removeLoadMore;

/**
 设置上拉加载更多完成
 */
- (void)ldx_finishLoadMore;

/**
 设置触发上拉加载更多的向上偏移量，达到这个偏移量松手会出发上拉加载更多
 
 @param height 默认为44
 */
- (void)ldx_setLoadMoreHeight:(CGFloat)height;

/**
 设置上拉加载更多完成状态的显示时间
 
 @param displayTime 上拉加载更多完成状态的显示时间默认0秒
 */
- (void)ldx_setFinishStateDisplayTime:(CGFloat)displayTime;

/**
 设置自定义上拉加载更多视图
 
 @param customView 自定义上拉加载更多视图需要实现LDXLoadMoreViewProtocol协议
 */
- (void)ldx_setCustomLoadMoreView:(UIView<LDXLoadMoreViewProtocol> *)customView;

@end
