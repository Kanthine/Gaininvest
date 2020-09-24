//
//  DemoData.m
//  GainInvest
//
//  Created by 苏沫离 on 2020/9/22.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "DemoData.h"

@interface DemoData ()

///时间戳
#define k_DemoData_timeStamps_count DemoData.timeStamps.count
+ (NSArray<NSString *> *)timeStamps;



///手机号
#define k_DemoData_Phones_count DemoData.phonesArray.count
+ (NSArray<NSString *> *)phonesArray;

#define k_DemoData_BannerPath_count DemoData.booksBannersArray.count
+ (NSArray<NSString *> *)booksBannersArray;


#define k_DemoData_booksName_count DemoData.booksNameArray.count
+ (NSArray<NSString *> *)booksNameArray;

///网页链接
#define k_DemoData_WebURL_count DemoData.webURLArray.count
+ (NSArray<NSString *> *)webURLArray;
@end


@implementation DemoData

///时间戳
+ (NSArray<NSString *> *)timeStamps{
    return @[@"1572488151169",@"1593741280456",@"1594000480567",@"1594004080121",
             @"1596419680123",@"1278384880126",@"1583463280566",@"1599360880987",
             @"1602212080123",@"1577847280235",@"1577843680123",@"1577818480123",];
}

///昵称
+ (NSArray<NSString *> *)nickNameArray{
    return @[@"幸福来敲门",@"张三",@"李四",@"王五",@"闲云清烟",@"拟墨画扇",
             @"自在枯荣",@"等风来",@"细雪长风",@"共枕一梦",@"杯中影",@"草草大梦",@"沉梦听雨",@"浮世清欢",
             @"三千痴妄"];
}

///手机号
+ (NSArray<NSString *> *)phonesArray{
    return @[@"13623786798",@"18629874501",@"13838298727",
             @"17698236751",@"18823889503",@"18523876723",
             @"13536786723",@"13666788766",@"13888997752"];
}

///头像
+ (NSArray<NSString *> *)headPathArray{
    return @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596430284854&di=9196fc027c2a6511594dfd505bd36c09&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201901%2F09%2F20190109072726_aNNZd.thumb.700_0.jpeg",
             @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1027245443,3552957153&fm=26&gp=0.jpg",
             @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1077287175,1506372161&fm=26&gp=0.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596430285001&di=83b1857e2eb7c44bd133c5a5210ca4d3&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201901%2F17%2F20190117230425_eofqv.thumb.700_0.jpg",
             @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2558693067,2868064481&fm=26&gp=0.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596430285000&di=2a85a344ed45043c9fa76105d52aa209&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F0eb30f2442a7d933ed8c1316af4bd11373f001aa.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596430284999&di=4ebe05885599b469d97a34b8a3528bf3&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201803%2F16%2F20180316213032_cielg.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596430346339&di=18dffee8f8209a85ce47eda42356de3c&imgtype=0&src=http%3A%2F%2Fimg3.imgtn.bdimg.com%2Fit%2Fu%3D2449529543%2C2725053068%26fm%3D214%26gp%3D0.jpg",
             @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3995885402,1113893169&fm=26&gp=0.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596430284991&di=18e4a03e83f500d23db8a96da93aca99&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fq_70%2Cc_zoom%2Cw_640%2Fimages%2F20190115%2F87868f21befc4e7f9007aa71efa79621.jpeg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596430352714&di=9052383566d0474cb63e5f1acb8a965e&imgtype=0&src=http%3A%2F%2Fpic4.zhimg.com%2F50%2Fv2-89ed25c87d3ad9b1c0e59081db5f0a19_hd.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596430352712&di=602b98005b634d86e8a16c2ad48b6543&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201811%2F07%2F20181107171108_gubxr.thumb.700_0.jpeg",
             @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2383244993,2312176529&fm=26&gp=0.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596430352712&di=6be0c38f7c969fe1f79c3c373e47c54d&imgtype=0&src=http%3A%2F%2Fpic1.zhimg.com%2F50%2Fv2-e96bf3c0da3dcb019bf5e1f985424568_hd.jpg",];
}


+ (NSArray<NSString *> *)booksBannersArray{
    return @[@"http://attach.bbs.miui.com/forum/201311/17/174124tp3sa6vvckc25oc8.jpg",
             @"http://attach.bbs.miui.com/forum/201401/11/145825zn1sxa8anrg11gt1.jpg",
             @"http://attach.bbs.miui.com/forum/201304/25/195151szk8umd8or8fmfa5.jpg",
             @"http://pic1.win4000.com/wallpaper/b/55597435bb036.jpg",
             @"http://attach.bbs.miui.com/forum/201408/07/194456i55q58pqnb55fi88.jpg",
             @"http://attach.bbs.miui.com/forum/201105/17/113554rnu40q7nbgnn3lgq.jpg",
             @"http://bbsfiles.vivo.com.cn/vivobbs/attachment/forum/201601/24/175433rossj7cn74vksn4p.jpg",
             @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1307/10/c6/23169175_1373445345248.jpg",
             @"http://desktop.kole8.com/desktop/desk_file-11/13/28/2012/1/201211822373112.jpg",
             @"http://bbsfiles.vivo.com.cn/vivobbs/attachment/forum/201810/19/150133hk0jedj00ejae006.jpg",
             @"http://00.minipic.eastday.com/20170821/20170821133945_d41d8cd98f00b204e9800998ecf8427e_1.jpeg",
    @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583496427475&di=098599874cc52bd7d9093fe7edab9392&imgtype=0&src=http%3A%2F%2Ft8.baidu.com%2Fit%2Fu%3D1484500186%2C1503043093%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D1280%26h%3D853",
    @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583496449996&di=600e788927c5fdff2b6b3c0993a87a0b&imgtype=0&src=http%3A%2F%2Ft9.baidu.com%2Fit%2Fu%3D3949188917%2C63856583%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D1280%26h%3D875",
    @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1583496449993&di=3df56003d1b5954b92b8002fccd28335&imgtype=0&src=http%3A%2F%2Ft7.baidu.com%2Fit%2Fu%3D1355385882%2C1155324943%26fm%3D79%26app%3D86%26f%3DJPEG%3Fw%3D1280%26h%3D854",];
}


+ (NSArray<NSString *> *)booksNameArray{
    return @[@"悲惨世界",@"平凡的世界",@"安徒生童话",@"白鹿原",@"一千零一夜",@"一千零一夜",
             @"论语",@"圣经",@"物种起源",@"全球通史",@"君主论",@"史记",@"孙子兵法",@"三国演义",
             @"西游记",@"水浒传",@"红楼梦",@"老人与海",@"国富论",@"飘",@"钢铁是怎样炼成的"
             ,@"呐喊",@"小王子",@"本草纲目",@"简爱",@"边城",@"围城",@"麦田里的守望者",];
}

+ (NSArray<NSString *> *)booksCoversArray{
    return @[@"http://img4.imgtn.bdimg.com/it/u=327119959,2526267555&fm=26&gp=0.jpg",
             @"http://img3.imgtn.bdimg.com/it/u=2159419590,3998434501&fm=26&gp=0.jpg",
             @"http://img3.imgtn.bdimg.com/it/u=458922937,543714884&fm=26&gp=0.jpg",
             @"http://img4.imgtn.bdimg.com/it/u=1480743255,2446368421&fm=26&gp=0.jpg",
             @"http://img5.imgtn.bdimg.com/it/u=2736761559,399311486&fm=26&gp=0.jpg",
             @"http://img1.imgtn.bdimg.com/it/u=1059018038,828065489&fm=26&gp=0.jpg",
             @"http://img5.imgtn.bdimg.com/it/u=3975852581,2448280456&fm=26&gp=0.jpg",
             @"http://img5.imgtn.bdimg.com/it/u=3058617630,1899065739&fm=26&gp=0.jpg",
             @"http://img0.imgtn.bdimg.com/it/u=1778127776,868298998&fm=26&gp=0.jpg",
             @"http://img3.imgtn.bdimg.com/it/u=3314409276,3994157161&fm=26&gp=0.jpg",
             @"http://img0.imgtn.bdimg.com/it/u=1183339026,48563010&fm=26&gp=0.jpg",
             @"http://img2.imgtn.bdimg.com/it/u=2170722014,1015805118&fm=26&gp=0.jpg",
             @"http://img5.imgtn.bdimg.com/it/u=85543659,1165252712&fm=26&gp=0.jpg",];
}

+ (NSArray<NSString *> *)webURLArray{
    return @[@"https://www.jianshu.com",
             @"https://www.jianshu.com/p/d882f9e4ba17",
             @"https://www.jianshu.com/p/1d39eba89fdc",
             @"https://www.jianshu.com/p/d73756d39499",
             @"http://www.cocoachina.com/articles/900852?filter=ios",
             @"http://www.cocoachina.com/articles/900868?filter=ios",
             @"http://www.cocoachina.com/articles/900673?filter=ios",
             @"http://www.cocoachina.com/articles/900575?filter=ios",
             @"http://www.cocoachina.com/articles/900267?filter=ios",
             @"http://www.cocoachina.com/articles/900164?filter=ios",];
}

+ (NSArray<NSString *> *)booksIntrosArray{
    return @[@"两千年中国政治伦理与社会伦理的基石",
             @"不把这本书读懂、读通、读透，就不能深刻理解和把握中国几千年的传统文化。",
             @"构建中华文明阶梯的重要典籍",
             @"影响人类文化的100本书之一",
             @"最能代表中国文化的哲学书",
             @"一部划时代的巨作",
             @"当今社会的 救世箴言",
             @"欧洲历代君主的案头书，政治家的最高指南",
             @"以史为鉴，知千秋盛衰兴替；前事不忘，明万代是非得失",
             @"一部治国安邦、立身处世的最佳教科书",
             @"兵家韬略之首",@"一部包含着丰富的智慧和谋略的杰作",];
}


+ (NSMutableArray<ConsultKindTitleModel *> *)consultKindTitleArray{
    
    NSMutableArray<ConsultKindTitleModel *> *resultArray = [NSMutableArray array];
    NSString *path = [NSBundle.mainBundle pathForResource:@"ConsultKindTitles" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray<NSDictionary *> *array1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    [array1 enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ConsultKindTitleModel *model = [ConsultKindTitleModel modelObjectWithDictionary:obj];
        [resultArray addObject:model];
    }];
    return resultArray;
}


+ (NSMutableArray<ConsultListModel *> *)ConsultListArrayWithKindTitle:(ConsultKindTitleModel *)titleModel{
    NSMutableArray<ConsultListModel *> *resultArray = [NSMutableArray array];

    for (int i = 0; i < 20; i ++) {
        ConsultListModel *model = [[ConsultListModel alloc] init];
        model.analystName = DemoData.nickNameArray[arc4random() % k_DemoData_nickName_count];
        model.imageUrl = DemoData.headPathArray[arc4random() % k_DemoData_HeadPath_count];
        model.articleDate = DemoData.timeStamps[arc4random() % k_DemoData_timeStamps_count];
        model.articleTitle = DemoData.booksNameArray[arc4random() % k_DemoData_booksName_count];
        model.webURL = DemoData.webURLArray[arc4random() % k_DemoData_WebURL_count];
        [resultArray addObject:model];
    }
    return resultArray;
}

@end








@implementation DemoData (Service)


+ (NSMutableArray<InorderModel *> *)inorderModelArray{
    NSMutableArray<InorderModel *> *resultArray = [NSMutableArray array];
    
    
    return resultArray;
}


///时分图假数据
+ (NSMutableArray<NSString *> *)timeLineChartDatasWithType:(NSString *)type{
    NSMutableArray<NSString *> *resultArray = [NSMutableArray array];
    float baseData = 512.56;
    for (int i = 0; i < 1000; i++) {
        float value = baseData + (arc4random() % 20000) / 99.9;
        [resultArray addObject:[NSString stringWithFormat:@"%f",value]];
    }
    return resultArray;
}

///时分图假数据
+ (NSMutableArray<NSString *> *)timeDatesWithType:(NSString *)type{
    NSMutableArray<NSString *> *resultArray = [NSMutableArray array];
    int baseData = arc4random()  % 10;
    for (int i = 0; i < 1000; i++) {
        int value = baseData + i;
        [resultArray addObject:[NSString stringWithFormat:@"%d",value]];
    }
    return resultArray;
}


+ (NSInteger)queryCouponCount{
    if ([AuthorizationManager isBindingMobile] == NO){
        return [UserLocalData getCouponCount];
    }
    return 30 + arc4random() % 50;
}

/** 查询用户所有的赢家券信息
 * coupon_type : 券类型 1：未使用 2：已使用 3：已过期
 */
+ (NSMutableArray<CouponModel *> *)couponArrayWithType:(NSString *)type{
    NSMutableArray<CouponModel *> *resultArray = [NSMutableArray array];
    NSArray<NSString *> *channels = @[@"1",@"4",@"12",@"34",@"40"];
    for (int i = 0; i < [UserLocalData getCouponCount]; i++) {
        CouponModel *model = [[CouponModel alloc] init];
        model.mobile = AccountInfo.standardAccountInfo.phone.integerValue;
        model.channel = channels[arc4random() % 5].integerValue;
        model.rechargeMoney = 53.21 + ( arc4random() % 1000) / 99.0;
        model.internalBaseClassIdentifier = arc4random() % 50 + i;
        model.startTime = @"2017-06-01 08:06:01";
        model.endTime = @"2017-09-01 22:20:31";
        model.couponName = @"折扣券";
        model.wid = @"123456";
        model.flag = arc4random() % 2;
        model.isUse = arc4random() % 2;
        model.couponId = arc4random() % 50 + i;
        [resultArray addObject:model];
    }
    return resultArray;
}


/** 获取用户的持仓信息列表
 */
+ (NSMutableArray<PositionsModel *> *)accessOpenPosition{
    NSMutableArray<PositionsModel *> *resultArray = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        PositionsModel *model = [[PositionsModel alloc] init];
        model.buyDirection = arc4random() % 2;
        model.couponFlag = arc4random() % 2;
        model.topLimit = 721.3;
        model.bottomLimit = 535.7;
        model.orderId = arc4random() % 50 + i;
        [resultArray addObject:model];
    }
    return resultArray;
}

@end
