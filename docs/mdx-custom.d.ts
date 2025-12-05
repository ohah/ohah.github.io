declare module '*.md' {
  import { Element, MDXProps } from 'mdx/types';

  export default function MDXContent(props: MDXProps): Element;

  export const frontmatter: {
    title?: string;
    date?: string;
    description?: string;
    [key: string]: unknown;
  };
}

declare module '*.mdx' {
  import { Element, MDXProps } from 'mdx/types';

  export default function MDXContent(props: MDXProps): Element;

  export const frontmatter: {
    title?: string;
    date?: string;
    description?: string;
    [key: string]: unknown;
  };
}

