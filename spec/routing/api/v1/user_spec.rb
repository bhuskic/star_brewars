require 'rails_helper'

RSpec.describe 'routing to user api' do
  it 'routes GET /api/v1/users to v1/users#index' do
    expect(get: '/api/v1/users').to route_to(
      controller: 'v1/users',
      action: 'index',
      format: 'json'
    )
  end

  it 'routes GET /api/v1/users/:id to v1/users#show' do
    expect(get: '/api/v1/users/1').to route_to(
      controller: 'v1/users',
      action: 'show',
      id: '1',
      format: 'json'
    )
  end

  it 'routes POST /api/v1/users to v1/users#create' do
    expect(post: '/api/v1/users').to route_to(
      controller: 'v1/users',
      action: 'create',
      format: 'json'
    )
  end

  it 'routes PUT /api/v1/users/:id to v1/users#update' do
    expect(put: '/api/v1/users/1').to route_to(
      controller: 'v1/users',
      action: 'update',
      id: '1',
      format: 'json'
    )
  end

  it 'routes DELETE /api/v1/users/:id to v1/users#destroy' do
    expect(delete: '/api/v1/users/1').to route_to(
      controller: 'v1/users',
      action: 'destroy',
      id: '1',
      format: 'json'
    )
  end
end
