# LED Scroller Flutter專案

## 專案概述
- **專案名稱**: LED Scroller
- **功能概念**: LED滾動顯示 + 筆記本功能
- **UI主題**: Dark Theme
- **目標平台**: iOS (iPhone 13 & 14 - 17)

## 應用程式流程與功能規格

### 1. 首頁/列表頁
- 頁面標題: "My Scroller Record"
- 功能按鈕:
    - "Create New": 創建新的滾動文字
    - "Create Group": 創建文字組
- 列表顯示:
    - 所有已創建的滾動文字，以卡片形式展示
    - 顯示背景顏色和文字顏色
    - 卡片顯示文字內容摘要(超出部分會省略)
    - 點擊卡片可進入跑馬燈頁面
    - 左滑卡片可顯示"Delete"刪除選項
    - 群組會以群組icon顯示

### 2. 跑馬燈頁
- 全屏顯示滾動文字效果
- 文字垂直方向顯示(從上到下或從下到上)
- 點擊螢幕可顯示更多功能
- 左上角有返回列表頁按鈕
- 右下角有編輯按鈕

### 3. 編輯功能頁
- 背景即時預覽編輯效果
- UI分為兩個主要標籤: Style 和 Effect
- 編輯選項:
    - **文字編輯**: 可輸入最多100字
    - **Style標籤下**:
        - **字體大小(Size)**: 可選擇20, 40, 60, 80, 100或使用滑桿調整
        - **字體選擇(Fonts)**: 提供多種字體選項如Verdana等
        - **文字顏色(Text Color)**: 完整的顏色選擇器，包含預設顏色與自定義色彩
        - **背景顏色(Background Color)**: 可設置文字背景顏色
    - **Effect標籤下**:
        - **滾動方向(Direction)**: 四個方向按鈕(左、右、上、下)
        - **滾動速度(Speed)**: 滑桿調整，範圍1-10，預設值為5
        - **特效選項**: 可應用不同的顯示效果
    - **底部按鈕**:
        - **View Full Screen**: 全屏預覽效果
        - **Save**: 儲存編輯並返回
- 文字預覽區會顯示實際效果(水平或垂直方向)

### 4. 群組功能
- 可選擇多個已創建的跑馬燈進行分組
- 群組頁面提供:
    - 選擇要加入群組的項目
    - 排序功能(可拖動調整順序)
    - 重複播放設定:
        - 重複次數(1-10)
        - 永久循環選項(Repeat Forever開關)
    - 當永久循環開啟時，重複次數功能會被禁用
    - "Save and Review"按鈕確認設定

### 5. 群組預覽與管理
- 群組內項目以列表形式顯示
- 每個項目右側顯示順序號碼
- 可編輯群組內容
- 群組在列表頁的顯示特殊icon以區分

## UI設計與互動
- 整體使用深色主題(Dark Theme)
- 採用類似LED網格點陣的視覺風格，顯示效果模擬真實LED跑馬燈
- 每個跑馬燈可設置獨特的樣式:
    - 字體大小選項: 20, 40, 60, 80, 100
    - 多種字體選擇，包含各種風格字體如Pathway Gothic One, Parisienne等
    - 完整的顏色選擇器，支援顏色漸層
- 支援多種顯示效果:
    - 水平捲動(左右)
    - 垂直捲動(上下)
    - 支援兩種文字預覽區塊(Section 1為編輯界面，Section 2為垂直預覽區)
- 使用者介面風格統一，主色調為紫色系
- Style UI Kit設計規範清晰，支援組件與變體

## 特殊功能
- 預覽功能: 可全屏預覽效果，支援即時展示滾動效果(LED網格感呈現)
- 預覽模式: 可選擇不同的預覽效果呈現方式
- 點擊畫面可在任一位置顯示編輯選項
- 組件與變體: 可保存不同樣式設定
- 多選與批量刪除: 可同時選擇多個跑馬燈進行刪除
- 錯誤處理: 當資料路徑遺失時提供適當錯誤提示

## 技術架構
- **框架**: Flutter
- **狀態管理**: Riverpod
- **路由管理**: GoRouter
- **資料持久化**: SharedPreferences
- **資料模型**:
    - `Scroller`: 跑馬燈基本模型，包含文字、樣式、動畫設定
    - `ScrollerGroup`: 群組模型，管理多個Scroller的排序和重複播放

## 專案進度

### 已完成的部分 [2025-03-04 15:42:30]
- Riverpod 狀態管理層設定完成
- 首頁 (顯示所有 Scroller 列表)
- Scroller 卡片組件 (支援預覽和左滑刪除)
- 建立/編輯 Scroller 頁面 (包含樣式和效果設定)
- 顏色選擇器組件
- 預覽頁面 (支援垂直和水平顯示)
- 群組創建頁面 (支援多選、排序和重複設定)
- 路由配置