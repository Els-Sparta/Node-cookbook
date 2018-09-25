#
# Cookbook:: node
# Spec:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'node::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'updates all sources' do
      expect(chef_run).to update_apt_update('update')
    end
    # looks for a package then installs
    it 'should install nginx' do
      expect(chef_run).to install_package("nginx")
    end
    # looks in existing library/recipe to install package
    it 'should install nodejs from a recipe' do
      expect(chef_run).to include_recipe("nodejs")
    end
    it 'should install pm2 via npm' do
      expect(chef_run).to install_nodejs_npm("pm2")
    end

    it 'should create a proxy.conf template in /etc/nginx/sites-available' do
      expect(chef_run).to create_template("/etc/nginx/sites-available/proxy.conf")
    end

    it 'should create a symlink of proxy.conf from sites-available to sites-enabled' do
      expect(chef_run).to create_link("/etc/nginx/sites-enabled/proxy.conf").with_link_type(:symbolic)
    end

    it 'should delete the symlink from the default config in sites-enabled' do
      expect(chef_run).to delete_link("/etc/nginx/sites-enabled/default")
    end

  end
end
