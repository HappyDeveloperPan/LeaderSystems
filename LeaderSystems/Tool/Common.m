//
//  Common.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/11/2.
//  Copyright © 2016年 panpan. All rights reserved.
//

#import "Common.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Common

const double a = 6378245.0;
const double ee = 0.00669342162296594323;
const double pi = 3.14159265358979324;

static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

#pragma 数据持久化
+ (void)setAsynchronous:(id)object WithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearAsynchronousWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getAsynchronousWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+(CGSize)sizeWithString:(NSString *)string width:(float)width font:(float)font{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    
    CGRect detailsSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                          
                                              options:NSStringDrawingUsesLineFragmentOrigin
                          
                                           attributes:attributes
                          
                                              context:nil];
    
    return detailsSize.size;
}

#pragma mark 共通说明Label
+(UILabel *)labelExplainedWithFrame:(CGRect)frame
{
    UILabel *explainLabel = [[UILabel alloc] initWithFrame:frame];
    explainLabel.backgroundColor = [UIColor clearColor];
    [explainLabel setFont:[UIFont systemFontOfSize:13]];
    explainLabel.textColor = kColorMajor;
    explainLabel.numberOfLines = 4;
    return explainLabel;
}

#pragma 字符串遍历
+ (CGFloat)content:(NSString *)s {
    int i;CGFloat n=[s length],l=0,a=0,b=0;
    CGFloat wLen=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];//按顺序取出单个字符
        if(isblank(c)){//判断字符串为空或为空格
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
        wLen=l+b+(CGFloat)((CGFloat)a/4.0);
        NSLog(@"wLen--%f",wLen);
    }
    if(a==0 && l==0)
    {
        return 0;//只有isblank
    }
    else{
        return wLen;//长度，中文占1，英文等能转ascii的占0.25
    }
}

#pragma mark 线的图片
+(UIImageView *)lineViewWithFrame:(CGRect)frame
{
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:frame];
    lineImageView.backgroundColor = kColorLine;
    return lineImageView;
}

#pragma mark 手机号判断方法
+ (BOOL)judgeMobileNumber:(NSString *)mobileNum{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[01678]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

+ (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}

+ (void)addBackItemToVC:(UIViewController *)vc{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setImage:[UIImage imageNamed:@"返回_默认"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"返回_按下"] forState:UIControlStateHighlighted];
    
    //把视图的边角变为圆形, cornerRadius圆角半径
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    //弹簧控件, 修复边距
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -15;
    vc.navigationItem.leftBarButtonItems = @[spaceItem,backItem];
}

+(UIBarButtonItem *)noTitlebackBtnWithTarget:(id)target selector:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 14, 25)];
    [btn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    //    [btn setImage:[UIImage imageNamed:@"left_btn"] forState:UIControlStateHighlighted];
    [btn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn setTitle:@"　　" forState:UIControlStateNormal];
    [btn setTitleShadowColor:[UIColor colorWithWhite:1 alpha:.5] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 0)];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
//控件的快捷生成
+ (UIButton *)addBtnWithImage:(NSString *)imageName {
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode : UIImageRenderingModeAlwaysOriginal];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    return button;
}


+ (UIView *)addViewWithFrame :(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = kColorWhite;
    view.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    view.layer.shadowRadius = 2;//阴影半径，默认3
    view.layer.cornerRadius = 5;
    return view;
}

+ (UILabel *)badgeNumLabWithFrame:(CGRect)frame
{
    UILabel *badgeNumLab = [[UILabel alloc] initWithFrame:frame];
    badgeNumLab.backgroundColor = RGBColor(247, 62, 67);
    badgeNumLab.font = [UIFont systemFontOfSize:12];
    badgeNumLab.layer.cornerRadius = 5;
    badgeNumLab.clipsToBounds = YES;
    badgeNumLab.textAlignment = NSTextAlignmentCenter;
    badgeNumLab.textColor = [UIColor whiteColor];
    badgeNumLab.hidden = YES;
    return badgeNumLab;
}

+(NSString *)formatWithDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

+(BOOL)isSameDayWithDate:(NSString *)dateStr {
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currStr = [formatter stringFromDate:currDate];
    
    NSDate *date = [formatter dateFromString:dateStr];
    NSString *tranStr = [formatter stringFromDate:date];
    
    if ([currStr isEqualToString:tranStr]) {
        return YES;
    }
    return NO;
}

+ (void)layoutBadge:(UILabel *)badgeLab andCount:(NSInteger)count
{
    if (count > 0) {
        badgeLab.hidden = NO;
        badgeLab.text = [NSString stringWithFormat:@"%ld",count];
        if (count > 10) {
            badgeLab.width = 26;
        }else{
            badgeLab.width = 20;
        }
    }else{
        badgeLab.hidden = YES;
    }
}

+(void)setUpNavBar:(UINavigationBar *)navigationBar {
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = [[UIImage alloc] init];
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc {
    CLLocationCoordinate2D adjustLoc;
    double adjustLat = [self transformLatWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
    double adjustLon = [self transformLonWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
    double radLat = wgsLoc.latitude / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    adjustLoc.latitude = wgsLoc.latitude + adjustLat;
    adjustLoc.longitude = wgsLoc.longitude + adjustLon;
    return adjustLoc;
    
    
}

+(double)transformLatWithX:(double)x withY:(double)y
{
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    lat += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * pi) + 3320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return lat;
}

+(double)transformLonWithX:(double)x withY:(double)y
{
    double lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return lon;
}

+ (NSData *)dictionnaryObjectToString:(NSDictionary *)dic {
    NSString *parametersString = @"";
    for (NSString *key in [dic allKeys]) {
        parametersString = [parametersString stringByAppendingFormat:@"%@=%@&",key,dic[key]];
    }
    NSLog(@"parameter string:\n %@",parametersString);
    NSLog(@"parameters:\n %@",dic);
    
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    
    if (err) {
        return nil;
    }
    return data;
}

+ (NSAttributedString *)colorTextWithString:(NSString *)string andRange:(NSString *)range andColor:(UIColor *)color {
    NSString *str = string;
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attriStr addAttributes:@{NSForegroundColorAttributeName:color} range:[str rangeOfString:range]];
    return attriStr;
}

#pragma mark -崩溃日志发送邮件给开发者
+(void)catchEexceptionMailToDeveloperWithNSException:(NSException *)exception{
    
    /** 获取异常崩溃信息 **/
    NSArray* callStack = [exception callStackSymbols];
    //NSLog(@"%s,%s,%d",__FUNCTION__,__FILE__,__LINE__);
    
    NSString* reason = [exception reason];
    NSString* name = [exception name];
    NSString *osSystemVersion = [[UIDevice currentDevice] systemVersion];
    NSString* content =
    [NSString stringWithFormat:@"======异常错误报告======\nname:\n%@\nreason:"
     @"\n%@\n\n\nosSystemVersion:%@\n\ncallStackSymbols:\n%@\n",
     name, reason,osSystemVersion,
     [callStack componentsJoinedByString:@"\n"]];
    //Application received signal SIGABRT
    //Application received signal SIGSEGV
    /** 把异常崩溃信息发送至开发者邮件 **/
    NSMutableString* mailUrl = [NSMutableString string];
    [mailUrl appendString:@"mailTo:aa943147350@163.com"];
    
    [mailUrl
     appendString:
     @"?subject=程序异常崩溃, 请配合发送异常报告, 我们会尽快解决, 谢谢!"];
    [mailUrl appendFormat:@"&body=%@",content];
    
    /** 打开地址 **/
    NSString* mailPath =
    [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];
}

/*************************RSA加密**********************************/

//加密
+ (NSString *)encryptString:(NSString *)str publicKeyWithContentsOfFile:(NSString *)path{
    if (!str || !path)  return nil;
    return [self encryptString:str publicKeyRef:[self getPublicKeyRefWithContentsOfFile:path]];
}

//获取公钥
+ (SecKeyRef)getPublicKeyRefWithContentsOfFile:(NSString *)filePath{
    NSData *certData = [NSData dataWithContentsOfFile:filePath];
    if (!certData) {
        return nil;
    }
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (CFDataRef)certData);
    SecKeyRef key = NULL;
    SecTrustRef trust = NULL;
    SecPolicyRef policy = NULL;
    if (cert != NULL) {
        policy = SecPolicyCreateBasicX509();
        if (policy) {
            if (SecTrustCreateWithCertificates((CFTypeRef)cert, policy, &trust) == noErr) {
                SecTrustResultType result;
                if (SecTrustEvaluate(trust, &result) == noErr) {
                    key = SecTrustCopyPublicKey(trust);
                }
            }
        }
    }
    if (policy) CFRelease(policy);
    if (trust) CFRelease(trust);
    if (cert) CFRelease(cert);
    return key;
}

+ (NSString *)encryptString:(NSString *)str publicKeyRef:(SecKeyRef)publicKeyRef{
    if(![str dataUsingEncoding:NSUTF8StringEncoding]){
        return nil;
    }
    if(!publicKeyRef){
        return nil;
    }
    NSData *data = [self encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] withKeyRef:publicKeyRef];
    NSString *ret = base64_encode_data(data);
    return ret;
}

#pragma mark - 使用'.12'私钥文件解密

//解密
+ (NSString *)decryptString:(NSString *)str privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password{
    if (!str || !path) return nil;
    if (!password) password = @"";
    return [self decryptString:str privateKeyRef:[self getPrivateKeyRefWithContentsOfFile:path password:password]];
}

//获取私钥
+ (SecKeyRef)getPrivateKeyRefWithContentsOfFile:(NSString *)filePath password:(NSString*)password{
    
    NSData *p12Data = [NSData dataWithContentsOfFile:filePath];
    if (!p12Data) {
        return nil;
    }
    SecKeyRef privateKeyRef = NULL;
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    [options setObject: password forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data, (__bridge CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    
    return privateKeyRef;
}

+ (NSString *)decryptString:(NSString *)str privateKeyRef:(SecKeyRef)privKeyRef{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (!privKeyRef) {
        return nil;
    }
    data = [self decryptData:data withKeyRef:privKeyRef];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

#pragma mark - 使用公钥字符串加密

/* START: Encryption with RSA public key */

//使用公钥字符串加密
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey{
    NSData *data = [self encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] publicKey:pubKey];
    NSString *ret = base64_encode_data(data);
    return ret;
}

+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey{
    if(!data || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [self addPublicKey:pubKey];
    if(!keyRef){
        return nil;
    }
    return [self encryptData:data withKeyRef:keyRef];
}

+ (SecKeyRef)addPublicKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return ([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

/* END: Encryption with RSA public key */

#pragma mark - 使用私钥字符串解密

/* START: Decryption with RSA private key */

//使用私钥字符串解密
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey{
    if (!str) return nil;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self decryptData:data privateKey:privKey];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey{
    if(!data || !privKey){
        return nil;
    }
    SecKeyRef keyRef = [self addPrivateKey:privKey];
    if(!keyRef){
        return nil;
    }
    return [self decryptData:data withKeyRef:keyRef];
}

+ (SecKeyRef)addPrivateKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPrivateKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PrivKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
    [privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKey);
    
    // Add persistent version of the key to system keychain
    [privateKey setObject:data forKey:(__bridge id)kSecValueData];
    [privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)
     kSecAttrKeyClass];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

+ (NSData *)stripPrivateKeyHeader:(NSData *)d_key{
    // Skip ASN.1 private key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 22; //magic byte at offset 22
    
    if (0x04 != c_key[idx++]) return nil;
    
    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det) {
        c_len = c_len & 0x7f;
    } else {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }
    
    // Now make a new NSData from this buffer
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}

+ (NSData *)decryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if ( outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            
            [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}


//- (NSData *)UTF8Data {
//    //保存结果
//    NSMutableData *resData = [[NSMutableData alloc] initWithCapacity:self.length];
//    
//    NSData *replacement = [@"�" dataUsingEncoding:NSUTF8StringEncoding];
//    
//    uint64_t index = 0;
//    const uint8_t *bytes = self.bytes;
//    
//    long dataLength = (long) self.length;
//    
//    while (index < dataLength) {
//        uint8_t len = 0;
//        uint8_t firstChar = bytes[index];
//        
//        // 1个字节
//        if ((firstChar & 0x80) == 0 && (firstChar == 0x09 || firstChar == 0x0A || firstChar == 0x0D || (0x20 <= firstChar && firstChar <= 0x7E))) {
//            len = 1;
//        }
//        // 2字节
//        else if ((firstChar & 0xE0) == 0xC0 && (0xC2 <= firstChar && firstChar <= 0xDF)) {
//            if (index + 1 < dataLength) {
//                uint8_t secondChar = bytes[index + 1];
//                if (0x80 <= secondChar && secondChar <= 0xBF) {
//                    len = 2;
//                }
//            }
//        }
//        // 3字节
//        else if ((firstChar & 0xF0) == 0xE0) {
//            if (index + 2 < dataLength) {
//                uint8_t secondChar = bytes[index + 1];
//                uint8_t thirdChar = bytes[index + 2];
//                
//                if (firstChar == 0xE0 && (0xA0 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
//                    len = 3;
//                } else if (((0xE1 <= firstChar && firstChar <= 0xEC) || firstChar == 0xEE || firstChar == 0xEF) && (0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
//                    len = 3;
//                } else if (firstChar == 0xED && (0x80 <= secondChar && secondChar <= 0x9F) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
//                    len = 3;
//                }
//            }
//        }
//        // 4字节
//        else if ((firstChar & 0xF8) == 0xF0) {
//            if (index + 3 < dataLength) {
//                uint8_t secondChar = bytes[index + 1];
//                uint8_t thirdChar = bytes[index + 2];
//                uint8_t fourthChar = bytes[index + 3];
//                
//                if (firstChar == 0xF0) {
//                    if ((0x90 <= secondChar & secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
//                        len = 4;
//                    }
//                } else if ((0xF1 <= firstChar && firstChar <= 0xF3)) {
//                    if ((0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
//                        len = 4;
//                    }
//                } else if (firstChar == 0xF3) {
//                    if ((0x80 <= secondChar && secondChar <= 0x8F) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
//                        len = 4;
//                    }
//                }
//            }
//        }
//        // 5个字节
//        else if ((firstChar & 0xFC) == 0xF8) {
//            len = 0;
//        }
//        // 6个字节
//        else if ((firstChar & 0xFE) == 0xFC) {
//            len = 0;
//        }
//        
//        if (len == 0) {
//            index++;
//            [resData appendData:replacement];
//        } else {
//            [resData appendBytes:bytes + index length:len];
//            index += len;
//        }
//    }
//    
//    return resData;
//}
#pragma mark - post请求封装
//+ (NSURLSessionDataTask *)postBodyRequestWithPath:(NSString *)path params:(NSDictionary *)params body:(NSDictionary *)body headerDict:(NSDictionary *)header completionHandler:(void(^)(NSDictionary *responseDict, NSError *error))completionHandler {
//    AFHTTPSessionManager *postManager = [AFHTTPSessionManager manager];
//    postManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"text/plain", @"text/json", @"text/javascript", @"application/json"]];
//    
////    NSString *bodyJson = [Tools dictToJsonString:body];
//    NSString *bodyJson;
//    NSData *formData = [bodyJson dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *requestInitErr = nil;
//    NSMutableURLRequest *muRequest = [[postManager requestSerializer] requestWithMethod:@"POST" URLString:path parameters:params error:&requestInitErr];
//    if (!requestInitErr) {
//        id key = nil;
//        NSEnumerator *enu = [header keyEnumerator];
//        while (key = [enu nextObject]) {
//            [muRequest setValue:header[key] forHTTPHeaderField:key];
//        }
//        [muRequest setHTTPBody:formData];
//        NSURLSessionDataTask *task = [postManager dataTaskWithRequest:muRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//            completionHandler(responseObject, error);
//        }];
//        
//        return task;
//    }else {
//        return nil;
//    }
//}
@end
