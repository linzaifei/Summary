//
//  ZFPresentViewController.m
//  Summary
//
//  Created by xinshiyun on 2017/4/14.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFPresentViewController.h"
#import "ZFShowViewController.h"
#import "ZFPresentViewController.h"
#import "ZFShowPopViewController.h"
@interface ZFPresentViewController ()





@property (strong, nonatomic) NSString *currentPop;
@end

//@implementation ZFPresentViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    
//    
//    
//    [self setUI];
//}
//
//-(void)setUI{
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"选择" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:15];
//    btn.translatesAutoresizingMaskIntoConstraints = NO;
//    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[btn]-50-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(btn)]];
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[btn(==30)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(btn)]];
//
//}
//
//-(void)click{
////    ZFShowViewController *showViewController = [[ZFShowViewController alloc] init];
////    [self presentViewController:showViewController animated:YES completion:NULL];
//    
////    UIPopoverPresentationController * pop = [[UIPopoverPresentationController  alloc] initWithPresentedViewController:<#(nonnull UIViewController *)#> presentingViewController:<#(nullable UIViewController *)#>]
//    
//    //创建你需要显示的controller
// 
//}


@implementation ZFPresentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseArr = @[@"Pop",@"自定义模态",@"自定义push"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    switch (indexPath.row) {
        case 0:{
            ZFShowPopViewController *showPopViewController = [[ZFShowPopViewController alloc] init];
            showPopViewController.title = self.baseArr[indexPath.row];
            [self.navigationController pushViewController:showPopViewController animated:YES];
        }break;
        case 1:{
            ZFShowViewController *showViewController = [[ZFShowViewController alloc] init];
            [self presentViewController:showViewController animated:YES completion:NULL];
        }break;
        case 2:{
         
            
        }break;
            
        default:
            break;
    }
    
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
