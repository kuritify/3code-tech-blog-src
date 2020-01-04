<template>
  <div class="footer">
    Copyright © 2020-present Shintaro Kurihara. Powered By
    <a href="https://vuepress.vuejs.org" title="by Vuepress" target="_blank"
      >VuePress <OutboundLink
    /></a>
  </div>
</template>

<script>
import OutboundLink from "@vuepress/core/lib/client/components/OutboundLink.vue";

export default {
  components: {
    OutboundLink
  },
};
</script>

<style lang="stylus">
.footer
   padding 2.5rem
   border-top 1px solid $borderColor
   text-align center
   color lighten($textColor, 25%)
</style>
