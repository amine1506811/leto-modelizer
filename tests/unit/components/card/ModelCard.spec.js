import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-jest';
import { shallowMount } from '@vue/test-utils';
import ModelCard from 'src/components/card/ModelCard.vue';

installQuasarPlugin();

describe('Test component: ModelCard', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallowMount(ModelCard, {
      props: { model: { name: 'modelName' } },
    });
  });

  describe('Test prop: model', () => {
    it('should match "modelName"', () => {
      expect(wrapper.vm.model).toStrictEqual({ name: 'modelName' });
    });
  });

  describe('Test function: getModelImage', () => {
    it('should return corresponding image name', async () => {
      await wrapper.setProps({ model: { name: 'A' } });
      expect(wrapper.vm.getModelImage()).toEqual('images/project0.png');

      await wrapper.setProps({ model: { name: 'B' } });
      expect(wrapper.vm.getModelImage()).toEqual('images/project1.png');

      await wrapper.setProps({ model: { name: 'C' } });
      expect(wrapper.vm.getModelImage()).toEqual('images/project2.png');

      await wrapper.setProps({ model: { name: 'D' } });
      expect(wrapper.vm.getModelImage()).toEqual('images/project3.png');

      await wrapper.setProps({ model: { name: 'E' } });
      expect(wrapper.vm.getModelImage()).toEqual('images/project4.png');

      await wrapper.setProps({ model: { name: 'F' } });
      expect(wrapper.vm.getModelImage()).toEqual('images/project0.png');
    });
  });
});
