---
title: 自動テストをDocerlizeするためのDockerfileの管理方法
date: 2020-01-02 18:12:31
tags:
  - devops
  - iac
---

![main image](./docker.png)

「Unitテスト、IntegrationテストコードもDocker化してCI環境で動かそう！」とチームで決定したとします。なんだが簡単にできそうな気がしますが、少し深く考えてみると考慮事項がいくつかあることが見えてきます。例えば、既にアプリケーションをDockerlizeしている場合は、`.dockerignore`ファイルを使い、テストコードをコンテナーから除外しているのではないのかと思います。この記事ではコードベースに極力手を加えず、自動テストをDockerlizする方法を検討します。


## Problem
`Jenkins`などで自前のCI環境を構築し、複数プロジェクトで利用しているケースなどは良くあるかと思います。Jenkinsスレーブに各プロジェクトに必要なソフトウェアをインストールしたくない。ポートの競合が起きないようにしたい。といった場合、コンテナ技術はうってつけのソリューションです。ただし自動テストをDockerlizeするうえでいくつかの考慮次項があります。

* Dockerイメージを最小化するため、デプロイ用のコンテナからはテストコードを除外したい
* 開発の生産性を損なわないよう、コードべースには余計な手を加えたくない
* Integration、E2Eなど各テスト毎のコンテナ化を効率化したい


## Solution
コードベースに余計な手を加えないためにも、Dockerのソリューションだけで解決することがポイントになります。具体的には、Dockerfileと[.dockerignoreファイル](https://docs.docker.com/engine/reference/builder/#dockerignore-file)をわけることにより実現します。加えて、各種テスト事に同セットを用意したくないので、自動テストのDockerfileは[multi stage builds](https://docs.docker.com/develop/develop-images/multistage-build/)を併用し管理コストを最小化します。

::: tip Note
このソリューションは[Stack overflow](https://stackoverflow.com/a/57774684)を参考にしています
:::

### 最終ディレクトリ構成
サンプルコードのアプリケーションはNodejsのExpressフレームワークで簡単なREST APIがあり、JestでUnitテスト、Integrationtテストを実装しているものとします。最終構成は以下のようになります。

::: vue
.
├ ─ ─  docs
│    ├ ─ ─  .vuepress _(**Optional**)_
│    │    ├ ─ ─  `components` _(**Optional**)_
│    │    ├ ─ ─  `theme` _(**Optional**)_
│    │    │    └ ─ ─  Layout.vue
│    │    ├ ─ ─  `public` _(**Optional**)_
│    │    ├ ─ ─  `styles` _(**Optional**)_
│    │    │    ├ ─ ─  index.styl
│    │    │    └ ─ ─  palette.styl
│    │    ├ ─ ─  `templates` _(**Optional, Danger Zone**)_
│    │    │    ├ ─ ─  dev.html
│    │    │    └ ─ ─  ssr.html
│    │    ├ ─ ─  `config.js` _(**Optional**)_
│    │    └ ─ ─  `enhanceApp.js` _(**Optional**)_
│    │  
│    ├ ─ ─  README.md
│    ├ ─ ─  guide
│    │    └ ─ ─  README.md
│    └ ─ ─  config.md
│  
└ ─ ─  package.json
:::


それぞれの実行結果は以下のようになります。
```
```

## Discussion


### Custom COntainers
::: tip
This is a tip
:::

::: warning
This is a warning
:::

::: danger
This is a dangerous warning
:::

::: danger STOP
Danger zone, do not proceed
:::

```js{2,4,8,16,32,64,65}
'use strict'

/**
 * Module dependencies.
 */

const Config = require('markdown-it-chain')
const highlight = require('./lib/highlight')
const { PLUGINS, REQUIRED_PLUGINS } = require('./lib/constant')
const highlightLinesPlugin = require('./lib/highlightLines')
const preWrapperPlugin = require('./lib/preWrapper')
const lineNumbersPlugin = require('./lib/lineNumbers')
const componentPlugin = require('./lib/component')
const hoistScriptStylePlugin = require('./lib/hoist')
const convertRouterLinkPlugin = require('./lib/link')
const snippetPlugin = require('./lib/snippet')
const emojiPlugin = require('markdown-it-emoji')
const anchorPlugin = require('markdown-it-anchor')
const tocPlugin = require('markdown-it-table-of-contents')
const {
  slugify: _slugify,
  parseHeaders,
  logger, chalk, normalizeConfig,
  moduleResolver: { getMarkdownItResolver }
} = require('@vuepress/shared-utils')

/**
 * Create markdown by config.
 */

module.exports = (markdown = {}) => {
  const {
    externalLinks,
    anchor,
    toc,
    plugins,
    lineNumbers,
    beforeInstantiate,
    afterInstantiate
  } = markdown

  const resolver = getMarkdownItResolver()

  // allow user config slugify
  const slugify = markdown.slugify || _slugify

  // using chainedAPI
  const config = new Config()

  config
    .options
      .html(true)
      .highlight(highlight)
      .end()

    .plugin(PLUGINS.COMPONENT)
      .use(componentPlugin)
      .end()

    .plugin(PLUGINS.HIGHLIGHT_LINES)
      .use(highlightLinesPlugin)
      .end()

    .plugin(PLUGINS.PRE_WRAPPER)
      .use(preWrapperPlugin)
      .end()

    .plugin(PLUGINS.SNIPPET)
      .use(snippetPlugin)
      .end()

    .plugin(PLUGINS.CONVERT_ROUTER_LINK)
      .use(convertRouterLinkPlugin, [Object.assign({
        target: '_blank',
        rel: 'noopener noreferrer'
      }, externalLinks)])
      .end()

    .plugin(PLUGINS.HOIST_SCRIPT_STYLE)
      .use(hoistScriptStylePlugin)
      .end()

    .plugin(PLUGINS.EMOJI)
      .use(emojiPlugin)
      .end()

    .plugin(PLUGINS.ANCHOR)
      .use(anchorPlugin, [Object.assign({
        slugify,
        permalink: true,
        permalinkBefore: true,
        permalinkSymbol: '#'
      }, anchor)])
      .end()

    .plugin(PLUGINS.TOC)
      .use(tocPlugin, [Object.assign({
        slugify,
        includeLevel: [2, 3],
        format: parseHeaders
      }, toc)])
      .end()

  if (lineNumbers) {
    config
      .plugin(PLUGINS.LINE_NUMBERS)
        .use(lineNumbersPlugin)
  }

  beforeInstantiate && beforeInstantiate(config)

  const md = config.toMd(require('markdown-it'), markdown)

  const pluginsConfig = normalizeConfig(plugins || [])
  pluginsConfig.forEach(([pluginRaw, pluginOptions]) => {
    const plugin = resolver.resolve(pluginRaw)
    if (plugin.entry) {
      md.use(plugin.entry, pluginOptions)
    } else {
      // TODO: error handling
    }
  })

  afterInstantiate && afterInstantiate(md)

  module.exports.dataReturnable(md)

  // expose slugify
  md.slugify = slugify

  return md
}

module.exports.dataReturnable = function dataReturnable (md) {
  // override render to allow custom plugins return data
  const render = md.render
  md.render = (...args) => {
    md.$data = {}
    md.$data.__data_block = {}
    md.$dataBlock = md.$data.__data_block
    const html = render.call(md, ...args)
    return {
      html,
      data: md.$data,
      dataBlockString: toDataBlockString(md.$dataBlock)
    }
  }
}

function toDataBlockString (ob) {
  if (Object.keys(ob).length === 0) {
    return ''
  }
  return `<data>${JSON.stringify(ob)}</data>`
}

function isRequiredPlugin (plugin) {
  return REQUIRED_PLUGINS.includes(plugin)
}

function removePlugin (config, plugin) {
  logger.debug(`Built-in markdown-it plugin ${chalk.green(plugin)} was removed.`)
  config.plugins.delete(plugin)
}

function removeAllBuiltInPlugins (config) {
  Object.keys(PLUGINS).forEach(key => {
    if (!isRequiredPlugin(PLUGINS[key])) {
      removePlugin(config, PLUGINS[key])
    }
  })
}

module.exports.isRequiredPlugin = isRequiredPlugin
module.exports.removePlugin = removePlugin
module.exports.removeAllBuiltInPlugins = removeAllBuiltInPlugins
module.exports.PLUGINS = PLUGINS
```

> ウィキペディア（英: Wikipedia）は、ウィキメディア財団が運営しているインターネット百科事典。コピーレフトなライセンスのもと、サイトにアクセス可能な誰もが無料で自由に編集に参加できる。世界の各言語で展開されている。
> [Wikipediaより](https://ja.wikipedia.org/wiki/%E3%82%A6%E3%82%A3%E3%82%AD%E3%83%9A%E3%83%87%E3%82%A3%E3%82%A2 "by Wikipedia")
