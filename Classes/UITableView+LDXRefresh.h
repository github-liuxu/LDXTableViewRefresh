//
//  UITableView+LDXRefresh.h
//  testTableview
//
//  Created by 刘东旭 on 2018/4/5.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 自定义刷新组件的协议
 */
@protocol LDXRefreshViewProtocol <NSObject>

@required

/**
 刷新过程中偏移量回调的
 
 @param offsetY offsetY偏移量
 */
- (void)ldx_refreshOffsetY:(NSNumber*)offsetY;

/**
 正在刷新的回调
 */
- (void)ldx_refreshing;

/**
 刷新完成的回调
 */
- (void)ldx_refreshFinish;

@end

@interface UITableView (LDXRefresh)

/**
 安装下拉刷新的组件

 @param block 下拉刷新的block
 */
- (void)ldx_installRefreshBlock:(void(^)(void))block;

/**
 移除刷新组件
 */
- (void)ldx_removeRefresh;

/**
 设置刷新完成
 */
- (void)ldx_finishRefresh;

/**
 设置触发刷新的向下偏移量，达到这个偏移量松手会出发刷新

 @param offsetY 默认为-78
 */
- (void)ldx_setRefreshOffset:(CGFloat)offsetY;

/**
 设置刷新完成状态的显示时间

 @param displayTime 刷新完成状态的显示时间默认0秒
 */
- (void)ldx_setFinishStateDisplayTime:(CGFloat)displayTime;

/**
 设置自定义刷新视图

 @param customView 自定义刷新视图需要实现LDXRefreshViewProtocol协议
 */
- (void)ldx_setCustomRefreshView:(UIView<LDXRefreshViewProtocol> *)customView;

@end
