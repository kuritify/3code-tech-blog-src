const path = require('path')
const RSS = require('rss')
const chalk = require('chalk')

module.exports = (pluginOptions, ctx) => {
  return {
    name: 'rss',
    
    generated () {
      const fs = require('fs-extra')
      const { pages, sourceDir } = ctx
      const { count = 20 } = pluginOptions
      const siteData = require(path.resolve(sourceDir, '.vuepress/config.js'))()
     
      for (const locale of Object.keys(siteData.locales)) {
        let feed = new RSS({
          title: siteData.locales[locale].title,
          description: siteData.locales[locale].description,
          feed_url: `${pluginOptions.site_url}${locale}rss.xml`,
          site_url: `${pluginOptions.site_url}`,
          copyright: `${pluginOptions.copyright ? pluginOptions.copyright : 'Coralo 2018'}`,
          language: siteData.locales[locale].lang
        })
        
        let regex = new RegExp(`^${locale}blogs/.*[/]`)
        pages
          .filter(page => regex.test(page.path))
          .map(page => ({...page, date: new Date(page.frontmatter.date || '')}))
          .sort((a, b) => b.date - a.date)
          .map(page => ({
            title: page.frontmatter.title,
            description: page.frontmatter.description,
            url: `${pluginOptions.site_url}${page.path}`,
            date: page.date,
          }))
          .slice(0, count)
          .forEach(page => feed.item(page))
        let dir = path.join(ctx.outDir, locale);

        if (!fs.exisit(dir) ) {
          fs.mkdir(dir);
        }

        fs.writeFile(
          path.resolve(dir, 'rss.xml'),
          feed.xml()
        );
        console.log(chalk.green.bold(siteData.locales[locale].lang + ' RSS has been generated!'))
      }
    }
  }
}