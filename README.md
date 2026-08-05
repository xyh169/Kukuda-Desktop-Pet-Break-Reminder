# Kukuda

<p align="center">
  <img src="Assets/Kukuda-icon.png" width="180" alt="Kukuda app icon">
</p>

<p align="center">
  A playful little kiwi who appears when it is time to rest.<br>
  一只会在该休息时出来巡场、觅食和逗你玩的 Kiwi。
</p>

Kukuda is a lightweight, native macOS break reminder. After a period of active
computer use, Kukuda wanders onto the screen, shares a bilingual English and
te reo Māori reminder, and invites you to take a real break.

Kukuda 是一款原生 macOS 休息提醒应用。累计使用电脑一段时间后，Kukuda 会在
屏幕上随机巡游，用英语和毛利语提醒你活动身体、看看远处、喝水或出去走走。

## Features / 功能

- Menu-bar countdown with 1, 15, 30, 45, and 60 minute intervals.
- Pause, reset, summon immediately, or launch automatically at login.
- Random full-screen wandering that stays inside the visible display area.
- Jumping, dancing, ground-pecking, foraging, and worm-eating animations.
- 36 playful English and te reo Māori messages, matched to Kukuda's actions.
- Short inactivity pauses the timer; five minutes away resets the work session.
- No analytics, no account, no network requests, and no third-party runtime dependencies.

## Download / 下载

Download the newest `Kukuda-…-macOS-universal.zip` from
[GitHub Releases](https://github.com/xyh169/Kukuda/releases), unzip it, and move
`Kukuda.app` to your Applications folder.

从 [Releases](https://github.com/xyh169/Kukuda/releases) 下载最新的
`Kukuda-…-macOS-universal.zip`，解压后将 `Kukuda.app` 拖进“应用程序”文件夹。

Kukuda is currently ad-hoc signed rather than Apple-notarized. On first launch,
macOS may ask you to right-click the app and choose **Open**. The source is
available here for inspection and local builds.

当前版本尚未经过 Apple 公证。首次启动时，如 macOS 阻止打开，请右键点击
`Kukuda.app`，选择“打开”，再确认一次。

## How it works / 使用方式

The menu-bar title shows the remaining time, such as `Kukuda · 29:42`.

- **Show Kukuda Now** summons Kukuda immediately.
- **Pause Timer** stops counting without quitting the app.
- **Reset Work Session** starts the current cycle again.
- **Reminder Interval** changes the work interval.
- **Start at Login** launches Kukuda automatically after sign-in.
- Click Kukuda or **Tākaro · Play** to trigger a playful dance.
- Click the bubble's `×` to dismiss Kukuda and begin a new work cycle.

## Privacy / 隐私

Kukuda runs entirely on your Mac. It only reads the number of seconds since the
last keyboard or mouse event to distinguish active use from a break. It does not
read keystrokes, capture the screen, access documents, connect to a server, or
collect analytics.

Kukuda 完全在本机运行。它只读取“距离上次键鼠事件过去了多少秒”，不会读取
按键内容、截取屏幕、访问文档、连接服务器或收集分析数据。

## Build from source / 从源码构建

Requirements: macOS 13 or later and Apple Command Line Tools.

```sh
./测试.command
KIWI_BREAK_NO_OPEN=1 ./构建并运行.command
```

The built app is written to `build/Kukuda.app`. Create a release archive with:

```sh
./scripts/package-release.sh
```

## Language note / 语言说明

The te reo Māori lines were checked against Te Aka Māori Dictionary entries,
but the project welcomes review and improvements from fluent speakers. Please
open an issue or pull request if a phrase can be made more natural.

毛利语台词已参考 Te Aka Māori Dictionary 核对关键词，但仍欢迎母语者和熟练使用者
参与审校，让表达更加自然。

## License

[MIT](LICENSE) © 2026 [xyh169](https://github.com/xyh169)
