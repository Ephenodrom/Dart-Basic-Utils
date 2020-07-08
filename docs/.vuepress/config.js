const { description } = require('../../package')

module.exports = {
	/**
	 * Ref：https://v1.vuepress.vuejs.org/config/#title
	 */
	title: "Dart Basic Utils",
	/**
	 * Ref：https://v1.vuepress.vuejs.org/config/#description
	 */
	description: description,
	//theme: "vuepress-theme-thindark",
	/**
	 * Extra tags to be injected to the page HTML `<head>`
	 *
	 * ref：https://v1.vuepress.vuejs.org/config/#head
	 */
	head: [
		["meta", { name: "theme-color", content: "#67c1f5" }],
		["meta", { name: "apple-mobile-web-app-capable", content: "yes" }],
		["meta", { name: "apple-mobile-web-app-status-bar-style", content: "black" }],
	],
	base: "/dart-basic-utils/",
	/**
	 * Theme configuration, here is the default theme configuration for VuePress.
	 *
	 * ref：https://v1.vuepress.vuejs.org/theme/default-theme-config.html
	 */
	themeConfig: {
		repo: "https://github.com/Ephenodrom/dart-basic-utils",
		editLinks: false,
		docsDir: "",
		editLinkText: "",
		lastUpdated: false,
		nav: [
			{
				text: "Documentation",
				link: "/guide/preamble.html",
			},
			{
				text: "Pub.dev",
				link: "https://pub.dev/packages/basic_utils"
			}
		],
		sidebar: {
			"/guide/": [
				{
					title: "Introduction",
					collapsable: false,
					children: ["preamble", "installation"],
				},
				{
					title: "Util Classes",
					collapsable: false,
					children: [
						"utils/StringUtils",
						"utils/X509Utils",
						"utils/DateUtils",
						"utils/HttpUtils",
						"utils/DnsUtils",
						"utils/DomainUtils",
						"utils/IterableUtils",
						"utils/CryptoUtils",
						"utils/EmailUtils",
						"utils/MathUtils",
						"utils/SortUtils",
						"utils/ColorUtils",
					],
				}
			],
		},
	},

	/**
	 * Apply plugins，ref：https://v1.vuepress.vuejs.org/zh/plugin/
	 */
	plugins: [
		"@vuepress/plugin-back-to-top",
		"@vuepress/plugin-medium-zoom",
		"vuepress-plugin-smooth-scroll",
		[
			"vuepress-plugin-container",
			{
				type: "noheader",
				defaultTitle: "",
			},
		],
		[
			"vuepress-plugin-container",
			{
				type: "unobtrusive-info",
				defaultTitle: "",
			},
		],
	],

	markdown: {
		extendMarkdown: (md) => {
			md.set({ html: true });
			md.use(require("markdown-it-include"), "docs/guide/");
			// md.use(require('markdown-it-katex'))
			// md.use(require('markdown-it-plantuml'))
			//md.use(require("markdown-it-admonition"));
		},
	},
};
