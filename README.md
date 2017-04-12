# Summary
总结遇到的问题


////Layout 约束
-(NSArray *)constraintsWithVisualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

### 参数定义:
第一个参数：V:|-(>=XXX) :表示垂直方向上相对于SuperView大于、等于、小于某个距离
若是要定义水平方向，则将V：改成H：即可
在接着后面-[]中括号里面对当前的View/控件 的高度/宽度进行设定；
第二个参数：options：字典类型的值；这里的值一般在系统定义的一个enum里面选取
第三个参数：metrics：nil；一般为nil ，参数类型为NSDictionary，从外部传入 //衡量标准
第四个参数：views：就是上面所加入到NSDictionary中的绑定的View


### 使用规则:
|: 表示父视图
-:表示距离
V:  :表示垂直
H:  :表示水平
>= :表示视图间距、宽度和高度必须大于或等于某个值
<= :表示视图间距、宽度和高度必须小宇或等于某个值
== :表示视图间距、宽度或者高度必须等于某个值
@  :>=、<=、==  限制   最大为  1000
|-[view]-|:  视图处在父视图的左右边缘内
|-[view]  :   视图处在父视图的左边缘
|[view]   :   视图和父视图左边对齐
-[view]-  :  设置视图的宽度高度
|-30.0-[view]-30.0-|:  表示离父视图 左右间距  30
[view(200.0)] : 表示视图宽度为 200.0
|-[view(view1)]-[view1]-| :表示视图宽度一样，并且在父视图左右边缘内
V:|-[view(50.0)] : 视图高度为  50
V:|-(==padding)-[imageView]->=0-[button]-(==padding)-| : 表示离父视图的距离
为Padding,这两个视图间距必须大于或等于0并且距离底部父视图为 padding。
[wideView(>=60@700)]  :视图的宽度为至少为60 不能超过  700
如果没有声明方向默认为  水平  V:


－－－－－－－－－－－－－－－－－－－－－－－－－分割线－－－－－－－－－－－－－－－－－－－－－－－

+(instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c;

### 参数说明:
第一个参数:指定约束左边的视图view1
第二个参数:指定view1的属性attr1，具体属性见文末。
第三个参数:指定左右两边的视图的关系relation，具体关系见文末。
第四个参数:指定约束右边的视图view2
第五个参数:指定view2的属性attr2，具体属性见文末。
第六个参数:指定一个与view2属性相乘的乘数multiplier
第七个参数:指定一个与view2属性相加的浮点数constant


这个函数的对照公式为:
view1.attr1 <relation> view2.attr2 * multiplier + constant
注意:
1.如果你想设置的约束里不需要第二个view，要将第四个参数设为nil，第五个参数设为NSLayoutAttributeNotAnAttribute

typedef NS_ENUM(NSInteger, NSLayoutRelation) {
NSLayoutRelationLessThanOrEqual = -1,          //小于等于
NSLayoutRelationEqual = 0,                     //等于
NSLayoutRelationGreaterThanOrEqual = 1,        //大于等于
};
typedef NS_ENUM(NSInteger, NSLayoutAttribute) {
NSLayoutAttributeLeft = 1,                     //左侧
NSLayoutAttributeRight,                        //右侧
NSLayoutAttributeTop,                          //上方
NSLayoutAttributeBottom,                       //下方
NSLayoutAttributeLeading,                      //首部
NSLayoutAttributeTrailing,                     //尾部
NSLayoutAttributeWidth,                        //宽度
NSLayoutAttributeHeight,                       //高度
NSLayoutAttributeCenterX,                      //X轴中心
NSLayoutAttributeCenterY,                      //Y轴中心
NSLayoutAttributeBaseline,                     //文本底标线

NSLayoutAttributeNotAnAttribute = 0            //没有属性
};

NSLayoutAttributeLeft/NSLayoutAttributeRight 和NSLayoutAttributeLeading/NSLayoutAttributeTrailing的区别是left/right永远是指左右，而leading/trailing在某些从右至左习惯的地区会变成，leading是右边，trailing是左边。
