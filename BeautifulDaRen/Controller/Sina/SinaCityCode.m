//
//  SinaCityCode.m
//  BeautifulDaRen
//
//  Created by Jerry Lee on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SinaCityCode.h"

@interface SinaCityCode ()

@property (nonatomic, retain) NSDictionary * anhui;
@property (nonatomic, retain) NSDictionary * fujian;
@property (nonatomic, retain) NSDictionary * gansu;
@property (nonatomic, retain) NSDictionary * guangdong;
@property (nonatomic, retain) NSDictionary * guangxi;
@property (nonatomic, retain) NSDictionary * hubei;
@property (nonatomic, retain) NSDictionary * hunan;
@property (nonatomic, retain) NSDictionary * hebei;
@property (nonatomic, retain) NSDictionary * henan;
@property (nonatomic, retain) NSDictionary * guizhou;
@property (nonatomic, retain) NSDictionary * hannan;
@property (nonatomic, retain) NSDictionary * heilongjiang;
@property (nonatomic, retain) NSDictionary * neimenggu;

@property (nonatomic, retain) NSDictionary * sichuan;
@property (nonatomic, retain) NSDictionary * guowai;
@property (nonatomic, retain) NSDictionary * jiangxi;
@property (nonatomic, retain) NSDictionary * jiangsu;
@property (nonatomic, retain) NSDictionary * shanxi;
@property (nonatomic, retain) NSDictionary * qinghai;
@property (nonatomic, retain) NSDictionary * ningxia;
@property (nonatomic, retain) NSDictionary * jilin;
@property (nonatomic, retain) NSDictionary * liaoning;
@property (nonatomic, retain) NSDictionary * xinjiang;
@property (nonatomic, retain) NSDictionary * hainan;

@property (nonatomic, retain) NSDictionary * shandong;
@property (nonatomic, retain) NSDictionary * yunnan;
@property (nonatomic, retain) NSDictionary * zhejiang;
@property (nonatomic, retain) NSDictionary * xizang;
@property (nonatomic, retain) NSDictionary * shanxi_xi_an;

@property (nonatomic, retain) NSDictionary * provinceNames;
@property (nonatomic, retain) NSDictionary * provinceData;

@end



static SinaCityCode *sharedInstance;

@implementation SinaCityCode

@synthesize shanxi_xi_an;
@synthesize xizang;
@synthesize yunnan;
@synthesize zhejiang;
@synthesize ningxia;
@synthesize shandong;
@synthesize jiangsu;
@synthesize jiangxi;
@synthesize shanxi;
@synthesize qinghai;
@synthesize jilin;
@synthesize liaoning;
@synthesize xinjiang;
@synthesize hainan;

@synthesize anhui;
@synthesize fujian;
@synthesize gansu;
@synthesize guangdong;
@synthesize guangxi;
@synthesize hubei;
@synthesize hunan;
@synthesize hebei;
@synthesize henan;
@synthesize guizhou;
@synthesize hannan;
@synthesize heilongjiang;
@synthesize neimenggu;
@synthesize provinceNames;
@synthesize provinceData;

@synthesize sichuan;
@synthesize guowai;

+ (SinaCityCode*) sharedInstance {
    @synchronized([SinaCityCode class]) {
        if (!sharedInstance) {
            sharedInstance = [[SinaCityCode alloc] init];
        }
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.anhui = [NSDictionary dictionaryWithObjectsAndKeys:
            @"合肥",@"1",
            @"芜湖",@"2",
            @"蚌埠",@"3",
            @"淮南",@"4",
            @"马鞍山",@"5",
            @"淮北",@"6",
            @"铜陵",@"7",
            @"安庆",@"8",
            @"黄山",@"10",
            @"滁州",@"11",
            @"阜阳",@"12",
            @"宿州",@"13",
            @"巢湖",@"14",
            @"六安",@"15",
            @"亳州",@"16",
            @"池州",@"17",
            @"宣城",@"18",
            nil
        ];
        
        self.fujian = [NSDictionary dictionaryWithObjectsAndKeys:
            @"福州",@"1",
            @"厦门",@"2",
            @"莆田",@"3",
            @"三明",@"4",
            @"泉州",@"5",
            @"漳州",@"6",
            @"南平",@"7",
            @"龙岩",@"8",
            @"宁德",@"9",
                    nil
        ];
        
        self.gansu = [NSDictionary dictionaryWithObjectsAndKeys:
            @"兰州",@"1",
            @"嘉峪关",@"2",
            @"金昌",@"3",
            @"白银",@"4",
            @"天水",@"5",
            @"武威",@"6",
            @"张掖",@"7",
            @"平凉",@"8",
            @"酒泉",@"9",
            @"庆阳",@"10",
            @"定西",@"24",
            @"陇南",@"26",
            @"临夏",@"29",
            @"甘南",@"30",
            nil
        ];
        
       self.guangdong = [NSDictionary dictionaryWithObjectsAndKeys:
            @"广州",@"1",
            @"韶关",@"2",
            @"深圳",@"3",
            @"珠海",@"4",
            @"汕头",@"5",
            @"佛山",@"6",
            @"江门",@"7",
            @"湛江",@"8",
            @"茂名",@"9",
            @"肇庆",@"12",
            @"惠州",@"13",
            @"梅州",@"14",
            @"汕尾",@"15",
            @"河源",@"16",
            @"阳江",@"17",
            @"清远",@"18",
            @"东莞",@"19",
            @"中山",@"20",
            @"潮州",@"51",
            @"揭阳",@"52",
            @"云浮",@"53",
            nil
        ];
        
        self.guizhou = [NSDictionary dictionaryWithObjectsAndKeys:
            @"贵阳",@"1",
            @"六盘水",@"2",
            @"遵义",@"3",
            @"安顺",@"4",
            @"铜仁",@"22",
            @"黔西南",@"23",
            @"毕节",@"24",
            @"黔东南",@"26",
            @"黔南",@"27",
            nil
        ];
        
        self.guangxi = [NSDictionary dictionaryWithObjectsAndKeys:
            @"南宁",@"1",
            @"柳州",@"2",
            @"桂林",@"3",
            @"梧州",@"4",
            @"北海",@"5",
            @"防城港",@"6",
            @"钦州",@"7",
            @"贵港",@"8",
            @"玉林",@"9",
            @"百色",@"10",
            @"贺州",@"11",
            @"河池",@"12",
            @"南宁",@"21",
            @"柳州",@"22",
            nil
                   ];
        
        self.hainan = [NSDictionary dictionaryWithObjectsAndKeys:
            @"海口",@"1",
            @"三亚",@"2",
            @"其他",@"90",
            nil
        ];
        
        self.hebei = [NSDictionary dictionaryWithObjectsAndKeys:
            @"石家庄",@"1",
            @"唐山",@"2",
            @"秦皇岛",@"3",
            @"邯郸",@"4",
            @"邢台",@"5",
            @"保定",@"6",
            @"张家口",@"7",
            @"承德",@"8",
            @"沧州",@"9",
            @"廊坊",@"10",
            @"衡水",@"11",
            nil
        ];
        
        self.heilongjiang = [NSDictionary dictionaryWithObjectsAndKeys:
            @"哈尔滨",@"1",
            @"吉吉哈尔",@"2",
            @"鸡西",@"3",
            @"鹤岗",@"4",
            @"双鸭山",@"5",
            @"大庆",@"6",
            @"伊春",@"7",
            @"佳木斯",@"8",
            @"七台河",@"9",
            @"牡丹江",@"10",
            @"黑河",@"11",
            @"绥化",@"12",
            @"大兴安岭",@"27",
            nil
        ];
        
        self.henan = [NSDictionary dictionaryWithObjectsAndKeys:
            @"郑州",@"1",
            @"开封",@"2",
            @"洛阳",@"3",
            @"平顶山",@"4",
            @"安阳",@"5",
            @"鹤壁",@"6",
            @"新乡",@"7",
            @"焦作",@"8",
            @"濮阳",@"9",
            @"许昌",@"10",
            @"漯河",@"11",
            @"三门峡",@"12",
            @"南阳",@"13",
            @"商丘",@"14",
            @"信阳",@"15",
            @"周口",@"16",
            @"驻马店",@"17",
                                 nil
        ];
        
       self.neimenggu = [NSDictionary dictionaryWithObjectsAndKeys:
            @"呼和浩特",@"1",
            @"包头",@"2",
            @"乌海",@"3",
            @"赤峰",@"4",
            @"通辽",@"5",
            @"鄂尔多斯",@"6",
            @"呼伦贝尔",@"7",
            @"兴安盟",@"22",
            @"锡林郭勒盟",@"25",
            @"乌兰察布盟",@"26",
            @"巴彦淖尔盟",@"28",
            @"阿拉善盟",@"29",
            nil
        ];
                                     
      self.jiangsu = [NSDictionary dictionaryWithObjectsAndKeys:
          @"南京",@"1",
          @"无锡",@"2",
          @"徐州",@"3",
          @"常州",@"4",
          @"苏州",@"5",
          @"南通",@"6",
          @"连云港",@"7",
          @"淮安",@"8",
          @"盐城",@"9",
          @"扬州",@"10",
          @"镇江",@"11",
          @"秦州",@"12",
          @"宿迁",@"13",
          nil
          ];
     self.jiangxi = [NSDictionary dictionaryWithObjectsAndKeys:
          @"南昌",@"1",
          @"景德镇",@"2",
          @"萍乡",@"3",
          @"九江",@"4",
          @"新余",@"5",
          @"鹰潭",@"6",
          @"赣州",@"7",
          @"吉安",@"8",
          @"宜春",@"9",
          @"抚州",@"10",
          @"上饶",@"11",
          nil
          ];
    self.jilin = [NSDictionary dictionaryWithObjectsAndKeys:
          @"长春",@"1",
          @"吉林",@"2",
          @"四平",@"3",
          @"辽源",@"4",
          @"通化",@"5",
          @"白山",@"6",
          @"松原",@"7",
          @"白城",@"8",
          @"延边朝鲜族自治州",@"24",
          nil
          ];
    self.liaoning = [NSDictionary dictionaryWithObjectsAndKeys:
            @"沈阳",@"1",
            @"大连",@"2",
            @"鞍山",@"3",
            @"抚顺",@"4",
            @"本溪",@"5",
            @"丹东",@"6",
            @"锦州",@"7",
            @"营口",@"8",
            @"阜新",@"9",
            @"辽阳",@"10",
            @"盘锦",@"11",
            @"铁岭",@"12",
            @"朝阳",@"13",
            @"葫芦岛",@"14",
            nil
            ];
     self.ningxia = [NSDictionary dictionaryWithObjectsAndKeys:
            @"银川",@"1",
            @"石嘴山",@"2",
            @"吴忠",@"3",
            @"固原",@"4",
            nil
            ];
     self.qinghai = [NSDictionary dictionaryWithObjectsAndKeys:
            @"西宁",@"1",
            @"海东",@"21",
            @"海北",@"22",
            @"黄南",@"23",
            @"海南",@"25",
            @"果洛",@"26",
            @"玉树",@"27",
            @"海西",@"28",
            nil
            ];
      self.shanxi = [NSDictionary dictionaryWithObjectsAndKeys:
            @"太原",@"1",
            @"大同",@"2",
            @"阳泉",@"3",
            @"长治",@"4",
            @"晋城",@"5",
            @"朔州",@"6",
            @"晋中",@"7",
            @"运城",@"8",
            @"忻州",@"9",
            @"临汾",@"10",
            @"吕梁",@"23",
            nil
                          ];    
       self.shandong = [NSDictionary dictionaryWithObjectsAndKeys:
            @"济南",@"1",
            @"青岛",@"2",
            @"淄博",@"3",
            @"枣庄",@"4",
            @"东营",@"5",
            @"烟台",@"6",
            @"潍坊",@"7",
            @"济宁",@"8",
            @"泰安",@"9",
            @"威海",@"10",
            @"日照",@"11",
            @"莱芜",@"12",
            @"临沂",@"13",
            @"德州",@"14",
            @"聊城",@"15",
            @"滨州",@"16",
            @"菏泽",@"17",
            nil
            ];
                          
     self.sichuan = [NSDictionary dictionaryWithObjectsAndKeys:
            @"成都",@"1",
            @"自贡",@"3",
            @"攀枝花",@"4",
            @"泸州",@"5",
            @"德阳",@"6",
            @"绵阳",@"7",
            @"广元",@"8",
            @"遂宁",@"9",
            @"内江",@"10",
            @"乐山",@"11",
            @"南充",@"13",
            @"眉山",@"14",
            @"宜宾",@"15",
            @"广安",@"16",
            @"达州",@"17",
            @"雅安",@"18",
            @"巴中",@"19",
             @"资阳",@"20",
             @"阿坝",@"32",
             @"甘孜",@"33",
             @"凉山",@"34",
            nil
            ];
      self.xizang = [NSDictionary dictionaryWithObjectsAndKeys:
            @"拉萨",@"1",
            @"昌都",@"2",
            @"山南",@"3",
            @"日喀则",@"4",
            @"那曲",@"5",
            @"阿里",@"6",
            @"林芝",@"7",
            nil
            ];    
        self.xinjiang = [NSDictionary dictionaryWithObjectsAndKeys:
            @"乌鲁木齐",@"1",
            @"克拉玛依",@"2",
            @"吐鲁番",@"21",
            @"哈密",@"22",
            @"昌吉",@"23",
            @"博尔塔拉",@"27",
            @"巴音郭楞",@"28",
            @"阿克苏",@"29",
            @"克孜勒苏",@"30",
            @"喀什",@"31",
            @"和田",@"32",
            @"伊犁",@"40",
            @"塔城",@"42",
            @"阿勒泰",@"43",
            nil
            ];
       self.yunnan = [NSDictionary dictionaryWithObjectsAndKeys:
            @"昆明",@"1",
            @"曲靖",@"3",
            @"玉溪",@"4",
            @"保山",@"5",
            @"昭通",@"6",
            @"楚雄",@"23",
            @"红河",@"25",
            @"文山",@"26",
            @"思茅",@"27",
            @"西双版纳",@"28",
            @"大理",@"29",
            @"德宏",@"31",
            @"丽江",@"32",
            @"怒江",@"33",
            @"迪庆",@"34",
            @"临沧",@"35",
            nil
            ];    
      self.zhejiang = [NSDictionary dictionaryWithObjectsAndKeys:
            @"杭州",@"1",
            @"宁波",@"2",
            @"温州",@"21",
            @"嘉兴",@"22",
            @"湖州",@"23",
            @"绍兴",@"27",
            @"金华",@"28",
            @"衢州",@"29",
            @"舟山",@"30",
            @"台州",@"31",
            @"丽水",@"32",
            nil
            ];
      self.shanxi_xi_an = [NSDictionary dictionaryWithObjectsAndKeys:
            @"西安",@"1",
            @"铜川",@"2",
            @"宝鸡",@"3",
            @"咸阳",@"4",
            @"渭南",@"5",
            @"延安",@"6",
            @"汉中",@"7",
            @"榆林",@"8",
            @"安康",@"9",
            @"商洛",@"10",
            nil
            ];
        self.hubei = [NSDictionary dictionaryWithObjectsAndKeys:
             @"武汉",@"1",
             @"黄石",@"2",
             @"十堰",@"3",
             @"宜昌",@"5",
             @"襄樊",@"6",
             @"鄂州",@"7",
             @"荆门",@"8",
             @"孝感",@"9",
             @"荆州",@"10",
             @"黄冈",@"11",
              @"咸宁",@"12",
              @"随州",@"13",
              @"恩施土家苗族自治州",@"28",
             nil
             ];
        self.hunan = [NSDictionary dictionaryWithObjectsAndKeys:
              @"长沙",@"1",
              @"株洲",@"2",
              @"湘潭",@"3",
              @"衡阳",@"4",
              @"邵阳",@"5",
              @"岳阳",@"6",
              @"常德",@"7",
              @"张家界",@"8",
              @"益阳",@"9",
              @"郴州",@"10",
              @"永州",@"11",
              @"怀化",@"12",
              @"娄底",@"13",
              @"湘西土家族苗族自治州",@"31",
              nil
              ];
      self.guowai = [NSDictionary dictionaryWithObjectsAndKeys:
            @"美国",@"1",
            @"英国",@"2",
            @"法国",@"3",
            @"俄罗斯",@"4",
            @"加拿大",@"5",
            @"巴西",@"6",
            @"澳大利亚",@"7",
            @"印尼",@"8",
            @"泰国",@"9",
            @"马来西亚",@"10",
            @"新加坡",@"5",
            @"菲律宾",@"6",
            @"越南",@"7",
            @"印度",@"8",
            @"日本",@"9",
            @"其他",@"10",
            nil
            ];
        self.provinceNames = [NSDictionary dictionaryWithObjectsAndKeys:
          @"安徽",@"34",
          @"北京",@"11",
          @"重庆",@"50",
          @"福建",@"35",
          @"甘肃",@"62",
          @"广东",@"44",
          @"广西",@"45",
          @"贵州",@"52",
          @"海南",@"46",
          @"河北",@"13",
          @"黑龙江",@"23",
          @"河南",@"41",
          @"湖北",@"42",
          @"湖南",@"43",
          @"内蒙古",@"15",
          @"江苏",@"32",
          @"江西",@"36",
          @"吉林",@"22",
          @"辽宁",@"21",
          @"宁夏",@"64",
          @"青海",@"63",
          @"山西",@"14",
          @"山东",@"37",
          @"山西",@"14",
          @"山东",@"37",
         @"上海",@"31",
         @"四川",@"51",
         @"天津",@"12",
         @"西藏",@"54",
         @"新疆",@"65",
         @"云南",@"53",
         @"浙江",@"33",
         @"陕西",@"61",
         @"台湾",@"71",
         @"香港",@"81",
         @"澳门",@"82",
         @"海外",@"400",
         @"其他",@"100",
          nil
          ];
        self.provinceData = [NSDictionary dictionaryWithObjectsAndKeys:
         anhui,@"34",
         [NSDictionary dictionaryWithDictionary:nil],@"11",
         [NSDictionary dictionaryWithDictionary:nil],@"50",
         fujian,@"35",
         gansu,@"62",
         guangdong,@"44",
         guangxi,@"45",
         guizhou,@"52",
         hainan,@"46",
         hebei,@"13",
         heilongjiang,@"23",
         henan,@"41",
         hubei,@"42",
         hunan,@"43",
         neimenggu,@"15",
         jiangsu,@"32",
         jiangxi,@"36",
         jilin,@"22",
         liaoning,@"21",
         ningxia,@"64",
         qinghai,@"63",
         shanxi,@"14",
         shandong,@"37",
         shanxi,@"14",
         shandong,@"37",
         [NSDictionary dictionaryWithDictionary:nil],@"31",
         sichuan,@"51",
         [NSDictionary dictionaryWithDictionary:nil],@"12",
         xizang,@"54",
         xinjiang,@"65",
         yunnan,@"53",
         zhejiang,@"33",
         shanxi_xi_an,@"61",
         [NSDictionary dictionaryWithDictionary:nil],@"71",
         [NSDictionary dictionaryWithDictionary:nil],@"81",
         [NSDictionary dictionaryWithDictionary:nil],@"82",
         guowai,@"400",
         [NSDictionary dictionaryWithDictionary:nil],@"100",
         nil
         ];  
    }
    
    [self getCityNameByProvinceCode:@"61" andCityCode:@"5"];
    
    return self;
}


-(NSString*)getProvinceNameByCode:(NSString*)code
{
    return [self.provinceNames objectForKey:code];
}

-(NSString*)getCityNameByProvinceCode:(NSString*)provinceCode andCityCode:(NSString*)cityCode
{
    NSLog(@"pro:%@", provinceCode);
    NSLog(@"city:%@", cityCode);
    NSLog(@"city:%@", self.provinceData);
    
    NSDictionary * province = [self.provinceData objectForKey:provinceCode];
    NSLog(@"prodata:%@", province);   
    if (nil == province) {
        return [provinceNames objectForKey:provinceCode];
    }
    else
    {
        return [province objectForKey:cityCode];
    }
}

@end
