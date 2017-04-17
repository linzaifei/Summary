//
//  ZFCollectionLayoutViewContollerViewController.m
//  Summary
//
//  Created by xinshiyun on 2017/4/10.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFCollectionLayoutViewContollerViewController.h"
#import "ZFCollectionWaterFallViewController.h"

@interface ZFCollectionLayoutViewContollerViewController ()



@end

@implementation ZFCollectionLayoutViewContollerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseArr = @[@"普通布局",@"瀑布流",@"滑动布局"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZFCollectionWaterFallViewController *waterFallVC = [[ZFCollectionWaterFallViewController alloc] init];
    waterFallVC.title = self.baseArr[indexPath.row];
    switch (indexPath.row) {
        case 0:
            waterFallVC.type = CollectionLayoutTypeNone;
            break;
        case 1:
            waterFallVC.type = CollectionLayoutTypeWater;
            break;
        case 2:
            waterFallVC.type = CollectionLayoutTypeScroll;
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:waterFallVC animated:YES];
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
