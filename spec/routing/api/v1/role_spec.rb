require 'rails_helper'

RSpec.describe 'routing to role api' do
  it 'routes GET /api/v1/roles to v1/roles#index' do
    expect(get: '/api/v1/roles').to route_to(
      controller: 'v1/roles',
      action: 'index',
      format: 'json'
    )
  end

  it 'routes GET /api/v1/roles/:id to v1/roles#show' do
    expect(get: '/api/v1/roles/1').to route_to(
      controller: 'v1/roles',
      action: 'show',
      id: '1',
      format: 'json'
    )
  end

  it 'routes POST /api/v1/roles to v1/roles#create' do
    expect(post: '/api/v1/roles').to route_to(
      controller: 'v1/roles',
      action: 'create',
      format: 'json'
    )
  end

  it 'routes PUT /api/v1/roles/:id to v1/roles#update' do
    expect(put: '/api/v1/roles/1').to route_to(
      controller: 'v1/roles',
      action: 'update',
      id: '1',
      format: 'json'
    )
  end

  it 'routes DELETE /api/v1/roles/:id to v1/roles#destroy' do
    expect(delete: '/api/v1/roles/1').to route_to(
      controller: 'v1/roles',
      action: 'destroy',
      id: '1',
      format: 'json'
    )
  end
end
