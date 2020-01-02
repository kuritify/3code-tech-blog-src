<template>
  <main class="page">
    <slot name="top" />

    <div class="blog-head-content">
      <p class="publish-date">
        <time :datetime="$frontmatter.date">{{ publishDate }}</time>
      </p>
      <h1 class="blog__title">{{ $page.title }}</h1>
      <Badge v-for="tag of this.$page.frontmatter.tags" :text="tag" />
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
        :identifier="this.$page.key"
        url="http://192.168.100.2:8080/"
        :language="disqusLanguage"
        :title="this.$page.title + ' - 3code TechBlog -'"
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

</style>
