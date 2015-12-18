require 'rails_helper'

RSpec.describe 'routing to recipes api' do
  it 'routes GET /api/v1/recipes to v1/recipes#index' do
    expect(get: '/api/v1/recipes').to route_to(
      controller: 'v1/recipes',
      action: 'index',
      format: 'json'
    )
  end

  it 'routes GET /api/v1/recipes/:id to v1/recipes#show' do
    expect(get: '/api/v1/recipes/1').to route_to(
      controller: 'v1/recipes',
      action: 'show',
      id: '1',
      format: 'json'
    )
  end

  it 'routes POST /api/v1/recipes to v1/recipes#create' do
    expect(post: '/api/v1/recipes').to route_to(
      controller: 'v1/recipes',
      action: 'create',
      format: 'json'
    )
  end

  it 'routes PUT /api/v1/recipes/:id to v1/recipes#update' do
    expect(put: '/api/v1/recipes/1').to route_to(
      controller: 'v1/recipes',
      action: 'update',
      id: '1',
      format: 'json'
    )
  end

  it 'routes DELETE /api/v1/recipes/:id to v1/recipes#destroy' do
    expect(delete: '/api/v1/recipes/1').to route_to(
      controller: 'v1/recipes',
      action: 'destroy',
      id: '1',
      format: 'json'
    )
  end
end
