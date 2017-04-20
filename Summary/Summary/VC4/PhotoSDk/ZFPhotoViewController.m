//
//  ZFPhotoViewController.m
//  Summary
//
//  Created by xinshiyun on 2017/4/12.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFPhotoViewController.h"
#import <Photos/Photos.h>
#import "ZFPhotoHeadView.h"
#import "ZFPhotoCollectionViewCell.h"
#import "RemindView.h"
#import "ZFCamareViewController.h"
#import "ZFPopShowPhotoViewController.h"

//设备屏幕尺寸
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
@interface ZFPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate, UIImagePickerControllerDelegate,PHPhotoLibraryChangeObserver>
@property(strong,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)NSMutableArray *dataArr;
@property(strong,nonatomic)NSMutableArray <PHAsset *>*seletedPhotos;
@property(strong,nonatomic)NSMutableDictionary *selectedAssetsDic;
@property(strong,nonatomic)ZFCamareViewController *camareViewController;
@property(strong,nonatomic)UIView *contentView;
//存储所有照片
@property (nonatomic, strong) NSMutableArray <PHFetchResult *>*sectionResults;
@property (nonatomic, strong) NSMutableArray *sectionCollectResults;

@end

@implementation ZFPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zf_addChildrenView];
    [self zf_setUI];
    [self zf_loadData];
}
-(instancetype)init{
    if (self = [super init]) {
        self.columnCount = 3;
        self.columnSpacing = 1;
        self.rowSpacing = 1;
        self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        self.maxCount = 9;
    }
    return self;
}

-(void)zf_addChildrenView{
    _camareViewController = [[ZFCamareViewController alloc] init];
    _camareViewController.view.frame = CGRectMake(0, -kScreenHeight, kScreenWidth,kScreenHeight);
    [self addChildViewController:_camareViewController];
    [self.view addSubview:self.contentView];
    __weak ZFPhotoViewController *ws = self;
    _camareViewController.backBlock = ^{
        [ws zf_backToFirstPageAnimation];
    };
}

-(void)zf_setUI{
    if(self.columnCount > 5 || self.columnCount < 3){
        self.columnCount = 3;
    }
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    ZFPhotoHeadView *photoHeadView = [ZFPhotoHeadView new];
    photoHeadView.barTintColor = [UIColor whiteColor];
    photoHeadView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:photoHeadView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = self.rowSpacing;
    layout.minimumInteritemSpacing = self.columnSpacing;
    layout.sectionInset = self.sectionInset;
    CGFloat itemWidth = (kScreenWidth - self.rowSpacing * (self.columnCount - 1) - self.sectionInset.left - self.sectionInset.right) / self.columnCount;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.contentView addSubview:self.collectionView];
    [self.collectionView registerClass:[ZFPhotoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZFPhotoCollectionViewCell class])];
   
    //////------block --------
    __weak ZFPhotoViewController *ws = self;
    //点击取消
    photoHeadView.cancelBlock = ^(){
        if (ws.view.subviews.count > 1) {
            [ws.camareViewController.view removeFromSuperview];
            ws.camareViewController.view = nil;
        }
        [ws dismissViewControllerAnimated:YES completion:NULL];
    };
    //点击选中
    photoHeadView.chooseBlock = ^(){
        if ([ws.delegate respondsToSelector:@selector(photoPickerViewController:didSelectPhotos:)]) {
            [ws.delegate photoPickerViewController:ws didSelectPhotos:[ws.seletedPhotos copy]];
        }
    };
    //点击标题
    photoHeadView.titleBlock = ^(){
        [ws zf_showPhotoViewController];
    };
    
///-------布局
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[photoHeadView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(photoHeadView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[photoHeadView(==64)]-0-[_collectionView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(photoHeadView,_collectionView)]];
}

//下来选择
-(void)zf_showPhotoViewController{
    ZFPopShowPhotoViewController *showViewController = [[ZFPopShowPhotoViewController alloc] init];
    showViewController.dataArr = self.sectionCollectResults;
    __weak ZFPhotoViewController *ws = self;
    showViewController.didSelectBlock = ^(NSArray *dataArr, NSInteger index) {
        [ws zf_getFirstData:ws.sectionResults[index] WithAdd:NO];
        if (index == 0) { //这个地方还需要优化 默认第一个就是相机相册的！
            [ws zf_addCamareImage];
        }
        [ws.collectionView reloadData];
    };
    [self presentViewController:showViewController animated:YES completion:NULL];
}

-(void)zf_loadData{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    // 获得相机胶卷
    PHAssetCollection *Libararys = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 遍历相机胶卷,获取大图
    [self zf_enumerateAssetsInAssetCollection:Libararys original:YES];
    
    PHFetchResult<PHAssetCollection *> *assetAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    // 遍历所有的自定义相簿
    __weak ZFPhotoViewController *ws = self;
    [assetAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ws zf_enumerateAssetsInAssetCollection:obj original:YES];
    }];

    dispatch_group_leave(group);
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [ws zf_getFirstData:[ws.sectionResults firstObject] WithAdd:NO];
        [ws zf_addCamareImage];
        [ws.collectionView reloadData];
    });
}

-(void)zf_getFirstData:(PHFetchResult *)assets WithAdd:(BOOL)isadd {
    [self.dataArr removeAllObjects];
    __weak ZFPhotoViewController *ws = self;
    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (isadd && idx == assets.count - 1) {
          [ws.selectedAssetsDic setValue:obj forKey:obj.localIdentifier];
            if (ws.seletedPhotos.count == 0) {
                [ws.seletedPhotos addObject:obj];
            }else{
            [ws.seletedPhotos enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                if (![obj.localIdentifier isEqualToString:obj1.localIdentifier]) {
                    [ws.seletedPhotos addObject:obj];
                }
            }];
            }
        }
        [ws.dataArr addObject:obj];
    }];
}

-(void)zf_addCamareImage{
    UIImage *cameraImage = [UIImage imageNamed:[@"ZFPhotoBundle.bundle" stringByAppendingPathComponent:@"AssetsCamera.png"]];
    [cameraImage resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.dataArr addObject:cameraImage];
}


/**
 遍历所有照片
 
 @param assetCollection 相簿
 @param original 是不是原始图片
 */

- (void)zf_enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original{
    //相簿名
    NSLog(@"title = %@",assetCollection.localizedTitle);
    [self.sectionCollectResults addObject:assetCollection];
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> * assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    [self.sectionResults addObject:assets];
    
    /*
     synchronous：指定请求是否同步执行。
     resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     normalizedCropRect：用于对原始尺寸的图像进行裁剪，基于比例坐标。只在 resizeMode 为 Exact 时有效。
     */
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZFPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZFPhotoCollectionViewCell class]) forIndexPath:indexPath];
    NSInteger index = self.dataArr.count - indexPath.item - 1;
    id data = self.dataArr[index];
    [cell zf_setAssest:data];
    
    BOOL isSelected = NO;
    if ([data isKindOfClass:[PHAsset class]]) {
        PHAsset *asset = (PHAsset *)data;
        if ([self.selectedAssetsDic valueForKey:asset.localIdentifier]) {
            isSelected = YES;
        }
    }
    cell.isSelect = isSelected;
    __weak ZFPhotoViewController *ws = self;
    __weak ZFPhotoCollectionViewCell *weakCell = cell;
    cell.btnSelectBlock = ^(PHAsset *asset, BOOL isSelect) {
        NSString *urlKey = asset.localIdentifier;
        if ([ws.selectedAssetsDic valueForKey:urlKey]) {
            weakCell.isSelect = NO;
            [ws.seletedPhotos removeObject:ws.selectedAssetsDic[urlKey]];
            [ws.selectedAssetsDic removeObjectForKey:urlKey];
        }else {
            if (ws.seletedPhotos.count >= ws.maxCount) {
                [RemindView showViewWithTitle:[NSString stringWithFormat:@"%@%lu", NSLocalizedString(@"最多选择", nil), (unsigned long)ws.maxCount] location:LocationTypeMIDDLE];
                return;
            }
            weakCell.isSelect = YES;
            [ws.selectedAssetsDic setObject:asset forKey:urlKey];
            [ws.seletedPhotos addObject:asset];
        }

    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = self.dataArr.count - indexPath.item - 1;
    id data = self.dataArr[index];
    if ([data isKindOfClass:[UIImage class]]) {
        [self zf_goToDetailAnimation];
        
    }else{
        PHAsset *asset = (PHAsset *)data;
    }
}

///外部传入 是否选中状态
-(void)setSelectItems:(NSArray<PHAsset *> *)selectItems{
    for (PHAsset *asset in selectItems) {
        if (asset) {
            [self.selectedAssetsDic setValue:asset forKey:asset.localIdentifier];
        }
        [self.seletedPhotos addObject:asset];
    }
}

// 进入相机的动画
- (void)zf_goToDetailAnimation{
    if (self.view.subviews.count < 2) {
        [self.view addSubview:_camareViewController.view];
    }
    __weak ZFPhotoViewController *ws = self;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        ws.camareViewController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        ws.contentView.frame = CGRectMake(0, kScreenHeight,kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        [ws.camareViewController zf_onpenAnnimation];
    }];
}
// 返回第一个界面的动画
- (void)zf_backToFirstPageAnimation {
     __weak ZFPhotoViewController *ws = self;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        ws.camareViewController.view.frame = CGRectMake(0,-kScreenHeight, kScreenWidth, kScreenHeight);
        ws.contentView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
    
    }];
}

#pragma mark - 添加插入移动删除图片事 调用
// This callback is invoked on an arbitrary serial queue. If you need this to be handled on a specific queue, you should redispatch appropriately
- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    // Photos may call this method on a background queue;
    // switch to the main queue to update the UI.
    //深拷贝，备份比较
    NSMutableArray *updatedSectionFetchResults = [self.sectionResults mutableCopy];
    __block BOOL reloadRequired = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
//        PHFetchResult *rootCollectionsFetchResult = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
        [self.sectionResults enumerateObjectsUsingBlock:^(PHFetchResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"----%ld",obj.count);
            
            //根据原先的相片集的数据创建变化对象
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:obj];
             //判断变化对象是否为空，不为空则代表有相册有变化
            if(changeDetails != nil){
                NSLog(@"%@",changeDetails.fetchResultAfterChanges);
                NSLog(@"---------");
                //变化后的数据替换变化前的数据
                [updatedSectionFetchResults replaceObjectAtIndex:idx withObject:[changeDetails fetchResultAfterChanges]];
                reloadRequired = YES;
            }
        }];
        if (reloadRequired) {
            //刷新数据
            self.sectionResults = updatedSectionFetchResults;
            [self zf_getFirstData:[self.sectionResults firstObject] WithAdd:YES];
            [self zf_addCamareImage];
            [self.collectionView reloadData];
        }
    });
}



#pragma mark ----
-(UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _contentView;
}

-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray <PHAsset *>*)seletedPhotos{
    if (_seletedPhotos == nil) {
        _seletedPhotos = [NSMutableArray array];
    }
    return _seletedPhotos;
}

- (NSMutableDictionary *)selectedAssetsDic {
    if (_selectedAssetsDic == nil) {
        _selectedAssetsDic = [NSMutableDictionary dictionary];
    }
    return _selectedAssetsDic;
}
-(NSMutableArray <PHFetchResult *> *)sectionResults{
    if(_sectionResults == nil){
        _sectionResults = [NSMutableArray array];
    }
    return _sectionResults;
}
- (NSMutableArray *)sectionCollectResults {
    if (_sectionCollectResults == nil) {
        _sectionCollectResults = [NSMutableArray array];
    }
    return _sectionCollectResults;
}

#pragma mark  --- 相册获取参考数据
//获取自定义相册簿 （自己创建的相册）
/*
 Album //从 iTunes 同步来的相册，以及用户在 Photos 中自己建立的相册
 SmartAlbum //经由相机得来的相册
 Moment //Photos 为我们自动生成的时间分组的相册
 */


/*
 enum PHAssetCollectionSubtype : Int {
 case AlbumRegular //用户在 Photos 中创建的相册，也就是我所谓的逻辑相册
 case AlbumSyncedEvent //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步过来的事件。然而，在iTunes 12 以及iOS 9.0 beta4上，选用该类型没法获取同步的事件相册，而必须使用AlbumSyncedAlbum。
 case AlbumSyncedFaces //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步的人物相册。
 case AlbumSyncedAlbum //做了 AlbumSyncedEvent 应该做的事
 case AlbumImported //从相机或是外部存储导入的相册，完全没有这方面的使用经验，没法验证。
 case AlbumMyPhotoStream //用户的 iCloud 照片流
 case AlbumCloudShared //用户使用 iCloud 共享的相册
 case SmartAlbumGeneric //文档解释为非特殊类型的相册，主要包括从 iPhoto 同步过来的相册。由于本人的 iPhoto 已被 Photos 替代，无法验证。不过，在我的 iPad mini 上是无法获取的，而下面类型的相册，尽管没有包含照片或视频，但能够获取到。
 case SmartAlbumPanoramas //相机拍摄的全景照片
 case SmartAlbumVideos //相机拍摄的视频
 case SmartAlbumFavorites //收藏文件夹
 case SmartAlbumTimelapses //延时视频文件夹，同时也会出现在视频文件夹中
 case SmartAlbumAllHidden //包含隐藏照片或视频的文件夹
 case SmartAlbumRecentlyAdded //相机近期拍摄的照片或视频
 case SmartAlbumBursts //连拍模式拍摄的照片，在 iPad mini 上按住快门不放就可以了，但是照片依然没有存放在这个文件夹下，而是在相机相册里。
 case SmartAlbumSlomoVideos //Slomo 是 slow motion 的缩写，高速摄影慢动作解析，在该模式下，iOS 设备以120帧拍摄。
 case SmartAlbumUserLibrary //这个命名最神奇了，就是相机相册，所有相机拍摄的照片或视频都会出现在该相册中，而且使用其他应用保存的照片也会出现在这里。
 case Any //包含所有类型
 }
 
 
 (2).资源的子类型.
 mediaSubtypes:PHAssetMediaSubtype类型的枚举值:
 PHAssetMediaSubtypeNone               没有任何子类型
 相片子类型
 PHAssetMediaSubtypePhotoPanorama      全景图
 PHAssetMediaSubtypePhotoHDR           滤镜图
 PHAssetMediaSubtypePhotoScreenshot 截屏图
 PHAssetMediaSubtypePhotoLive 1.5s 的 photoLive
 视屏子类型
 PHAssetMediaSubtypeVideoStreamed      流体
 PHAssetMediaSubtypeVideoHighFrameRate 高帧视屏
 PHAssetMediaSubtypeVideoTimelapse   延时拍摄视频
 
 */


/*
 info 信息
 
 PHImageFileOrientationKey = 0;
 PHImageFileSandboxExtensionTokenKey = "298fd95ea90e3a96018632dba00e53e37ad85426;00000000;00000000;000000000000001a;com.apple.app-sandbox.read;00000001;01000003;00000000000382d7;/private/var/mobile/Media/DCIM/100APPLE/IMG_0197.JPG";
 PHImageFileURLKey = "file:///var/mobile/Media/DCIM/100APPLE/IMG_0197.JPG";
 PHImageFileUTIKey = "public.jpeg";
 PHImageResultDeliveredImageFormatKey = 9999;
 PHImageResultIsDegradedKey = 0;
 PHImageResultIsInCloudKey = 0;
 PHImageResultIsPlaceholderKey = 0;
 PHImageResultOptimizedForSharing = 0;
 PHImageResultWantedImageFormatKey = 4035;
 */

-(void)dealloc{
    //销毁观察相册变化的观察者
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    NSLog(@"销毁 %s",__FUNCTION__);
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
