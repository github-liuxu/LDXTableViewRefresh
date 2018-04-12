//
//  LDXLoadMoreController.m
//  LDXTableviewRefresh
//
//  Created by 刘东旭 on 2018/4/8.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import "LDXLoadMoreController.h"

typedef enum : NSUInteger {
    LDXLoadMoreNormal,
    LDXLoadingMore,
    LDXLoadMoreFinish,
} LDXLoadMoreState;

@interface LDXLoadMoreView : UIView <LDXLoadMoreViewProtocol>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) LDXLoadMoreState *ldx_loadMoreState;

- (void)ldx_loadMoreOffsetY:(CGFloat)offsetY;
- (void)ldx_loadingMore;
- (void)ldx_loadMoreFinish;
- (void)ldx_endLoadMore;

@end

@implementation LDXLoadMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.text = @"上拉加载更多";
        [self addSubview:self.label];
    }
    return self;
}

- (void)ldx_loadMoreOffsetY:(CGFloat)offsetY {
    //    self.label.text = [@"hello" stringByAppendingFormat:@"%f",[offsetY floatValue]];
}

- (void)ldx_loadingMore {
    self.label.text = @"上拉正在加载";
}

- (void)ldx_loadMoreFinish {
    self.label.text = @"完成加载";
}

- (void)ldx_endLoadMore {
    self.label.text = @"上拉加载更多";
}

@end

@interface LDXLoadMoreController()

@property (nonatomic, assign) LDXLoadMoreState loadMoreState;
@property (nonatomic, copy) void(^loadMoreBlock)(void);
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) LDXLoadMoreView *loadMoreView;
@property (nonatomic, assign) CGFloat loadMoreFinishStateTime;
@property (nonatomic, assign) CGFloat loadMoreHeight;

@end

@implementation LDXLoadMoreController

- (void)dealloc {
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    if (self.loadMoreMode == LDXLoadMoreTableView) {
        [self.tableView removeObserver:self forKeyPath:@"contentSize"];
    }
}

/**
 为TableView初始化一个控制器
 
 @param tableView 需要加上拉加载更多控制器的视图
 @return 控制器对象
 */
- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        self.tableView = tableView;
        self.loadMoreState = LDXLoadMoreNormal;
        self.loadMoreHeight = 44;
        if (self.loadMoreMode == LDXLoadMoreFooter) {
            self.loadMoreView = [[LDXLoadMoreView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.loadMoreHeight)];
            self.tableView.tableFooterView = self.loadMoreView;
        } else {
            self.loadMoreView = [[LDXLoadMoreView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height + self.loadMoreHeight, self.tableView.frame.size.width, self.loadMoreHeight)];
            [self.tableView addSubview:self.loadMoreView];
        }
        
    }
    return self;
}

/**
 安装上拉加载更多的组件
 
 @param block 上拉加载更多的block
 */
- (void)ldx_installLoadMoreBlock:(void(^)(void))block {
    self.loadMoreBlock = block;
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    if (self.loadMoreMode == LDXLoadMoreTableView) {
        [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
}

/**
 移除上拉加载更多组件
 */
- (void)ldx_removeLoadMore {
    if (self.loadMoreMode == LDXLoadMoreFooter) {
        self.tableView.tableFooterView = nil;
    } else {
        [self.loadMoreView removeFromSuperview];
    }
    self.loadMoreView = nil;
}

/**
 设置上拉加载更多完成
 */
- (void)ldx_finishLoadMore {
    [self.loadMoreView performSelector:@selector(ldx_loadMoreFinish)];
    self.loadMoreState = LDXLoadMoreFinish;
    
    if (self.loadMoreMode == LDXLoadMoreTableView) {
        [UIView animateWithDuration:0.3 delay:self.loadMoreFinishStateTime options:UIViewAnimationOptionTransitionNone animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            self.loadMoreState = LDXLoadMoreNormal;
            [self.loadMoreView performSelector:@selector(ldx_endLoadMore)];
        }];
    } else {
        self.loadMoreState = LDXLoadMoreNormal;
        [self.loadMoreView performSelector:@selector(ldx_endLoadMore)];
    }
    
}

/**
 设置触发上拉加载更多的向上偏移量，达到这个偏移量松手会出发上拉加载更多
 
 @param height 默认为44
 */
- (void)ldx_setLoadMoreHeight:(CGFloat)height {
    self.loadMoreHeight = height;
    if (self.loadMoreMode == LDXLoadMoreTableView) {
        self.loadMoreView.frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.frame.size.width, height);
    } else {
        self.loadMoreView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, height);
    }
}

/**
 设置上拉加载更多完成状态的显示时间
 
 @param displayTime 上拉加载更多完成状态的显示时间默认0秒
 */
- (void)ldx_setFinishStateDisplayTime:(CGFloat)displayTime {
    self.loadMoreFinishStateTime = displayTime;
}

/**
 设置自定义上拉加载更多视图
 
 @param customView 自定义上拉加载更多视图需要实现LDXLoadMoreViewProtocol协议
 */
- (void)ldx_setCustomLoadMoreView:(UIView<LDXLoadMoreViewProtocol> *)customView {
    [self ldx_removeLoadMore];
    if (self.loadMoreMode == LDXLoadMoreTableView) {
        [self.tableView addSubview:customView];
    } else {
        self.tableView.tableFooterView = customView;
    }
    self.loadMoreView = (LDXLoadMoreView*)customView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.loadMoreMode == LDXLoadMoreTableView) {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            CGFloat offsetY = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
            [self.loadMoreView ldx_loadMoreOffsetY:offsetY];
            if (offsetY+self.tableView.frame.size.height >= self.tableView.contentSize.height+self.loadMoreHeight && self.loadMoreState == LDXLoadMoreNormal && !self.tableView.isDragging) {
                self.loadMoreState = LDXLoadingMore;
                [self.loadMoreView ldx_loadingMore];
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.loadMoreHeight-1, 0);
                !self.loadMoreBlock?:self.loadMoreBlock();
            }
        } else if ([keyPath isEqualToString:@"contentSize"]) {
            if (self.loadMoreState == LDXLoadMoreNormal) {
                CGFloat sizeH = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue].height;
                self.loadMoreView.frame = CGRectMake(0, sizeH, self.tableView.frame.size.width, self.loadMoreHeight);
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            CGFloat offsetY = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
            [self.loadMoreView ldx_loadMoreOffsetY:offsetY];
            if (offsetY > self.tableView.contentSize.height-self.tableView.frame.size.height-self.loadMoreHeight && self.loadMoreState == LDXLoadMoreNormal && !self.tableView.isDragging) {
                self.loadMoreState = LDXLoadingMore;
                [self.loadMoreView ldx_loadingMore];
                !self.loadMoreBlock?:self.loadMoreBlock();
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}


@end
