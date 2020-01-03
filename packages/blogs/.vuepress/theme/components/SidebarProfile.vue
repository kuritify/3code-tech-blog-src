<template>
<section class="sidebar-profile">
  <p class="sidebar-heading open" style="margin-bottom: 1.1rem;"><span>Profile</span></p>
  <div class="profile-content" style="margin-bottom: 0.1rem;">
    <img src="/profile.jpg" alt="Photo of Shintaro Kurihara" width="150" class="circle-image" style="margin-bottom: 0.8rem;">
    <div>
      <a href="https://twitter.com/creep_32?ref_src=twsrc%5Etfw" class="twitter-follow-button" :data-lang="$themeLocaleConfig.lang" data-show-count="false">Follow @creep_32</a><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
    </div>
  </div>
  <div class="profile-content" style="padding-bottom: 3rem;">
    <p class="card-text">{{ $themeLocaleConfig.shortProfileName }}</p>
    <p class="card-text">{{ $themeLocaleConfig.shortProfileText }}</p>
    <p class="card-text">
      <small>
        <router-link :to="$themeLocaleConfig.profileLink">{{ $themeLocaleConfig.profileLinkText }}</router-link>
      </small>
    </p>
  </div>
</section>
</template>

<style lang="stylus">
.carbon-ads
  min-height 102px
  padding 1.5rem 1.5rem 0
  margin-bottom -0.5rem
  font-size 0.75rem
  a
    color #444
    font-weight normal
    display inline
  .carbon-img
    float left
    margin-right 1rem
    border 1px solid $borderColor
    img
      display block
  .carbon-poweredby
    color #999
    display block
    margin-top 0.5em


.rounded-circle {
    border-radius: 50%!important;
}

.circle-image {
    border-radius: 50%;
}

.profile-content {
  padding 1.0rem 1.5rem 0
  font-size: 0.9rem
}
</style>

