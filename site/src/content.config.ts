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

const projects = defineCollection({
  loader: glob({
    base: '../content/projects',
    pattern: ['**/*.md', '!README.md'],
  }),
  schema: z.object({
    title: z.string(),
    description: z.string().optional(),

    status: z.string().optional(),
    featured: z.boolean().default(false),
    draft: z.boolean().default(false),

    startedDate: z.date().optional(),
    updatedDate: z.date().optional(),

    tags: z.array(z.string()).default([]),
  }),
});

export const collections = {
  pages,
  projects,
};
