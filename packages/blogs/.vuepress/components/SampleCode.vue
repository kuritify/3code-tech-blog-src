<template>
  <span>
  <a class="sample-code" :href="editLink" target="_blank" rel="noopener noreferrer">{{ editLinkText }}</a>
  <OutboundLink />
  </span>
</template>
<script>

import { endingSlashRE, outboundRE } from '@theme/util'
import OutboundLink from './OutboundLink.vue'

export default {
  name: 'SampleCode',
  props: {
    text: {
      type: String,
    }
  },
  compponents: { OutboundLink },
  computed: {
    editLinkText () {
      return this.text ? this.text : this.$themeLocaleConfig.sampleCodeText
    },
    editLink () {
      const {
        repo,
        codeDir = '',
        docsBranch = 'master',
        docsRepo = repo
      } = this.$site.themeConfig

      return this.createEditLink(
        repo,
        docsRepo,
        codeDir,
        docsBranch,
        this.$page.relativePath
      )
    },
  },
  methods: {
    createEditLink (repo, docsRepo, docsDir, docsBranch, path) {
      path = path.replace(/[.]md$/, '')
      path = path.replace(/^en\//,'')
      path = path.replace(/^blogs\//,'')
      const base = outboundRE.test(docsRepo)
        ? docsRepo
        : `https://github.com/${docsRepo}`
      return (
        base.replace(endingSlashRE, '')
        + `/tree`
        + `/${docsBranch}/`
        + (docsDir ? docsDir.replace(endingSlashRE, '') + '/' : '')
        + path
      )
    }
  }
}
</script>

<style>
.sample-code {
  font-size: 0.92rem
}

</style>
