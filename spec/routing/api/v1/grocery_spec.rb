require 'rails_helper'

RSpec.describe 'routing to ingredient API' do
  it 'routes GET /api/v1/groceries to v1/groceries#index' do
    expect(get: '/api/v1/groceries').to route_to(
      controller: 'v1/groceries',
      action: 'index',
      format: 'json'
    )
  end

  it 'routes GET /api/v1/groceries/:id to v1/groceries#show' do
    expect(get: '/api/v1/groceries/1').to route_to(
      controller: 'v1/groceries',
      action: 'show',
      id: '1',
      format: 'json'
    )
  end

  it 'routes POST /api/v1/groceries to v1/groceries#create' do
    expect(post: '/api/v1/groceries').to route_to(
      controller: 'v1/groceries',
      action: 'create',
      format: 'json'
    )
  end

  it 'routes PUT /api/v1/groceries/:id to v1/groceries#update' do
    expect(put: '/api/v1/groceries/1').to route_to(
      controller: 'v1/groceries',
      action: 'update',
      id: '1',
      format: 'json'
    )
  end

  it 'routes DELETE /api/v1/groceries/:id to v1/groceries#destroy' do
    expect(delete: '/api/v1/groceries/1').to route_to(
      controller: 'v1/groceries',
      action: 'destroy',
      id: '1',
      format: 'json'
    )
  end
end
