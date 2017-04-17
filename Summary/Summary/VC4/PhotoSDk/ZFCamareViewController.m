//
//  ZFCamareViewController.m
//  Summary
//
//  Created by xinshiyun on 2017/4/14.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFCamareViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZFPhotoHeadView.h"


#define Flash_Width
#define TakePhotoBackView_Height 120
#define FlashBackView_Height 65
#define PIC_Width 40
#define PIC_Height 30
#define leftButton_With 60
#define leftButton_Height 40
#define TakePhotoBtn_Width 70
#define TakePhotoBtn_Height 70
@interface ZFCamareViewController ()<UIGestureRecognizerDelegate>

//AVFoundation

@property (nonatomic) dispatch_queue_t sessionQueue;

/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */

@property (nonatomic, strong) AVCaptureSession* session;
/**
 *  输入设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**
 *  照片输出流
 */
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;

/**
 *  记录开始的缩放比例
 */
@property(nonatomic,assign)CGFloat beginGestureScale;
/**
 *  最后的缩放比例
 */
@property(nonatomic,assign)CGFloat effectiveScale;
/*!
 *  显示却换摄像头 闪光灯
 */
@property(nonatomic,strong)UIView *flashBackView;



/*!
 *  相机背景
 */
//@property(nonatomic,strong)UIView *backView;

//@property (nonatomic,strong)UIImageView *imageView;
//@property (nonatomic)UIImage *image;
//@property (nonatomic)UIButton *TakePhotoBtn;
//@property (nonatomic)UIView *focusView;
//@property(nonatomic,strong)UIView *TakePhotoBackView;
//@property (nonatomic,strong)UIImageView *UpImageView;
//@property (nonatomic,strong)UIImageView *DownImageView;

@end

@implementation ZFCamareViewController{
    BOOL isUsingFrontFacingCamera;
    NSData *_data;
    CFDictionaryRef _dicRef;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    if (self.session) {
        [self.session startRunning];
    }
    [self setUI];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
    if (self.session) {
        [self.session stopRunning];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAVCaptureSession];
    [self Setting];
    
    isUsingFrontFacingCamera = NO;
    self.effectiveScale = self.beginGestureScale = 1.0f;
//    [self performSelector:@selector(annimation) withObject:self afterDelay:1];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 初始化设置
-(void)Setting{
    ZFCamareHeadView *camareHeadView = [ZFCamareHeadView new];
    camareHeadView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:camareHeadView];
    
    ZFTakePhotoHeadView *takePhotoHeadView = [ZFTakePhotoHeadView new];
    takePhotoHeadView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:takePhotoHeadView];
    
    __weak ZFCamareViewController *ws = self;
    camareHeadView.cancelBlock = ^(){
        [ws backAction];
    };
    camareHeadView.flashBlock = ^(){
        [ws AutoFlash];
    };
    camareHeadView.changeBlock = ^(){
        [ws chageCamera];
    };
    
    /////------------布局
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[camareHeadView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(camareHeadView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[camareHeadView(==64)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(camareHeadView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[takePhotoHeadView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(takePhotoHeadView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[takePhotoHeadView(==130)]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(takePhotoHeadView)]];
    
}

#pragma mark private method
- (void)initAVCaptureSession{
    self.session = [[AVCaptureSession alloc] init];
    NSError *error;
    /*!
     *  捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
     */
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        
        NSLog(@"%@",error);
    }
    /*!
     图片输出
     
     - returns:
     */
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    
    /*!
     *  设置预览图层充满屏幕
     */
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = self.view.bounds;// CGRectMake(0,self.flashBackView.height,kScreenWidth, kScreenHeight - self.TakePhotoBackView.height - self.flashBackView.height);
    [self.view.layer addSublayer:self.previewLayer];
//    [self.view addSubview:self.backView];
//    [self.view addSubview:self.TakePhotoBackView];
//    [self.view addSubview:self.flashBackView];
    
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

#pragma 创建手势
- (void)setUpGesture{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
//    [self.backView addGestureRecognizer:pinch];
}
#pragma mark gestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma mark - 按钮触发事件
/*!
 *  开启关闭闪光灯
 */
-(void)AutoFlash{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([device hasFlash]) {
        if (device.flashMode == AVCaptureFlashModeOff) {
            device.flashMode = AVCaptureFlashModeOn;
//            [sender setTitle:@"On" forState:UIControlStateNormal];
        } else if (device.flashMode == AVCaptureFlashModeOn) {
            device.flashMode = AVCaptureFlashModeAuto;
//            [sender setTitle:@"OFF" forState:UIControlStateNormal];
        } else if (device.flashMode == AVCaptureFlashModeAuto) {
            device.flashMode = AVCaptureFlashModeOff;
//            [sender setTitle:@"Auto" forState:UIControlStateNormal];
        }
        
    } else {
        NSLog(@"设备不支持闪光灯");
    }
    [device unlockForConfiguration];
}
/*!
 *  却换前后摄像头
 */
-(void)chageCamera {
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        CATransition *animation = [CATransition animation];
        animation.duration = .5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"oglFlip";
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[_videoInput device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
        }else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }
        
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.previewLayer addAnimation:animation forKey:nil];
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:_videoInput];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.videoInput = newInput;
            } else {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
            
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}
/*!
 *  拍照
 */
-(void)TakePhotoAction{
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                    imageDataSampleBuffer,
                                                                    kCMAttachmentMode_ShouldPropagate);
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            //无权限
            return ;
        }
        
        _data = imageData;
        _dicRef = attachments;
        
        
//        self.image = [UIImage imageWithData:imageData];
//        
//        [self.session stopRunning];
//        
//        self.imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
//        [self.view insertSubview:_imageView belowSubview:_DownImageView];
//        self.imageView.layer.masksToBounds = YES;
//        self.imageView.image = _image;
//        NSLog(@"image size = %@",NSStringFromCGSize(self.image.size));
        
    }];
    
}

//取消选中
-(void)cancle {
//    [self.imageView removeFromSuperview];
//    [self.session startRunning];
}

//返回
-(void)backAction{
//    [UIView animateWithDuration:0.3 animations:^{
//        _UpImageView.transform = CGAffineTransformIdentity;
//        _DownImageView.transform = CGAffineTransformIdentity;
//        
//    }];
    [self performSelector:@selector(dey) withObject:self afterDelay:1];
}

-(void)dey{
    if (self.backBlock) {
        self.backBlock();
    }
}

-(void)takePic {
    __weak ZFCamareViewController *WeakSelf = self;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageDataToSavedPhotosAlbum:_data metadata:(__bridge id)
     _dicRef completionBlock:^(NSURL *assetURL, NSError *error) {
         [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
             if ([_cameraDelegate respondsToSelector:@selector(photoCapViewController:didFinishDismissWithPhotoImage:)]) {
                 [_cameraDelegate photoCapViewController:self didFinishDismissWithPhotoImage:asset];
                 
                 //                 NSLog(@"%@",asset);
                 
             }
             [WeakSelf backAction];
         } failureBlock:^(NSError *error) {
             
             

         }];
     }];
   
}

//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    
    for ( i = 0; i < numTouches; ++i ) {
        
        CGPoint location = [recognizer locationOfTouch:i inView:self.view];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
        
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,recognizer.scale);
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        NSLog(@"%f",maxScaleAndCropFactor);
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
    }
    
}

-(void)setUI {
//    
//    _UpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, FlashBackView_Height, kScreenWidth, (kScreenHeight - FlashBackView_Height - TakePhotoBackView_Height) / 2)];
//    
//    _UpImageView.backgroundColor = [UIColor grayColor];
//    
//    [self.view insertSubview:_UpImageView belowSubview:self.flashBackView];
//    
//    
////    _DownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,_UpImageView.bottom, kScreenWidth, (kScreenHeight - FlashBackView_Height - TakePhotoBackView_Height) / 2)];
//    
//    _DownImageView.backgroundColor = [UIColor grayColor];
    
//    [self.view insertSubview:_DownImageView belowSubview:self.TakePhotoBackView];
    
    
}

-(void)annimation {
//    [UIView animateWithDuration:0.5 animations:^{
//        _UpImageView.transform = CGAffineTransformMakeTranslation(0,- _UpImageView.frame.size.height - FlashBackView_Height );
//        _DownImageView.transform = CGAffineTransformMakeTranslation(0, _DownImageView.frame.size.height + TakePhotoBackView_Height);
//    }];
}


#pragma mark - ---
-(UIView *)flashBackView {
    if (_flashBackView == nil) {
        _flashBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,FlashBackView_Height )];
        _flashBackView.backgroundColor = [UIColor grayColor];
    }
    return _flashBackView;
}

//-(UIView *)backView {
//    if (_backView == nil) {
//        _backView = [[UIView alloc] initWithFrame:self.view.bounds];
//        _backView.layer.masksToBounds = YES;
//    }
//    return _backView;
//    
//}
//-(UIView *)TakePhotoBackView {
//    if (_TakePhotoBackView == nil) {
//        _TakePhotoBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - TakePhotoBackView_Height, kScreenWidth, TakePhotoBackView_Height)];
//        _TakePhotoBackView.backgroundColor = [UIColor grayColor];
//    }
//    return _TakePhotoBackView;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"销毁%s",__FUNCTION__);
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
