//
//  Summary.h
//  Summary
//
//  Created by xinshiyun on 2017/4/10.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#ifndef Summary_h
#define Summary_h
//十六进制
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]//十六进制转换

#define HexRGBA(rgbValue,al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]//十六进制转换

//设备屏幕尺寸
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kTabBarHeight 49
#define kNavgationBarHeight 64

#define AutoSizeWidth(Width) ((Width / 375.0) * kScreenWidth)
#define AutoSizeHeight(Height) ((Height / 667.0) * kScreenHeight)

//appdelegate
#define ZFAppDelegate (AppDelegate *)[UIApplication sharedApplication].delegate
#define ZFKeyWindow [UIApplication sharedApplication].keyWindow




#endif /* Summary_h */
