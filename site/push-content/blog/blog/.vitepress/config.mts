import { defineConfigWithTheme } from "vitepress";
import { getPosts } from "./theme/utils";
import { BlogliorelliTheme } from "./theme/types";

// https://vitepress.dev/reference/site-config
export default defineConfigWithTheme<BlogliorelliTheme>({
  lang: "en-US",
  title: "WiresNDreams",
  description: "NeoStudyhat's blog",
  cleanUrls: true,
  lastUpdated: true,
  sitemap: {
    hostname: "https://blog.wiresndreams.dev",
  },
  themeConfig: {
    // blogliorelli theme config
    cursorOffset: 10,
    posts: await getPosts(),
    // blogliorelli theme config

    logo: "/logo.ico",
    logoLink: {
      link: 'https://wiresndreams.dev',
      target: '_self' // or '_blank' to open in new tab
    },

    nav: [
      { text: "Home", link: "/" },
      { text: "Tags", link: "/tags" },
      { text: "Notes", link: "https://notes.wiresndreams.dev" },
    ],

    search: {
      provider: "local",
      options: { detailedView: true, disableQueryPersistence: true },
    },

    socialLinks: [{ icon: "github", link: "https://github.com/migliorelli" }],

    outline: {
      level: [2, 3], // Show h2 and h3 headings
      label: 'On this page' // Customize the title
    },
  },
  head: [
    [
      "link",
      {
        rel: "icon",
        type: "image/ico",
        href: "/logo.ico",
      },
    ],
    [
      "meta",
      {
        name: "author",
        content: "NeoStudyHat",
      },
    ],
  ],
});
