<template>
  <section class="blog-post card">
    <h2 class="blog-post__title">
      <a :href="path" class="blog-post__link">{{ title }}</a>
    </h2>
    <div style="margin: 1rem 0rem;">
      <Badge v-for="tag of tags" :text="tag" />
    </div>
    <p v-if="excerpt" class="blog-post__excerpt">{{ limitedExcerpt }}</p>
    <a class="button blog-post__button " :href="path">Read More</a>
    <div class="ui-post-date">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-clock"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
      <span>{{ formatPublishDate }}</span>
    </div>
  </section>
</template>

<script>
export default {
  name: "BlogPostPreview",
  props: {
    publishDate: {
      type: String,
      required: true
    },
    tags: {
      type: Array,
      required: false
    },
    title: {
      type: String,
      required: true
    },
    path: {
      type: String,
      required: true
    },
    excerpt: {
      type: String,
      required: false
    }
  },
  computed: {
    limitedExcerpt() {
      const max = 300;
      return this.excerpt.length > max
        ? this.excerpt.substring(0, max) + "...[…  ]"
        : this.excerpt;
    },
    formatPublishDate() {
      const dateFormat = new Date(this._props.publishDate);
      const options = {
        year: "numeric",
        month: "long",
        day: "numeric"
      };

      //return dateFormat.toLocaleDateString('en-US', options)
      return dateFormat.toLocaleDateString(this.$lang, options);
    }
  }
};
</script>

<style lang="stylus" scoped>
primary-color = $accentColor

.blog-post {
    margin-bottom: 2.5rem;
}

.blog-post__button {
	display: inline-block;
}

.blog-post__excerpt {
    margin-top: 0;
    font-size: 1.12rem;

}

.blog-post__link {
    font-weight: 700;
    color: #2d2d2d;

    &:hover {
        text-decoration: underline;
    }
}

.blog-post__title {
    font-size: 1.225em;
	margin-top: 0.5rem;
    margin-bottom: 0.75rem;
}

.button {
    font-family: 'Poppins';
    font-weight: 500;
	border: 1px solid primary-color;
	border-radius: 4px;
	color: primary-color;
	font-size: 0.9rem;
	padding: 0.3rem 0.6rem;
	text-transform: uppercase;
	box-shadow: 0 0;
	transition: background-color 0.2s ease-in, color 0.2s ease-in;
}

.button:hover {
    background-color: primary-color;
    color: #fff;
    text-decoration: none;
}

.tag-list {
    list-style: none;
    padding-left: 0;
    display: flex;
    margin-bottom: 25px;
}

.tag-list__item {
    margin-left: 10px;
}

.tag-list__item:first-child {
    margin-left: 0;
}

.tag-list__btn {
    padding: 5px;
    font-size: 0.9rem;
    background-color: #fff;
}

.card {
    position: relative;
    display: -ms-flexbox;
    -ms-flex-direction: column;
    flex-direction: column;
    min-width: 0;
    word-wrap: break-word;
    background-color: #fff;
    background-clip: border-box;
    border: 1px solid rgba(0,0,0,.125);
    border-radius: .25rem;
    padding: 1rem 2rem;
}

.ui-post-date {
    margin-top: 1.5rem;
    display: flex;
    align-items: center;
    font-size: 12px;
    color: rgba(0,0,0,.54);
    font-weight: 200;
}

.ui-post-date svg {
    margin-right: 5px;
    width: 14px;
    height: 14px;
}
</style>
