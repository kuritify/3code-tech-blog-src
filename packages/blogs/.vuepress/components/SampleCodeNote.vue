<template>
  <div class="custom-block tip">
    <p class="custom-block-title">NOTE</p>
    <p>
      {{ $themeLocaleConfig.sampleCodeNotePre }}<SampleCode text='Github' />{{ $themeLocaleConfig.sampleCodeNotePost }}
    </p>
  </div>
  </span>
</template>
<script>
import SampleCode from './SampleCode.vue'

export default {
  name: 'SampleCodeNote',
  compponents: { SampleCode },
  computed: {
    editLinkText () {
      return this.text ? this.text : this.$themeLocaleConfig.sampleCodeText
    },
  }
}
</script>
