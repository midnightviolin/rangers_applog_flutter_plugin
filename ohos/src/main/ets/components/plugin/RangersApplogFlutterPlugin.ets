import { FlutterPlugin, MethodCall, MethodChannel } from '@ohos/flutter_ohos'
import { FlutterPluginBinding } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin'
import { MethodCallHandler, MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel'
import common from '@ohos.app.ability.common'
import { AppLog, HeaderValue, InitConfig, Topic ,createByDomain} from '@volcengine/applog'

export default class RangersAppLogFlutterPlugin implements FlutterPlugin {
  getUniqueClassName(): string {
    return "rangers_applog_flutter_plugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    let channel: MethodChannel = new MethodChannel(binding.getBinaryMessenger(), "rangers_applog_flutter_plugin")
    channel.setMethodCallHandler(new AppLogMethodCallHandler(binding.getApplicationContext()))
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {

  }
}

const TAG: string = "RangersApplogFlutter"
const FlutterPluginMethodInitRangersAppLog: string = "initRangersAppLog"
const FlutterPluginMethodStart = "start"
const FlutterPluginMethodGetDeviceId: string = "getDeviceId"
const FlutterPluginMethodGetAbSdkVersion: string = "getAbSdkVersion"
const FlutterPluginMethodGetABTestConfigValueForKey: string = "getABTestConfigValueForKey"
const FlutterPluginMethodOnEventV3: string = "onEventV3"
const FlutterPluginMethodSetUserUniqueId: string = "setUserUniqueId"
const FlutterPluginMethodSetHeaderInfo: string = "setHeaderInfo"
const FlutterPluginMethodProfileSet: string = "profileSet"
const FlutterPluginMethodProfileSetOnce: string = "profileSetOnce"
const FlutterPluginMethodProfileAppend: string = "profileAppend"
const FlutterPluginMethodProfileIncrement: string = "profileIncrement"
const FlutterPluginMethodProfileUnset: string = "profileUnSet"
const FlutterPluginMethodGetAllAbTestConfig: string = "getAllAbTestConfig"
const FlutterPluginMethodRemoveHeaderInfo: string = "removeHeaderInfo"

class AppLogMethodCallHandler implements MethodCallHandler {
  context: common.Context
  appLogInstance = new AppLog()

  constructor(context: common.Context) {
    this.context = context
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case FlutterPluginMethodInitRangersAppLog:
        const initConfig = new InitConfig(call.argument("appid"), call.hasArgument("channel") ? call.argument("channel") : "")
                                     .setLogEnabled(call.hasArgument("enable_log") ? call.argument("enable_log") : false)
         if (call.hasArgument("host") && call.argument("host")) {
             initConfig.setUri(createByDomain(call.argument("host")))
         }

        this.appLogInstance.init(this.context,initConfig)

        if (call.hasArgument("enable_ab") && call.argument("enable_ab")) {
          this.appLogInstance.abTest()?.enablePlugin()
        }
        if (call.hasArgument("enable_encrypt") && call.argument("enable_encrypt") === false) {
          this.appLogInstance.encrypt()?.disablePlugin()
        }
        globalThis.initCallback && globalThis.initCallback(this.appLogInstance)
        if(call.argument("auto_start") === true){
         this.appLogInstance.start()
        }
        break
      case FlutterPluginMethodStart:
        this.appLogInstance.start()
        break
      case FlutterPluginMethodGetDeviceId:
        this.appLogInstance.topicReceiver()?.stickyOn(Topic.DidReady, (didInfo) => {
          result.success(didInfo["bd_did"])
        })
        break
      case FlutterPluginMethodGetAbSdkVersion:
        result.success(this.appLogInstance.abTest()?.getAbSdkVersion())
        break
      case FlutterPluginMethodGetABTestConfigValueForKey:
        result.success(this.appLogInstance.abTest()?.getAbSdkVersion())
        break
      case FlutterPluginMethodOnEventV3:
        this.appLogInstance.event(call.argument("event"), mapToRecord(call.argument("param")))
        break
      case FlutterPluginMethodSetUserUniqueId:
        this.appLogInstance.user()?.setUserUniqueID(call.argument("uuid"))
        break
      case FlutterPluginMethodSetHeaderInfo:
        break
      case FlutterPluginMethodProfileSet:
        this.appLogInstance.profile()?.set(mapToRecord(call.argument("profileDict")))
        break
      case FlutterPluginMethodProfileSetOnce:
        this.appLogInstance.profile()?.setOnce(mapToRecord(call.argument("profileDict")))
        break
      case FlutterPluginMethodProfileAppend:
        this.appLogInstance.profile()?.append(mapToRecord(call.argument("profileDict")))
        break
      case FlutterPluginMethodProfileIncrement:
        this.appLogInstance.profile()?.increment(mapToRecord(call.argument("profileDict")))
        break
      case FlutterPluginMethodProfileUnset:
        this.appLogInstance.profile()?.unset(call.argument("key"))
        break
      case FlutterPluginMethodGetAllAbTestConfig:
        break
      case FlutterPluginMethodRemoveHeaderInfo:
        break
      case 'toast':
        //测试用，请勿使用
        if(globalThis.MainUIAbilityContext){
            const win = (globalThis.MainUIAbilityContext as common.UIAbilityContext).windowStage.getMainWindowSync()
            const uiContext = win.getUIContext()
            uiContext.getPromptAction().showToast({message:call.argument("message")})
        }
        break
    }
  }
}

export function mapToRecord<V = HeaderValue>(header: Map<string, V>): Record<string, V> {
  let headerRecord: Record<string, V> = {}
  header.forEach((value, key) => {
    headerRecord[key] = value
  })
  return headerRecord
}
