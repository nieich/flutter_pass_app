// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get title => '通行证';

  @override
  String get ok => '好的';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get share => '分享';

  @override
  String get addPassFromFile => '从文件添加通行证';

  @override
  String pickedFile(String fileName) {
    return '已选择文件：$fileName';
  }

  @override
  String get invalidFileType => '无效的文件类型。请选择一个 .pkpass 文件。';

  @override
  String get sharingPass => '分享通行证';

  @override
  String get noPasses => '没有通行证';

  @override
  String get passParseError => '解析通行证时出错';

  @override
  String get settings => '设置';

  @override
  String get theme => '主题';

  @override
  String get themeColor => '主题颜色';

  @override
  String get themeColorDescription => '为应用选择一个主题颜色';

  @override
  String get themeMode => '主题模式';

  @override
  String get systemTheme => '系统';

  @override
  String get lightTheme => '浅色';

  @override
  String get darkTheme => '深色';

  @override
  String get colorMode => '颜色模式';

  @override
  String get colorModeSystem => '系统颜色';

  @override
  String get colorModeSystemDescription => '使用系统颜色';

  @override
  String get colorModeSeed => '种子颜色';

  @override
  String get colorModeIndividual => '自定义颜色';

  @override
  String get individualColorMode => '自定义颜色模式';

  @override
  String get individualColorModeDescription => '为应用中的每个元素选择自定义颜色。';

  @override
  String get primaryColor => '主色';

  @override
  String get onPrimaryColor => '主色上的颜色';

  @override
  String get secondaryColor => '次要颜色';

  @override
  String get onSecondaryColor => '次要颜色上的颜色';

  @override
  String get surfaceColor => '表面颜色';

  @override
  String get onSurfaceColor => '表面颜色上的颜色';

  @override
  String get errorColor => '错误颜色';

  @override
  String get onErrorColor => '错误颜色上的颜色';

  @override
  String get passDoesNotSupportUpdates => '此通行证不支持更新。';

  @override
  String get passUpdateFailedOrNoUpdateAvailable => '通行证更新失败或没有可用更新。';

  @override
  String get deletePass => '删除通行证';

  @override
  String get deletePassConfirmation => '您确定要删除此通行证吗？此操作无法撤销。';

  @override
  String get general => '通用';

  @override
  String get generalSettingsDesc => '通用设置';

  @override
  String get themeSettingsDesc => '设置主题和颜色';

  @override
  String get dev => '开发';

  @override
  String get devSettingsDesc => '开发设置';

  @override
  String get settingsSaved => '设置已保存';

  @override
  String get passRefresh => '刷新通行证';

  @override
  String get activate => '激活';

  @override
  String get passRefreshHintText => '通行证刷新间隔（分钟）';

  @override
  String get devLogs => '开发者日志';

  @override
  String get clearLogs => '清除日志';

  @override
  String get shareLogs => '分享日志';

  @override
  String get appLogs => '应用日志';

  @override
  String get noLogsToShare => '没有可分享的日志';

  @override
  String get noLogsRecordedYet => '尚无日志记录';

  @override
  String get invalidBoardingPassData => '无效的登机牌数据';

  @override
  String get invalidEventTicketData => '无效的活动门票数据';
}
