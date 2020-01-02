<template>
  <div class="blog-list__container">
    <div class="blog-list__header">
      <h1>{{ blogListTitle }}</h1>
    </div>

    <div v-if="selectedTag" class="filtered-heading">
      <h2>Filtered by {{ selectedTag }} tag</h2>
      <button
        type="button"
        class="btn clear-filter-btn"
        @click="selectedTag = ''"
      >
        Clear filter
      </button>
    </div>
    <ul class="blog-list">
      <li v-for="(item, index) in filteredList" class="blog-list__item">
        <BlogPostPreview
          v-show="index <= displayRange.end"
          :excerpt="item.frontmatter.description"
          :path="item.path"
          :publish-date="item.frontmatter.date"
          :tags="item.frontmatter.tags"
          :title="item.frontmatter.title"
          @updateSelectedTag="updateSelectedTag"
        />
      </li>
    </ul>

    <!--
        <div v-if="displayRange.end <= filteredList.length" class="pagination">
            <button
                @click="loadMore"
                class="button--load-more"
                type="button"
            >
                Load More
            </button>
        </div>
   -->
  </div>
</template>

<script>
import { relatedBlogs } from "@theme/util";

export default {
  name: "BlogPostList",
  data() {
    return {
      displayRange: {
        end: 4
      },
      selectedTag: ""
    };
  },
  computed: {
    blogListTitle() {
      if (typeof this.$themeLocaleConfig.blogListTitle === "string") {
        return this.$themeLocaleConfig.blogListTitle;
      }
      if (typeof this.$site.themeConfig.blogListTitle === "string") {
        return this.$site.themeConfig.blogListTitle;
      }
      return "Most Recent";
    },
    filteredList() {
      const filterd = relatedBlogs(this);
      if (filterd) {
        if (filterd && filterd.length > 0) {
          return filterd
            .filter(item => {
              const isBlogPost =
                item.path.match(`^${this.$localeConfig.path}blogs/`) !== null;
              const isReadyToPublish =
                new Date(item.frontmatter.date) <= new Date();
              const hasTags =
                item.frontmatter.tags &&
                item.frontmatter.tags.includes(this.selectedTag);

              const shouldPublish = this.selectedTag
                ? isBlogPost && isReadyToPublish && hasTags
                : isBlogPost && isReadyToPublish;

              if (shouldPublish) {
                return item;
              }
            })
            .sort(
              (a, b) =>
                new Date(b.frontmatter.date) - new Date(a.frontmatter.date)
            );
        }
      }
    }
  },
  methods: {
    loadMore() {
      this.displayRange.end += 5;
    },
    updateSelectedTag(tag) {
      this.selectedTag = tag;
    }
  }
};
</script>

<style lang="stylus" scoped>
primary-color = #22AAFF

.blog-list {
	padding: 0;
	margin: 0;
}

.blog-list__container {
    margin-top: 2rem;
}

.blog-list__header {
    display: flex;
    align-items: center;
}

.blog-list__item {
	list-style-type: none;
}

.button--load-more {
	background-color: primary-color;
	border-radius: 4px;
	color: #fff;
	font-size: 1rem;
	padding: 0.5rem 0.75rem;
	text-transform: uppercase;
	font-weight: 500;
	box-shadow: 0 0;
    cursor: pointer;
	transition: background-color 0.2s ease-in, color 0.2s ease-in;
}

.button--load-more:hover {
    background-color: #fff;
    border: 1px solid primary-color;
    border-radius: 4px;
    color: primary-color;
}

.clear-filter-btn {
    align-self: center;
    margin-left: 20px;
}

.filtered-heading {
    display: flex;
}

.pagination {
    text-align: center;
}
</style>
