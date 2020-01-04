<template>
  <main class="page">
    <slot name="top" />

    <div class="blog-head-content">
      <p class="publish-date">
        <time :datetime="$frontmatter.date">{{ publishDate }}</time>
      </p>

      <div class="blog__header">
        <h1 class="blog__title">{{ $page.title }}</h1>
        <div style="margin-left:20px;" class="tooltip-ex"><strong><i class="fas fa-info-circle"></i></strong>
          <span class="tooltip-ex-text tooltip-ex-bottom" v-html="tooltip">
          </span>
        </div>
      </div>

      <Badge v-for="tag of this.$page.frontmatter.tags" :text="tag" />

      <span class="post_format"><router-link :to="postFormatLink">{{ postFormatLinkText }}</router-link></span>
    </div>

    <Content class="theme-default-content" />

    <!--<BuySellAds /> -->

<!--    <div class="blog-bottom-content">
      <section class="share">
        <h2>Share</h2>
        <a
          class="share__button"
          :href="
            `https://twitter.com/intent/tweet?text=${urlPostTitle} by @creep32 ${$themeConfig.domain}${$page.path}`
          "
          target="_blank"
        >
          <i class="fab fa-twitter"></i> Tweet
        </a>
      </section>
    </div> -->

    <PageEdit />

    <BlogNav />

    <div class="comments">
      <vue-disqus
        shortname="3code-techblog"
        :identifier="this.$page.key + 'x'"
        :url="this.$site.themeConfig.siteUrl + this.$page.path"
        :language="disqusLanguage"
        :title="this.$page.title + ' - 3code Tech Blog -'"
        ref="vueDisqus"
       >
      </vue-disqus>
     </div>

    <slot name="bottom" />
  </main>
</template>

<script>
import BlogNav from "@theme/components/BlogNav.vue";
import PageEdit from "@theme/components/PageEdit.vue";
import BuySellAds from "@theme/components/BuySellAds.vue";
import VueDisqus from 'vue-disqus/src/vue-disqus.vue';

export default {
  components: { BlogNav, PageEdit, BuySellAds, VueDisqus },
  props: ["sidebarItems"],
  computed: {
    postFormatLink() {
      if (this.$lang === 'ja' ) {
        return {
          path:"/about/me.html",
          hash: "記事のフォーマット"
        }
      }
      return "/en/about/me/"
    },
    postFormatLinkText() {
      if (this.$lang === 'ja' ) {
        return "記事のフォーマット"
      }
      return "post format"
    },
    tooltip() {
      if (this.$lang === 'ja' ) {
          return `記事の内容に誤り、不快な内容が含まれている場合、コメント欄、または<router-link :to="/contact/">問い合わせ</router-link>からご一報ください。可能な限り急いで修正します。`
       }
       return ``
    },
    disqusLanguage() {
      return this.$lang === "en-US" ? "en" : "ja"
    },
    publishDate() {
      const dateFormat = new Date(this.$frontmatter.date);
      const options = {
        year: "numeric",
        month: "long",
        day: "numeric"
      };

      return dateFormat.toLocaleDateString(this.$lang, options);
    },
    urlPostTitle() {
      return encodeURIComponent(this.$page.title);
    }
  },
  watch: {
    'disqusLanguage': function() {
      this.$refs.vueDisqus.init()
     // reset(window.DISQUS)
    }
  }
};
</script>

<style lang="stylus">
theme-default-content.content__default
  padding 0rem 2.5rem

.blog-bottom-content
  max-width $contentWidth
  margin 0 auto
  margin-top 3rem
  padding 0rem 2.5rem 0rem 2.5rem
  @media (max-width: $MQNarrow)
    padding 2rem
  @media (max-width: $MQMobileNarrow)
    padding 1.5rem


.comments, .blog-head-content
  max-width $contentWidth
  margin 0 auto
  margin-top 3rem
  padding 2rem 2.5rem 0rem 2.5rem
  @media (max-width: $MQNarrow)
    padding 2rem
  @media (max-width: $MQMobileNarrow)
    padding 1.5rem

.blog__title {
   font-size:
   1.9em;
}

.publish-date {
  margin-bottom: 0.5rem;
  font-family: 'Poppins';
}

img.medium-zoom-image {
  margin-bottom: 2.5rem
}

.blog__header {
  display: flex;
  align-items: center;
}

.tooltip-ex { /* Container for our tooltip */
 position: relative;
 display: inline-block;
 cursor: help;
 margin-right: 20px;
 display: inline-block;
 float: left;
}

.tooltip-ex-bottom {
 top: 135%;
 left: 50%;
 margin-left: -60px;
}

.tooltip-ex-text {
 visibility: hidden;
 position: absolute;
 width: 300px;
 background-color: #555;
 color: #fff;
 text-align: left;
 padding: 20px;
 border-radius: 6px;
 z-index: 1;
 opacity: 0;
 transition: opacity .6s;
}

.tooltip-ex:hover .tooltip-ex-text { /* Makes tooltip visible when hovered on */
 visibility: visible;
 opacity: 1;
}
.post_format {
  display: inline-block;
  font-size: 14px;
  height: 18px;
  line-height: 18px;
  padding: 6px 20px;
}
</style>
