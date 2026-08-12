import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

const journal = defineCollection({
  loader: glob({
    base: '../content/journal',
    pattern: ['**/*.md', '!README.md'],
  }),
  schema: z.object({
    title: z.string(),
    description: z.string().optional(),

    date: z.date(),
    draft: z.boolean().default(false),

    tags: z.array(z.string()).default([]),
  }),
});

export const collections = {
  journal,
};
