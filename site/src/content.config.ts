import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

const pages = defineCollection({
  loader: glob({
    base: '../content/pages',
    pattern: ['**/*.md', '!README.md'],
  }),
  schema: z.object({
    title: z.string(),
    description: z.string().optional(),

    nav: z.boolean().default(true),
    nav_order: z.number().default(100),

    draft: z.boolean().default(false),
    publishDate: z.date().optional(),

    updatedDate: z.date().optional(),

    heroImage: z.string().optional(),
  }),
});

export const collections = {
  pages,
};
