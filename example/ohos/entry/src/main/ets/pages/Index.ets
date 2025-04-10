/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import common from '@ohos.app.ability.common';
import { FlutterPage } from '@ohos/flutter_ohos'
import { AppLog } from '@volcengine/applog';
import { DevTools } from '@volcengine/applog_devtools'
import DevToolsPage from './devtools_130'

let storage = LocalStorage.getShared()
const EVENT_BACK_PRESS = 'EVENT_BACK_PRESS'

@Entry(storage)
@Component
struct Index {
  private context = getContext(this) as common.UIAbilityContext
  @LocalStorageLink('viewId') viewId: string = "";
  @State sdkInitted: boolean = false
  @State hasDevtoolsPage: boolean = false

  build() {
    Column() {
      FlutterPage({ viewId: this.viewId })
      if (this.sdkInitted && this.hasDevtoolsPage) {
        DevToolsPage()
      }
    }
  }

  onDidBuild(): void {
    globalThis.MainUIAbilityContext = this.context
    globalThis.initCallback = (appLogInstance: AppLog) => {
      DevTools.applyDevTools(appLogInstance, {
        trackEnabled: false
      })
      import('@volcengine/applog_devtools').then((ns: ESObject) => {
        const defaultExport: Function = ns.default
        if (defaultExport?.name === 'MainPage') {
          this.hasDevtoolsPage = true
        }
      })
      DevTools['show'] && DevTools['show'](this.context.windowStage)
      this.sdkInitted = true
    }
  }

  onBackPress(): boolean {
    this.context.eventHub.emit(EVENT_BACK_PRESS)
    return true
  }
}