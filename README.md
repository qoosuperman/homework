# Hahow for Business Backend Engineer 徵才小專案

這是一個小型的徵才專案，需要使用 Ruby on Rails 來開發簡易的 API Server。

同時我們也認為在程式開發的過程中溝通是很重要的，所以如果過程中你有任何問題，不論是看不懂我們所寫的文件，或是需求內容的確認，請用我們是同一個團隊一起合作的模式來進行，在 slack channel 中和我們討論。


## 技術規定
- 必須使用 Ruby on Rails 開發
- 測試必須使用 RSpec
- Ruby 版本使用 2.7.4，Rails 版本使用 6.1，其餘工具的版本以相容的穩定版本為主
- 專案原始碼必須放在 GitHub 上
- 可以使用第三方的 Gem


## 需求
- 請開發一個線上課程的管理後台 API，包含以下功能
  - 課程列表
  - 課程詳細資訊
  - 建立課程
  - 編輯課程
  - 刪除課程
- 請將完成後的 API server 發佈到 Heroku 上
- 完成後的 API 需要有相對應的測試
- 提供一份 README 文件說明
  - 我們該如何執行這個 server
  - 專案的架構，API server 的架構邏輯
  - 你對於使用到的第三方 Gem 的理解，以及他們的功能簡介
  - 你在程式碼中寫註解的原則，遇到什麼狀況會寫註解
  - 當有多種實作方式時，請說明為什麼你會選擇此種方式
  - 在這份專案中你遇到的困難、問題，以及解決的方法

## 需求說明

使用者可以透過線上課程的管理後台，列出、查看、新增、編輯、刪除課程。

每一個「課程」中可以含有多個「章節」，而每一個「章節」中可以含有多個「單元」。

「課程」中需要包含的資訊是：

  - 課程名稱 (必填)
  - 講師名稱 (必填)
  - 課程說明 (非必填)

「章節」中需要包含的資訊是：

  - 章節名稱 (必填)

「單元」中需要包含的資訊是：

  - 單元名稱 (必填)
  - 單元說明 (非必填)
  - 單元內容 (純文字的文章內容) (必填)

### 課程列表
請設計一個 API 提供使用者取得系統中所有「課程」的資訊，其中包含課程中的「章節」資訊和「單元」資訊。

### 課程詳細資訊
請設計一個 API 提供使用者取得指定「課程」的資訊，其中包含課程中的「章節」資訊和「單元」資訊。

### 建立課程
請設計一個 API 提供使用者建立「課程」與課程中的「章節」和「單元」。

- 「課程」、「章節」和「單元」需要同時被建立
- 需要驗證使用者的輸入並在儲存失敗時回傳錯誤訊息
- 需要儲存「章節」和「單元」的順序

### 編輯課程
請設計一個 API 提供使用者編輯「課程」與課程中的「章節」和「單元」。

- 需要驗證使用者的輸入並在儲存失敗時回傳錯誤訊息
- 「章節」和「單元」的順序都可以被調整

### 刪除課程
請設計一個 API 提供使用者刪除指定的「課程」。

- 當「課程」被刪除時，「課程」中的「章節」和「單元」也應該同時被刪除。
- 當「課程」刪除失敗時，需要回傳錯誤訊息


## 加分項目
- 程式的可讀性與可維護性
- 可靠、可讀、可維護的測試
- 對於接收資料的各種 edge case 的處理
- （如果你覺得有把握）可以使用 GraphQL 實作


---

## How to run server locally

- run postgres locally
This project use postgres as database, please make sure you have postgres server running locally

If not, it is recommended to run postgres in docker container(remember to modify `<your password>` to the password you wanna use):

```bash
> docker run -d --name postgres -e POSTGRES_PASSWORD=<your password> -e POSTGRES_USER=deployer -p 5432:5432 postgres
```

- create env file
copy `.env.example` and rename to `.env` and fill in the env vars you use locally

- run server
now you can start your server locally

```bash
> rails db:create
> rails db:migrate
> rails s
```

## API

This api server provides following apis:

- view course lists: `GET /courses`
- view a single course: `GET /courses/:id`
- create course: `POST /courses`
- update course: `UPDATE /courses/:id`
- delete course: `DELETE /courses/:id`

## Gems

- pg: 提供我們與 PostgreSQL 這個 RDBMS 一個接口

- dotenv: repo 裡面有些 environment variables 要餵給 server，dotenv 讓我們只要照著他的規則放檔案 / 改檔名，就可以在不同情況切換不同環境變數

- byebug: 提供開發者透過中斷點除錯

- factory_bot: 讓開發者可以用 factory pattern 做出測試需要的資料，利用這套工具提供的 DSL 可以讓測試的程式碼較容易維護

## Comments

會寫註解的情況：
1. 英文跟中文容易混淆, ex. Section model 裡面的 description / deatil 哪個代表內容哪個代表說明
2. 做的過程中想到可以做優化/改善的地方會用 `# TODO:` 或者 `# FIXME:` 提醒日後可以在這邊做修改
3. magic number，比方說 2038 年某天需要做一些 integer 欄位檢查，這個數字就會特別註解
4. 某個 method 背後若代表複雜邏輯，會寫註解
5. 做 metaprogramming 改程式碼的時候，視情況若有需要會把原程式碼用註解的形式寫上去

## Dilemmas

1. 在課程章節跟單元順序的部分，目前實作是想說前端傳 array 給後端，後端以這個 array 的順序標註順序存在 DB，而不是以前端傳順序這個 attribute 的方式去定義

因為 array 本身已經有順序的含義，所以可以直接根據 array 來當作順序的依據，若在陣列裡面又給順序的參數，容易造成混淆，而且傳送的內容也會變多

2. 在 index / show 這邊要不要給順序

雖然在 create 的 api 不去處理這個順序，但在給 client 資料的時候還是可以給，後來想一想覺得有給沒給好像沒有太大影響，而且 client 可能也可以拿這個 attribute 去做一些操作，所以還是給

## Solved issues

### 新增 Course has_many Sections 的 relation

在 CourseForm 裡面 iteration assign attribute 的時候發現一個情況，如果在 DB 裡面，Course 本來有一個 ChapterA 跟 SectionA，在 update course 的時候，如果新 build 一個 ChapterB ，並且把 SectionA assign 給 ChapterB，在原本的這段 code:

```ruby
existed_section = chapter.sections.detect { |s| s.id == section_attrs[:id].to_i }
```

因為 chapter 已經換了，所以在 ChapterB 裡面找不到任何一個 id 符合 SectionA，這時候他會去 create 新的 Section

不想用 Section.all 去搜尋相同 id 的 section，因為這樣有可能找到屬於別的課程的 section，因此決定多建立一個 Course has_many Sections 的 relation 解決這問題

### 同時處理順序 / 刪除問題

在更新 course 的時候，若同時有刪除的 chapter 或者 section 就不應該把他們的順序考慮進去，解決的方法是一步一步去做，先確定 mark `_destroy` 的這些資料會確實被刪除，再來修改 assign_attribute 的時候順序的規則

### form 的 validation
原本在思考 form 這邊的 validation 要怎麼寫，後來決定還是把基礎的 validation 寫在 model 身上，在 form 這邊 validation 的時候再去問 model validation 的結果，比較符合 SRP 規則

## Future Works
我另外還有想到一些地方是可以改善的：

1. `courses#index` 的 api 加上 fragement cache 改善效率，rails 的 fragment cache 會用物件的 id 跟 updated_at 等資訊拼湊出 cache 的 key，只要在課程的 updated_at 都沒更新的情況下，視為這個課程頁面的資訊都沒有改變，也就不用特別去 db 做 query 可以直接拿 cache 的資料

2. refactor CourseForm，目前這個 form 在 assign_attribute 這個 method 的邏輯太複雜，而且過程中有些邏輯相同可以抽出來

3. 把前端的相關內容拿掉，因為這只是個 api server