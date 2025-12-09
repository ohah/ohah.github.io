import * as path from 'node:path';
import { defineConfig } from '@rspress/core';
import pluginMermaid from 'rspress-plugin-mermaid';

export default defineConfig({
  root: path.join(__dirname, 'docs'),
  outDir: path.join(__dirname, 'dist'),
  title: 'ohah',
  globalStyles: path.join(__dirname, 'docs/global.css'),
  plugins: [pluginMermaid() as any],
  builderConfig: {
    resolve: {
      alias: {
        'lodash-es': require.resolve('lodash'),
      },
    },
  },
  themeConfig: {
    socialLinks: [
      {
        icon: 'github',
        mode: 'link',
        content: 'https://github.com/ohah',
      },
    ],
  },
});
