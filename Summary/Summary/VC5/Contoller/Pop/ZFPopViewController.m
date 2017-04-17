//
//  ZFPopViewController.m
//  Summary
//
//  Created by xinshiyun on 2017/4/14.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFPopViewController.h"

@interface ZFPopViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *tableView;


@end

@implementation ZFPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = self.dataArr[indexPath.row];
    if (self.picArr[indexPath.row]) {
        cell.imageView.image = [UIImage imageNamed:self.picArr[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.clickCellIndexBlock) {
        self.clickCellIndexBlock(self.dataArr, indexPath.row);
    }
}

//重写preferredContentSize（iOS7之后）来返回最合适的大小，如果不重写，会返回一整个tableview尽管下面一部分cell是没有内容的，重写后只会返回有内容的部分，我这里还修改了宽，让它窄一点。可以尝试注释这一部分的代码来看效果，通过修改返回的size得到你期望的popover的大小。
- (CGSize)preferredContentSize {
    if (self.presentingViewController && self.tableView != nil) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 150;
        CGSize size = [self.tableView sizeThatFits:tempSize];  //sizeThatFits返回的是最合适的尺寸，但不会改变控件的大小
        return size;
    }else {
        return [super preferredContentSize];
}}
- (void)setPreferredContentSize:(CGSize)preferredContentSize{
    super.preferredContentSize = preferredContentSize;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
