import { mount, createLocalVue } from '@vue/test-utils';
import Vue from 'vue';

export function mountWithPlugins(
  componentToMount,
  options = {}
) {
  const localVue = createLocalVue();

  return mount(componentToMount, {
    localVue,
    ...options
  });
}
