<template>
  <div v-if="prev || next" class="page-nav">
    <p class="inner">
      <span v-if="prev" class="prev nav-link">
        ←
        <router-link v-if="prev" class="prev" :to="prev.path">{{
          prev.title || prev.path
        }}</router-link>
      </span>

      <span v-if="next" class="next nav-link">
        <router-link v-if="next" :to="next.path">{{
          next.title || next.path
        }}</router-link>
        →
      </span>
    </p>
  </div>
</template>
<script>
import { resolvePage, relatedBlogs } from "../util";
//import isString from 'lodash/isString'
//import isNil from 'lodash/isNil'

export default {
  name: "BlogNav",
  computed: {
    prev() {
      return resolvePageLinks(this).next;
    },
    next() {
      return resolvePageLinks(this).prev;
    }
  }
};

function resolvePageLinks({
  $themeConfig,
  $page,
  $route,
  $site,
  $localeConfig
}) {
  const filterd = relatedBlogs({
    $themeConfig,
    $page,
    $route,
    $site,
    $localeConfig
  });
  const index = filterd.indexOf($page);

  const ret = {};
  if (index > 0) {
    ret.prev = {
      path: filterd[index - 1].path,
      title: filterd[index - 1].title
    };
  }

  if (filterd[index + 1]) {
    ret.next = {
      path: filterd[index + 1].path,
      title: filterd[index + 1].title
    };
  }

  return ret;
}
</script>

<style lang="stylus">
@require '../styles/wrapper.styl'

.page-nav
  @extend $wrapper
  padding-top 1rem
  padding-bottom 0
  .inner
    min-height 2rem
    margin-top 0
    border-top 1px solid $borderColor
    padding-top 1rem
    overflow auto // clear float
  .next
    float right

.nav-link {
  font-size: 1rem;
}
</style>
