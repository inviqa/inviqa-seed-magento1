describe 'project::default' do
  context 'default run' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.converge(described_recipe)
    end

    it 'will do something' do
      pending
    end
  end
end
