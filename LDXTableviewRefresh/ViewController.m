//
//  ViewController.m
//  testTableview
//
//  Created by 刘东旭 on 2018/4/4.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+LDXRefresh.h"
#import "LDXTableViewHeaderView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>{
    UITableView *tableView;
    int a;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 64)];
    topView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:topView];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 414, 736) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 80;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"abc"];
    [self.view addSubview:tableView];
    __weak typeof(tableView) weakTableView = tableView;
    [tableView ldx_installRefreshBlock:^{
        NSLog(@"刷新");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakTableView ldx_finishRefresh];
        });
    }];
//    [tableView ldx_setRefreshOffset:-30];
    [tableView ldx_setFinishStateDisplayTime:1];
    LDXTableViewHeaderView *view = [[LDXTableViewHeaderView alloc] initWithFrame:CGRectMake(0, -87, 414, 78)];
    view.center = CGPointMake(tableView.center.x, -78/2);
    view.backgroundColor = [UIColor blueColor];
    [tableView ldx_setCustomRefreshView:view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"abc" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    return 80;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
