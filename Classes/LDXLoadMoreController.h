//
//  LDXLoadMoreController.h
//  LDXTableviewRefresh
//
//  Created by 刘东旭 on 2018/4/8.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDXLoadMoreViewProtocol.h"
@import UIKit;

typedef NS_ENUM(NSUInteger, LDXLoadMoreMode) {
    LDXLoadMoreFooter,
    LDXLoadMoreTableView,
};

@interface LDXLoadMoreController : NSObject

/**
 上拉加载更多加到tableViewFooter上还是tableView上
 */
@property (nonatomic, assign) LDXLoadMoreMode loadMoreMode;

/**
 为TableView初始化一个控制器
 
 @param tableView 需要加上拉加载更多控制器的视图
 @return 控制器对象
 */
- (instancetype)initWithTableView:(UITableView *)tableView;

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
 设置触发上拉加载更多的高度，超过这个偏移量松手会出发上拉加载更多
 
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
