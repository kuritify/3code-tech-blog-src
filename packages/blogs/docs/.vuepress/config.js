const { fs, path } = require("@vuepress/shared-utils");

const siteTitle = "3code TechBlog"
const siteUrl = "https://tech-blog.3code.dev"
const autometa_options = {
  autor: {
    name   : 'Shintaro Kurihara',
    twitter: 'creep_32'
  },
  site: {
    name   : siteTitle,
    twitter: siteTitle,
  },
  canonical_base: siteUrl,
  pageImage: "post-image.png"
};

module.exports = ctx => ({
  dest: "dist",
  markdown: {
    lineNumbers: true
  },
  extendMarkdown: md => {
    md.use(require("markdown-it-plantuml"));
    md.use(require("markdown-it-include"), "./docs");
  },
  locales: {
    "/": {
      lang: "ja",
      title: siteTitle,
      description: "Let’s maximize the Developer Experience!"
    },
  //  "/en/": {
  //    lang: "en-US",
  //    title: siteTitle,
  //    description: "Let’s maximize the Developer Experience!"
  //  }
  },
  head: [
    ["link", { rel: "icon", href: `/logo.png` }],
    ["meta", { name: "theme-color", content: "#e60668" }],
    ["meta", { name: "msapplication-TileColor", content: "#000000" }]
  ],
  themeConfig: {
    docsRepo: "creep32/3code-techblogs",
    docsDir: 'docs',
    searchPlaceholder: "search on blog...",
    editLinks: true,
    showLinks: true,
    logo: "/logo.png",
    locales: {
      "/": {
        label: "Japanese",
        lang: "ja",
        selectText: "言語",
        ariaLabel: "言語変更",
        editLinkText: "Show on GitHub",
        lastUpdated: "Last Updated",
        blogListTitle: "最新記事",
        nav: require("./nav/ja.js"),
      //  sidebar: "auto",
        sidebarDepth: 2,
        sidebar: {
          "/blogs/": "Contents",
          "/specials/": "Contents",
          "/about/": "Contents",
          "/contact/": "Contents",
          "/sitemap/": "Contents"
        },
        profileLink: "/about/me",
        profileLinkText: "プロフィール詳細",
        shortProfileName: "栗原 真太郎",
        shortProfileText: "外資系ITコンサルティングファームでアーキテクトに従事しつつ、メーカ企業でシステム内製化のサポートを行っている。本ブログを通じて開発者エクスぺリンエスを最大化するプラクティスについて発信中"
      },
  //    "/en/": {
  //      label: "English",
  //      lang: "en",
  //      selectText: "Languages",
  //      ariaLabel: "Select language",
  //      editLinkText: "Show on GitHub",
  //      lastUpdated: "Last Updated",
  //      blogListTitle: "Most Recent",
  //      nav: require("./nav/en.js"),
  //      sidebar: {
  //        "/en/blogs/": "Contents",
  //        "/en/specials/": "Contents",
  //        "/en/about/": "Contents",
  //        "/en/contact/": "Contents",
  //        "/sitemap/": "Contents"
  //      },
  //      lprofileLink: "/en/about/me",
  //      profileLinkText: "read more...",
  //      shortProfileText: "Hello. I Am shintaro kurihra, software developer"
  //    }
    },
    user: {
        socialMedia: [
          {
            name: "Twitter",
            href: "https://twitter.com/creep_32",
            icon: "twitter"
          },
          {
            name: "GitHub",
            href: "https://github.com/creep32",
            icon: "github"
          }
        ]
        //socialMedia: [
        //	{
        //		name: "Twitter",
        //		href: "https://twitter.com/bencodezen",
        //		icon: "twitter"
        //	},
        //	{
        //		name: "Twitch",
        //		href: "https://www.twitch.tv/bencodezen",
        //		icon: "twitch"
        //	},
        //	{
        //		name: "GitLab",
        //		href: "https://gitlab.com/bencodezen",
        //		icon: "gitlab"
        //	},
        //	{
        //		name: "GitHub",
        //		href: "https://github.com/bencodezen",
        //		icon: "github"
        //	},
        //	{
        //		name: "CodePen",
        //		href: "https://codepen.io/bencodezen/",
        //		icon: "codepen"
        //	},
        //	{
        //		name: "StackOverflow",
        //		href: "https://stackoverflow.com/users/5100020/bencodezen",
        //		icon: "stack-overflow"
        //	},
        //	{
        //		name: "Notist",
        //		href: "https://noti.st/bencodezen"
        //	}
        //]
      },
  },
  plugins: [
  [ 'vuepress-plugin-autometa-mine', autometa_options ],
		[
			'vuepress-plugin-rss-mine',
			{
				base_url: '/',
				site_url: 'https://tech-blogs.3code.dev',
				filter: $page => $page.path.match(/^(\/en)?\/blogs\/.*[\/]/),
				count: 20
			}
		],
    [
      'sitemap',
        {
          hostname: 'https://tech-blog.3code.dev'
        },
    ],
    [
      'vuepress-plugin-container',
      {
        type: 'right',
        defaultTitle: '',
      },
    ],
    [
      'vuepress-plugin-container',
      {
        type: 'theorem',
        before: info => `<div class="theorem"><p class="title">${info}</p>`,
        after: '</div>',
      },
    ],
    ['container', {
      type: 'details',
      before: info => `<details class="custom-block details">${info ? `<summary>${info}</summary>` : ''}\n`,
      after: () => '</details>\n'
    }],
    // this is how VuePress Default Theme use this plugin
    [
      'vuepress-plugin-container',
      {
        type: 'tip',
        defaultTitle: {
          '/': 'TIP',
        },

      },
    ],
    [
      'vuepress-plugin-container',
      {
        type: 'danger',
        defaultTitle: {
          '/': 'DANGER',
        },
      },
    ],
    [
      'vuepress-plugin-container',
      {
        type: 'warning',
        defaultTitle: {
          '/': 'WARNING',
        },
      },
    ],

   ["smooth-scroll", true],
    [
      "@vuepress/search",
      {
        searchMaxSuggestions: 10,
        test: ["/blogs/[^/]+/"]
      }
    ],
    ["@vuepress/back-to-top", true],
    [
      "@vuepress/pwa",
      {
        serviceWorker: true,
        updatePopup: true
      }
    ],
    ["@vuepress/medium-zoom", true],
    [
      "@vuepress/google-analytics",
      {
        ga: "UA-128189152-1"
      }
    ],
  ],

  //plugins: [
  //  ['@vuepress/back-to-top', true],
  //  ['@vuepress/pwa', {
  //    serviceWorker: true,
  //    updatePopup: true
  //  }],
  //  ['@vuepress/medium-zoom', true],
  //  ['@vuepress/google-analytics', {
  //    ga: 'UA-128189152-1'
  //  }],
  //  ['container', {
  //    type: 'vue',
  //    before: '<pre class="vue-container"><code>',
  //    after: '</code></pre>',
  //  }],
  //  ['container', {
  //    type: 'upgrade',
  //    before: info => `<UpgradePath title="${info}">`,
  //    after: '</UpgradePath>',
  //  }],
  //],
  //  head: [
  //    ["link", { rel: "icon", href: `/logo.png` }],
  //    ["link", { rel: "manifest", href: "/manifest.json" }],
  //    ["meta", { name: "theme-color", content: "#3eaf7c" }],
  //    ["meta", { name: "apple-mobile-web-app-capable", content: "yes" }],
  //    [
  //      "meta",
  //      { name: "apple-mobile-web-app-status-bar-style", content: "black" }
  //    ],
  //    [
  //      "link",
  //      { rel: "apple-touch-icon", href: `/icons/apple-touch-icon-152x152.png` }
  //    ],
  //    [
  //      "link",
  //      {
  //        rel: "mask-icon",
  //        href: "/icons/safari-pinned-tab.svg",
  //        color: "#3eaf7c"
  //      }
  //    ],
  //    [
  //      "meta",
  //      {
  //        name: "msapplication-TileImage",
  //        content: "/icons/msapplication-icon-144x144.png"
  //      }
  //    ],
  //    ["meta", { name: "msapplication-TileColor", content: "#000000" }]
  //  ],
  //  //theme: "@vuepress/vue",
  //  themeConfig: {
  //    searchPlaceholder: "search on blog...",
  //    docsRepo: "https://github.com/creep32/test-js",
  //    user: {
  //      socialMedia: [
  //        {
  //          name: "Twitter",
  //          href: "https://twitter.com/creep_32",
  //          icon: "twitter"
  //        },
  //        {
  //          name: "GitHub",
  //          href: "https://github.com/creep32",
  //          icon: "github"
  //        }
  //      ]
  //      //socialMedia: [
  //      //	{
  //      //		name: "Twitter",
  //      //		href: "https://twitter.com/bencodezen",
  //      //		icon: "twitter"
  //      //	},
  //      //	{
  //      //		name: "Twitch",
  //      //		href: "https://www.twitch.tv/bencodezen",
  //      //		icon: "twitch"
  //      //	},
  //      //	{
  //      //		name: "GitLab",
  //      //		href: "https://gitlab.com/bencodezen",
  //      //		icon: "gitlab"
  //      //	},
  //      //	{
  //      //		name: "GitHub",
  //      //		href: "https://github.com/bencodezen",
  //      //		icon: "github"
  //      //	},
  //      //	{
  //      //		name: "CodePen",
  //      //		href: "https://codepen.io/bencodezen/",
  //      //		icon: "codepen"
  //      //	},
  //      //	{
  //      //		name: "StackOverflow",
  //      //		href: "https://stackoverflow.com/users/5100020/bencodezen",
  //      //		icon: "stack-overflow"
  //      //	},
  //      //	{
  //      //		name: "Notist",
  //      //		href: "https://noti.st/bencodezen"
  //      //	}
  //      //]
  //    },
  //    //editLinks: true,
  //    showLinks: true,
  //    //docsDir: 'packages/docs/docs',
  //    // #697 Provided by the official algolia team.
  //    //algolia: ctx.isProd ? ({
  //    //  apiKey: '3a539aab83105f01761a137c61004d85',
  //    //  indexName: 'vuepress'
  //    //}) : null,
  //    smoothScroll: true,
  //    logo: "/logo.png",
  //    locales: {
  //      "/": {
  //        label: "Japanese",
  //        lang: 'ja',
  //        selectText: "言語",
  //        ariaLabel: "言語変更",
  //        editLinkText: "Show on GitHub",
  //        lastUpdated: "Last Updated",
  //        blogListTitle: "最新記事",
  //        nav: require("./nav/ja"),
  //        sidebar: {
  //          "/blogs/": "Contents",
  //          "/specials/": "Contents",
  //          "/about/": "Contents",
  //          "/contact/": "Contents"
  //        },
  //        profileLink: "/about/me",
  //        profileLinkText: "詳細をみる",
  //        shortProfileText: "いい感じで頑張ってます",
  //      },
  //      "/en/": {
  //        label: "English",
  //        lang: 'en',
  //        selectText: "Languages",
  //        ariaLabel: "Select language",
  //        editLinkText: "Show on GitHub",
  //        lastUpdated: "Last Updated",
  //        blogListTitle: "Most Recent",
  //        nav: require("./nav/en"),
  //        sidebar: {
  //          "/en/blogs/": "Contents",
  //          "/en/specials/": "Contents",
  //          "/en/about/": "Contents",
  //          "/en/contact/": "Contents"
  //        },
  //        profileLink: "/en/about/me",
  //        profileLinkText: "read more...",
  //        shortProfileText: "Hello. I Am shintaro kurihra, software developer",
  //      }
  //    }
  //  },
  //  plugins: [
  //    [
  //    '@vuepress/blog',
  //    {
  //       comment: [
  //          {
  //           // // Which service you'd like to use
  //           // service: 'vssue',
  //           // // The owner's name of repository to store the issues and comments.
  //           // owner: 'You',
  //           // // The name of repository to store the issues and comments.
  //           // repo: 'Your repo',
  //           // // The clientId & clientSecret introduced in OAuth2 spec.
  //           // clientId: 'Your clientId',
  //           // clientSecret: 'Your clientSecret',
  //                        // Which service you'd like to use
  //            service: 'disqus',
  //            // The owner's name of repository to store the issues and comments.
  //            shortname: 'vuepress-plugin-blog',
  //          },
  //        ],
  //    },
  //  ],
  //  [
  //    "@vuepress/search",
  //    {
  //      searchMaxSuggestions: 10,
  //      test: ["/blogs/[^/]+/"]
  //    }
  //  ],
  //  ["@vuepress/back-to-top", true],
  //  [
  //    "@vuepress/pwa",
  //    {
  //      serviceWorker: true,
  //      updatePopup: true
  //    }
  //  ],
  //    ["@vuepress/medium-zoom", true],
  //    //['@vuepress/google-analytics', {
  //    //  ga: 'UA-128189152-1'
  //    //}],
  //    [
  //      "container",
  //      {
  //        type: "vue",
  //        before: '<pre class="vue-container"><code>',
  //        after: "</code></pre>"
  //      }
  //    ],
  //    [
  //      "container",
  //      {
  //        type: "upgrade",
  //        before: info => `<UpgradePath title="${info}">`,
  //        after: "</UpgradePath>"
  //      }
  //    ]
  //  ],
  //  extraWatchFiles: [".vuepress/nav/ja.js", ".vuepress/nav/en.js", "**/*.pu"
  extraWatchFiles: [".vuepress/nav/en.js", ".vuepress/nav/zh.js"]
});
//
//function getApiSidebar() {
//  return ["cli", "node"];
//}
//
//function getGuideSidebar(groupA, groupB) {
//  return [
//    {
//      title: groupA,
//      collapsable: false,
//      children: [
//        "",
//        "getting-started",
//        "directory-structure",
//        "basic-config",
//        "assets",
//        "markdown",
//        "using-vue",
//        "i18n",
//        "deploy"
//      ]
//    },
//    {
//      title: groupB,
//      collapsable: false,
//      children: [
//        "frontmatter",
//        "permalinks",
//        "markdown-slot",
//        "global-computed"
//      ]
//    }
//  ];
//}
